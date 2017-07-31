// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

//
//  NetworkService.mm
//  iOSDemo
//
//  Created by caoshaokun on 16/11/23.
//  Copyright © 2016年 caoshaokun. All rights reserved.
//

#include "NetworkService.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <sys/xattr.h>

#import "app_callback.h"

#include <mars/app/app_logic.h>
#include <mars/baseevent/base_logic.h>
#include <mars/xlog/xlogger.h>
#include <mars/xlog/xloggerbase.h>
#include <mars/xlog/appender.h>
#include <mars/stn/stn.h>
#include <mars/stn/stn_logic.h>
#import "PublishTask.h"
#import "NotifyMessage.pbobjc.h"
#import "PullMessageResult.pbobjc.h"
#import "PullMessageRequest.pbobjc.h"
#import "Message.pbobjc.h"
#import "CreateGroupRequest.pbobjc.h"
#import "Group.pbobjc.h"
#import "MessageContent.pbobjc.h"
#import "AddGroupMemberRequest.pbobjc.h"
#import "QuitGroupRequest.pbobjc.h"
#import "DismissGroupRequest.pbobjc.h"
#import "ModifyGroupInfoRequest.pbobjc.h"
#import "RemoveGroupMemberRequest.pbobjc.h"
#import "IdListBuf.pbobjc.h"
#import "IdBuf.pbobjc.h"
#import "PullGroupInfoResult.pbobjc.h"
#import "PullGroupMemberResult.pbobjc.h"

NSString *sendMessageTopic = @"MS";
NSString *pullMessageTopic = @"MP";
NSString *notifyMessageTopic = @"MN";

NSString *createGroupTopic = @"GC";
NSString *addGroupMemberTopic = @"GAM";
NSString *kickoffGroupMemberTopic = @"GKM";
NSString *quitGroupTopic = @"GQ";
NSString *dismissGroupTopic = @"GD";
NSString *modifyGroupInfoTopic = @"GMI";
NSString *getGroupInfoTopic = @"GPGI";
NSString *getGroupMemberTopic = @"GPGM";

@protocol ReceivePublishDelegate <NSObject>
- (void)onReceivePublish:(NSString *)topic message:(NSData *)data;
@end


class CSCB : public mars::stn::ConnectionStatusCallback {
public:
  CSCB(id<ConnectionStatusDelegate> delegate) : m_delegate(delegate) {
  }
  void onConnectionStatusChanged(mars::stn::ConnectionStatus connectionStatus) {
    if (m_delegate) {
      [m_delegate onConnectionStatusChanged:(ConnectionStatus)connectionStatus];
    }
  }
  id<ConnectionStatusDelegate> m_delegate;
};

class RPCB : public mars::stn::ReceivePublishCallback {
public:
  RPCB(id<ReceivePublishDelegate> delegate) : m_delegate(delegate) {}
  
  void onReceivePublish(const std::string &topic, const unsigned char* data, size_t len) {
    if (m_delegate) {
      [m_delegate onReceivePublish:[NSString stringWithUTF8String:topic.c_str()] message:[NSData dataWithBytes:data length:len]];
    }
  }
  id<ReceivePublishDelegate> m_delegate;
};

@interface NetworkService () <ConnectionStatusDelegate, ReceivePublishDelegate>
@property(nonatomic, assign)ConnectionStatus currentConnectionStatus;
@end

@implementation NetworkService

static NetworkService * sharedSingleton = nil;
+ (void)startLog {
    NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/log"];
    
    // set do not backup for logpath
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    // init xlog
#if DEBUG
    xlogger_SetLevel(kLevelDebug);
    appender_set_console_log(true);
#else
    xlogger_SetLevel(kLevelInfo);
    appender_set_console_log(false);
#endif
    appender_open(kAppednerAsync, [logPath UTF8String], "Test");
}

+ (void)stopLog {
    appender_close();
}

- (void)pullMsg:(long long)messageId {
  static long long currentMessageId = 0;
  if (currentMessageId >= messageId) {
    return;
  }
  PullMessageRequest *request = [[PullMessageRequest alloc] init];
  request.id_p = currentMessageId;
  request.type = PullType_PullNormal;
  
  NSData *data = request.data;
  PublishTask *publishTask = [[PublishTask alloc] initWithTopic:pullMessageTopic message:data];
  
  __weak typeof(self)weakSelf = self;
  [publishTask send:^(NSData *data){
    if (data) {
      PullMessageResult *result = [PullMessageResult parseFromData:data error:nil];
      if (result) {
        currentMessageId = result.current;
        [weakSelf pullMsg:result.head];
        [weakSelf.receiveMessageDelegate onReceiveMessage:result.messageArray hasMore:currentMessageId < result.head];
      }
    }
  } error:^(int error_code) {

  }];

}

