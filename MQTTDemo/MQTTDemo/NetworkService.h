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

@class CGITask;
@class ViewController;

@protocol ConnectionStatusDelegate <NSObject>
- (void)onConnectionStatusChanged:(int)status;
@end

@protocol ReceivePublishDelegate <NSObject>
- (void)onReceivePublish:(NSString *)topic message:(NSData *)data;
@end

@interface NetworkService : NSObject<NetworkStatusDelegate>


+ (NetworkService*)sharedInstance;
@property(nonatomic, weak) id<ConnectionStatusDelegate> connectionStatusDelegate;
@property(nonatomic, weak) id<ReceivePublishDelegate> receivePublishDelegate;

- (void)createMars;

- (void)login:(NSString *)userName password:(NSString *)password;

- (void)logout;
- (void)setShortLinkDebugIP:(NSString *)IP port:(const unsigned short)port;
- (void)setShortLinkPort:(const unsigned short)port;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port debugIP:(NSString *)IP;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port;

- (void)destroyMars;

- (void)reportEvent_OnForeground:(BOOL)isForeground;
- (void)reportEvent_OnNetworkChange;
@end

#endif /* NetworkService_hpp */
