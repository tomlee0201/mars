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
//  NetworkService.h
//  iOSDemo
//
//  Created by caoshaokun on 16/11/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#ifndef NetworkService_h
#define NetworkService_h

#import <Foundation/Foundation.h>
#import "NetworkStatus.h"
#import "Message.h"

@class CGITask;
@class ViewController;


typedef NS_ENUM(NSInteger, ConnectionStatus) {
  kConnectionStatusRejected = -3,
  kConnectionStatusLogout = -2,
  kConnectionStatusUnconnected = -1,
  kConnectionStatusConnectiong = 0,
  kConnectionStatusConnected = 1
};

@protocol ConnectionStatusDelegate <NSObject>
- (void)onConnectionStatusChanged:(ConnectionStatus)status;
@end

@protocol ReceiveMessageDelegate <NSObject>
- (void)onReceiveMessage:(NSArray<Message *> *)messages hasMore:(BOOL)hasMore;
@end

@interface NetworkService : NSObject<NetworkStatusDelegate>


+ (NetworkService *)sharedInstance;
@property(nonatomic, weak) id<ConnectionStatusDelegate> connectionStatusDelegate;
@property(nonatomic, weak) id<ReceiveMessageDelegate> receiveMessageDelegate;
@property(nonatomic, assign, getter=isLogined, readonly)BOOL logined;
@property(nonatomic, assign, readonly)ConnectionStatus currentConnectionStatus;

+ (void)startLog;
+ (void)stopLog;


- (void)login:(NSString *)userName password:(NSString *)password;

- (void)logout;
- (void)setShortLinkDebugIP:(NSString *)IP port:(const unsigned short)port;
- (void)setShortLinkPort:(const unsigned short)port;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port debugIP:(NSString *)IP;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port;
- (void)reportEvent_OnForeground:(BOOL)isForeground;
- (void)registerMessageContent:(Class)contentClass;
@end

#endif /* NetworkService_hpp */