- (void)onDisconnected {
  mars::baseevent::OnDestroy();
}

- (void)setCurrentConnectionStatus:(ConnectionStatus)currentConnectionStatus {
    NSLog(@"Connection status changed to (%ld)", (long)currentConnectionStatus);
    if (_currentConnectionStatus != currentConnectionStatus) {
        _currentConnectionStatus = currentConnectionStatus;
        if (_connectionStatusDelegate) {
            [_connectionStatusDelegate onConnectionStatusChanged:currentConnectionStatus];
        }
    }
}
- (void)onConnectionStatusChanged:(ConnectionStatus)status {
  if (!_logined || kConnectionStatusRejected == status) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        [self logout];
    });
    return;
  }
    self.currentConnectionStatus = status;
  if (status == kConnectionStatusConnected) {
    [self pullMsg:1000000L];
  }
}

- (void)onReceivePublish:(NSString *)topic message:(NSData *)data {
  NSLog(@"Received topic(%@), content(%@)", topic, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  if ([topic isEqualToString:notifyMessageTopic]) {
    NotifyMessage *notifyMsg = [NotifyMessage parseFromData:data error:nil];
    if (notifyMsg != nil) {
      [self pullMsg:notifyMsg.head];
    }
    return;
  }
}

+ (NetworkService*)sharedInstance {
    @synchronized (self) {
        if (sharedSingleton == nil) {
            sharedSingleton = [[NetworkService alloc] init];
        }
    }

    return sharedSingleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentConnectionStatus = kConnectionStatusLogout;;
    }
    return self;
}

- (void)dealloc {
    
}

- (void) createMars {
  mars::app::SetCallback(mars::app::AppCallBack::Instance());
  mars::stn::setConnectionStatusCallback(new CSCB(self));
  mars::stn::setReceivePublishCallback(new RPCB(self));
  mars::baseevent::OnCreate();
}

- (void)login:(NSString *)userName password:(NSString *)password {
  _logined = YES;
  [self createMars];
//  [self setLongLinkAddress:@"www.liyufan.win" port:11883];
    [self setLongLinkAddress:@"192.168.1.109" port:1883];
  //[self setLongLinkAddress:@"172.16.11.120" port:1883];
  
  std::string name([userName cStringUsingEncoding:NSUTF8StringEncoding]);
  std::string pwd([password cStringUsingEncoding:NSUTF8StringEncoding]);
  mars::stn::login(name, pwd);
    self.currentConnectionStatus = kConnectionStatusUnconnected;
  [[NetworkStatus sharedInstance] Start:[NetworkService sharedInstance]];
}

- (void)logout {
  _logined = NO;
    self.currentConnectionStatus = kConnectionStatusLogout;
  if (mars::stn::getConnectionStatus() != mars::stn::kConnectionStatusConnected) {
    [self destroyMars];
  } else {
    mars::stn::MQTTDisconnectTask *disconnectTask = new mars::stn::MQTTDisconnectTask();
    mars::stn::StartTask(*disconnectTask);
  }
}

- (void)setShortLinkDebugIP:(NSString *)IP port:(const unsigned short)port {
    std::string ipAddress([IP UTF8String]);
    mars::stn::SetShortlinkSvrAddr(port, ipAddress);
}

- (void)setShortLinkPort:(const unsigned short)port {
    mars::stn::SetShortlinkSvrAddr(port, "");
}

- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port debugIP:(NSString *)IP {
    std::string ipAddress([string UTF8String]);
    std::string debugIP([IP UTF8String]);
    std::vector<uint16_t> ports;
    ports.push_back(port);
    mars::stn::SetLonglinkSvrAddr(ipAddress,ports,debugIP);
}

- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port {
    std::string ipAddress([string UTF8String]);
    std::vector<uint16_t> ports;
    ports.push_back(port);
    mars::stn::SetLonglinkSvrAddr(ipAddress, ports, "");
}


