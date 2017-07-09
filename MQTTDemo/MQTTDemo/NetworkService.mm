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

#import "NetworkDelegate.h"


#import "app_callback.h"

#include <mars/app/app_logic.h>
#include <mars/baseevent/base_logic.h>
#include <mars/xlog/xlogger.h>
#include <mars/xlog/xloggerbase.h>
#include <mars/xlog/appender.h>
#include <mars/stn/stn.h>
#include <mars/stn/stn_logic.h>

@protocol ConnectionStatusDelegate <NSObject>
- (void)onConnectionStatusChanged:(int)status;
@end
@protocol ReceivePublishDelegate <NSObject>
- (void)onReceivePublish:(NSString *)topic message:(NSData *)data;
@end

class CSCB : public mars::stn::ConnectionStatusCallback {
public:
  CSCB(id<ConnectionStatusDelegate> delegate) : m_delegate(delegate) {}
  void onConnectionStatusChanged(mars::stn::ConnectionStatus connectionStatus) {
    if (m_delegate) {
      [m_delegate onConnectionStatusChanged:connectionStatus];
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

@end

@implementation NetworkService

static NetworkService * sharedSingleton = nil;

- (void)onConnectionStatusChanged:(int)status {
  
}

- (void)onReceivePublish:(NSString *)topic message:(NSData *)data {
  NSLog(@"Received topic(%@), content(%@)", topic, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

+ (NetworkService*)sharedInstance {
    @synchronized (self) {
        if (sharedSingleton == nil) {
            sharedSingleton = [[NetworkService alloc] init];
        }
    }

    return sharedSingleton;
}

- (void)dealloc {
    
}

- (void)setCallBack {
    mars::app::SetCallback(mars::app::AppCallBack::Instance());
  mars::stn::setConnectionStatusCallback(new CSCB(self));
  mars::stn::setReceivePublishCallback(new RPCB(self));
}

- (void) createMars {
    mars::baseevent::OnCreate();
}

- (void)setUserName:(NSString *)userName password:(NSString *)password {
  std::string name([userName cStringUsingEncoding:NSUTF8StringEncoding]);
  std::string pwd([password cStringUsingEncoding:NSUTF8StringEncoding]);
  mars::stn::login(name, pwd);
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
    mars::baseevent::OnDestroy();
}


// event reporting
- (void)reportEvent_OnForeground:(BOOL)isForeground {
    mars::baseevent::OnForeground(isForeground);
}

- (void)reportEvent_OnNetworkChange {
    mars::baseevent::OnNetworkChange();
}


- (NSArray *)OnNewDns:(NSString *)address {
    return [_delegate OnNewDns:address];
}

- (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data {
    return [_delegate OnPushWithCmd:cid data:data];
}



- (void)OnConnectionStatusChange:(int32_t)status longConnStatus:(int32_t)longConnStatus {
    [_delegate OnConnectionStatusChange:status longConnStatus:longConnStatus];
}

#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
    
}

@end

