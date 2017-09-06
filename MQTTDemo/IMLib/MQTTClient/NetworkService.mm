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
#import <objc/runtime.h>
#import <mars/stn/MessageDB.hpp>


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

static Message *convertProtoMessage(const mars::stn::TMessage *tMessage) {
    Message *ret = [[Message alloc] init];
    ret.fromUser = [NSString stringWithUTF8String:tMessage->from.c_str()];
    ret.conversation = [[Conversation alloc] init];
    ret.conversation.type = (ConversationType)tMessage->conversationType;
    ret.conversation.target = [NSString stringWithUTF8String:tMessage->target.c_str()];
    ret.messageId = tMessage->messageId;
    ret.messageUid = tMessage->messageUid;
    ret.serverTime = tMessage->timestamp;
    ret.direction = (MessageDirection)tMessage->direction;
    ret.status = (MessageStatus)tMessage->status;
  
    MediaMessagePayload *payload = [[MediaMessagePayload alloc] init];
    payload.contentType = tMessage->content.type;
    payload.searchableContent = [NSString stringWithUTF8String:tMessage->content.searchableContent.c_str()];
    payload.pushContent = [NSString stringWithUTF8String:tMessage->content.pushContent.c_str()];
    
    payload.content = [NSString stringWithUTF8String:tMessage->content.content.c_str()];
    payload.binaryContent = [NSData dataWithBytes:tMessage->content.binaryContent.c_str() length:tMessage->content.binaryContent.length()];
    payload.localContent = [NSString stringWithUTF8String:tMessage->content.localContent.c_str()];
    payload.mediaType = (MediaType)tMessage->content.mediaType;
    payload.remoteMediaUrl = [NSString stringWithUTF8String:tMessage->content.remoteMediaUrl.c_str()];
    payload.localMediaPath = [NSString stringWithUTF8String:tMessage->content.localMediaPath.c_str()];
    
    ret.content = [[NetworkService sharedInstance] messageContentFromPayload:payload];
    return ret;
}

static NSMutableArray* convertProtoMessageList(const std::list<mars::stn::TMessage> &messageList) {
  NSMutableArray *messages = [[NSMutableArray alloc] init];
  for (std::list<mars::stn::TMessage>::const_iterator it = messageList.begin(); it != messageList.end(); it++) {
    const mars::stn::TMessage &tmsg = *it;
    Message *msg = convertProtoMessage(&tmsg);
    [messages addObject:msg];
    
  }
  return messages;
}

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


@interface NetworkService () <ConnectionStatusDelegate, ReceiveMessageDelegate>
@property(nonatomic, assign)ConnectionStatus currentConnectionStatus;
@property(nonatomic, strong)NSMutableDictionary<NSNumber *, Class> *MessageContentMaps;
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
                sharedSingleton.MessageContentMaps = [[NSMutableDictionary alloc] init];
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
  mars::baseevent::OnCreate();
}

- (void)login:(NSString *)userName password:(NSString *)password {
  _logined = YES;
    mars::app::AppCallBack::Instance()->SetAccountUserName([userName UTF8String]);
  [self createMars];
  [self setLongLinkAddress:@"www.liyufan.win" port:1883];
    [self setShortLinkPort:80];
  
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

- (MessageContent *)messageContentFromPayload:(MessagePayload *)payload {
    int contenttype = payload.contentType;
    Class contentClass = self.MessageContentMaps[@(contenttype)];
    if (contentClass != nil) {
        id messageInstance = [[contentClass alloc] init];
        
        if ([contentClass conformsToProtocol:@protocol(MessageContent)]) {
            if ([messageInstance respondsToSelector:@selector(decode:)]) {
                [messageInstance performSelector:@selector(decode:)
                                      withObject:payload];
            }
        }
        return messageInstance;
    }
    return nil;
}

- (void)registerMessageContent:(Class)contentClass {
    int contenttype;
    if (class_getClassMethod(contentClass, @selector(getContentType))) {
        contenttype = [contentClass getContentType];
        self.MessageContentMaps[@(contenttype)] = contentClass;
    } else {
        return;
    }
}

- (NSArray<ConversationInfo *> *)getConversations:(NSArray<NSNumber *> *)conversationTypes {
  std::list<int> types;
  for (NSNumber *type in conversationTypes) {
    types.push_back([type intValue]);
  }
  std::list<mars::stn::TConversation> convers = mars::stn::MessageDB::Instance()->GetConversationList(types);
  NSMutableArray *ret = [[NSMutableArray alloc] init];
  for (std::list<mars::stn::TConversation>::iterator it = convers.begin(); it != convers.end(); it++) {
    mars::stn::TConversation &tConv = *it;
    ConversationInfo *info = [[ConversationInfo alloc] init];
    info.conversation = [[Conversation alloc] init];
    info.conversation.type = (ConversationType)tConv.conversationType;
    info.conversation.target = [NSString stringWithUTF8String:tConv.target.c_str()];
    info.lastMessage = convertProtoMessage(&tConv.lastMessage);
    info.draft = [NSString stringWithUTF8String:tConv.draft.c_str()];
    info.timestamp = tConv.timestamp;
    info.unreadCount = tConv.unreadCount;
    info.isTop = tConv.isTop;
    [ret addObject:info];
  }
  return ret;
}

- (NSArray<Message *> *)getMessages:(Conversation *)conversation from:(NSUInteger)fromIndex count:(NSUInteger)count {
  std::list<mars::stn::TMessage> messages = mars::stn::MessageDB::Instance()->GetMessages(conversation.type, [conversation.target UTF8String], true, count, fromIndex);
  return convertProtoMessageList(messages);
}
#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
}

@end

