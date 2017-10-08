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

extern NSMutableArray* convertProtoMessageList(const std::list<mars::stn::TMessage> &messageList);

NSString *kGroupInfoUpdated = @"kGroupInfoUpdated";
NSString *kUserInfoUpdated = @"kGroupInfoUpdated";

@protocol RefreshGroupInfoDelegate <NSObject>
- (void)onGroupInfoUpdated:(NSArray<GroupInfo *> *)updatedGroupInfo;
@end

@protocol RefreshUserInfoDelegate <NSObject>
- (void)onUserInfoUpdated:(NSArray<UserInfo *> *)updatedUserInfo;
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



class RPCB : public mars::stn::ReceiveMessageCallback {
public:
  RPCB(id<ReceiveMessageDelegate> delegate) : m_delegate(delegate) {}
  
    void onReceiveMessage(const std::list<mars::stn::TMessage> &messageList, bool hasMore) {
    if (m_delegate) {
        NSMutableArray *messages = convertProtoMessageList(messageList);
        [m_delegate onReceiveMessage:messages hasMore:hasMore];
    }
  }
  id<ReceiveMessageDelegate> m_delegate;
};

UserInfo* convertUserInfo(const mars::stn::TUserInfo &tui) {
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.userId = [NSString stringWithUTF8String:tui.uid.c_str()];
    userInfo.name = [NSString stringWithUTF8String:tui.name.c_str()];
    userInfo.portrait = [NSString stringWithUTF8String:tui.portrait.c_str()];
    
    userInfo.displayName = [NSString stringWithUTF8String:tui.displayName.c_str()];
    userInfo.mobile = [NSString stringWithUTF8String:tui.mobile.c_str()];
    userInfo.email = [NSString stringWithUTF8String:tui.email.c_str()];
    userInfo.address = [NSString stringWithUTF8String:tui.address.c_str()];
    userInfo.company = [NSString stringWithUTF8String:tui.company.c_str()];
    userInfo.social = [NSString stringWithUTF8String:tui.social.c_str()];
    userInfo.extra = [NSString stringWithUTF8String:tui.extra.c_str()];
    userInfo.updateDt = tui.updateDt;
    
    return userInfo;
}

NSArray<UserInfo *>* converUserInfos(const std::list<const mars::stn::TUserInfo> &userInfoList) {
    NSMutableArray *out = [[NSMutableArray alloc] init];
    for (std::list<const mars::stn::TUserInfo>::const_iterator it = userInfoList.begin(); it != userInfoList.end(); it++) {
        [out addObject:convertUserInfo(*it)];
    }
    return out;
}

GroupInfo* convertGroupInfo(const mars::stn::TGroupInfo &tgi) {
    GroupInfo *groupInfo = [[GroupInfo alloc] init];
    groupInfo.type = (GroupType)tgi.type;
    groupInfo.target = [NSString stringWithUTF8String:tgi.target.c_str()];
    groupInfo.name = [NSString stringWithUTF8String:tgi.name.c_str()];
    groupInfo.extra = [NSData dataWithBytes:tgi.extra.c_str() length:tgi.extra.length()];
    groupInfo.portrait = [NSString stringWithUTF8String:tgi.portrait.c_str()];
    groupInfo.owner = [NSString stringWithUTF8String:tgi.owner.c_str()];
    return groupInfo;
}

NSArray<GroupInfo *>* convertGroupInfos(const std::list<const mars::stn::TGroupInfo> &groupInfoList) {
    NSMutableArray *out = [[NSMutableArray alloc] init];
    for (std::list<const mars::stn::TGroupInfo>::const_iterator it = groupInfoList.begin(); it != groupInfoList.end(); it++) {
        [out addObject:convertGroupInfo(*it)];
    }
    return out;
}

class GUCB : public mars::stn::GetUserInfoCallback {
  public:
  GUCB(id<RefreshUserInfoDelegate> delegate) : m_delegate(delegate) {}
  
  void onSuccess(const std::list<const mars::stn::TUserInfo> &userInfoList) {
      if(m_delegate) {
          [m_delegate onUserInfoUpdated:converUserInfos(userInfoList)];
      }
  }
  void onFalure(int errorCode) {
    
  }
  id<RefreshUserInfoDelegate> m_delegate;
};

class GGCB : public mars::stn::GetGroupInfoCallback {
  public:
  GGCB(id<RefreshGroupInfoDelegate> delegate) : m_delegate(delegate) {}
  
  void onSuccess(const std::list<const mars::stn::TGroupInfo> &groupInfoList) {
      if(m_delegate) {
          [m_delegate onGroupInfoUpdated:convertGroupInfos(groupInfoList)];
      }
  }
  void onFalure(int errorCode) {
  }
  id<RefreshGroupInfoDelegate> m_delegate;
};

@interface NetworkService () <ConnectionStatusDelegate, ReceiveMessageDelegate, RefreshUserInfoDelegate, RefreshGroupInfoDelegate>
@property(nonatomic, assign)ConnectionStatus currentConnectionStatus;
@property (nonatomic, strong)NSString *userId;
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
    xlogger_SetLevel(kLevelVerbose);
    appender_set_console_log(true);
#else
    xlogger_SetLevel(kLevelInfo);
    appender_set_console_log(false);
#endif
    appender_open(kAppednerAsync, [logPath UTF8String], "Test", NULL);
}

+ (void)stopLog {
    appender_close();
}

- (void)onReceiveMessage:(NSArray<Message *> *)messages hasMore:(BOOL)hasMore {
    [self.receiveMessageDelegate onReceiveMessage:messages hasMore:hasMore];
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
}

+ (NetworkService *)sharedInstance {
    if (sharedSingleton == nil) {
        @synchronized (self) {
            if (sharedSingleton == nil) {
                sharedSingleton = [[NetworkService alloc] init];
            }
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
  mars::stn::setReceiveMessageCallback(new RPCB(self));
  mars::stn::setRefreshUserInfoCallback(new GUCB(self));
  mars::stn::setRefreshGroupInfoCallback(new GGCB(self));
  mars::baseevent::OnCreate();
}

- (void)login:(NSString *)userName password:(NSString *)password {
  _logined = YES;
    mars::app::AppCallBack::Instance()->SetAccountUserName([userName UTF8String]);
  [self createMars];
  [self setLongLinkAddress:@"192.168.1.101" port:1883];
    [self setShortLinkPort:18090];
    self.userId = userName;
  std::string name([userName cStringUsingEncoding:NSUTF8StringEncoding]);
  std::string pwd([password cStringUsingEncoding:NSUTF8StringEncoding]);
  mars::stn::login(name, pwd);
    self.currentConnectionStatus = kConnectionStatusUnconnected;
  [[NetworkStatus sharedInstance] Start:[NetworkService sharedInstance]];
}

- (void)logout {
  _logined = NO;
    self.userId = nil;
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

- (void)onGroupInfoUpdated:(NSArray<GroupInfo *> *)updatedGroupInfo {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (GroupInfo *groupInfo in updatedGroupInfo) {
      [[NSNotificationCenter defaultCenter] postNotificationName:kGroupInfoUpdated object:groupInfo.target userInfo:@{@"groupInfo":groupInfo}];
    }
  });
}
  
- (void)onUserInfoUpdated:(NSArray<UserInfo *> *)updatedUserInfo {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (UserInfo *userInfo in updatedUserInfo) {
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdated object:userInfo.userId userInfo:@{@"userInfo":userInfo}];
    }
  });
}
#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
}

@end