- (void)destroyMars {
  [[NetworkStatus sharedInstance] Stop];
    mars::baseevent::OnDestroy();
}


// event reporting
- (void)reportEvent_OnForeground:(BOOL)isForeground {
    mars::baseevent::OnForeground(isForeground);
}

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock {
  
  CreateGroupRequest *request = [[CreateGroupRequest alloc] init];
  request.group.groupInfo.targetId = groupId;
  request.group.groupInfo.name = groupName;
  request.group.groupInfo.portrait = groupPortrait;
  [request.group.membersArray addObjectsFromArray:groupMembers];
  request.notifyContent = notifyContent;
  
  
  NSData *data = request.data;
  PublishTask *publishTask = [[PublishTask alloc] initWithTopic:createGroupTopic message:data];
  

  [publishTask send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock(groupId);
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock {
  AddGroupMemberRequest *request = [[AddGroupMemberRequest alloc] init];
  request.groupId = groupId;
  [request.addedMemberArray addObjectsFromArray:members];
  request.notifyContent = notifyContent;
  
  NSData *data = request.data;
  PublishTask *addMemberTask = [[PublishTask alloc] initWithTopic:addGroupMemberTopic message:data];
  

  [addMemberTask send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock();
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock {
  RemoveGroupMemberRequest *request = [[RemoveGroupMemberRequest alloc] init];
  request.groupId = groupId;
  [request.removedMemberArray addObjectsFromArray:members];
  request.notifyContent = notifyContent;
  
  NSData *data = request.data;
  PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:kickoffGroupMemberTopic message:data];
  

  [removeMemberTask send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock();
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {
  QuitGroupRequest *request = [[QuitGroupRequest alloc] init];
  request.groupId = groupId;
  request.notifyContent = notifyContent;
  
  NSData *data = request.data;
  PublishTask *task = [[PublishTask alloc] initWithTopic:quitGroupTopic message:data];
  

  [task send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock();
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {
  DismissGroupRequest *request = [[DismissGroupRequest alloc] init];
  request.groupId = groupId;
  request.notifyContent = notifyContent;
  
  NSData *data = request.data;
  PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:dismissGroupTopic message:data];
  

  [removeMemberTask send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock();
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
          notifyContent:(MessageContent *)notifyContent
                success:(void(^)())successBlock
                  error:(void(^)(int error_code))errorBlock {
  ModifyGroupInfoRequest *request = [[ModifyGroupInfoRequest alloc] init];
  request.groupInfo = groupInfo;
  request.notifyContent = notifyContent;
  
  NSData *data = request.data;
  PublishTask *task = [[PublishTask alloc] initWithTopic:modifyGroupInfoTopic message:data];
  

  [task send:^(NSData *data){
    if (data) {
      if (successBlock) {
        successBlock();
      }
    }
  } error:^(int error_code) {
    if (errorBlock) {
      errorBlock(error_code);
    }
  }];
}
  
- (void)getGroupInfo:(NSArray<NSString *> *)groupIds success:(void(^)(NSArray<GroupInfo *> *))successBlock error:(void(^)(int error_code))errorBlock {
  IDListBuf *request = [[IDListBuf alloc] init];
  [request.idArray addObjectsFromArray:groupIds];
  
  NSData *data = request.data;
  PublishTask *task = [[PublishTask alloc] initWithTopic:getGroupInfoTopic message:data];
  

  [task send:^(NSData *data){
    if (data) {
      PullGroupInfoResult *result = [PullGroupInfoResult parseFromData:data error:nil];
      successBlock(result.infoArray);
    }
  } error:^(int error_code) {
    errorBlock(error_code);
  }];
}
  
- (void)getGroupMembers:(NSString *)groupId success:(void(^)(NSArray<NSString *> *))successBlock error:(void(^)(int error_code))errorBlock {
  IDBuf *request = [[IDBuf alloc] init];
  request.id_p = groupId;
   
  NSData *data = request.data;
  PublishTask *task = [[PublishTask alloc] initWithTopic:getGroupMemberTopic message:data];
  

  [task send:^(NSData *data){
    if (data) {
      PullGroupMemberResult *result = [PullGroupMemberResult parseFromData:data error:nil];
      successBlock(result.memberArray);
    }
  } error:^(int error_code) {
    errorBlock(error_code);
  }];
}

#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
    
}

@end

