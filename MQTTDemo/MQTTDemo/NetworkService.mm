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

#import "app_callback.h"

#include <mars/app/app_logic.h>
#include <mars/baseevent/base_logic.h>
#include <mars/xlog/xlogger.h>
#include <mars/xlog/xloggerbase.h>
#include <mars/xlog/appender.h>
#include <mars/stn/stn.h>
#include <mars/stn/stn_logic.h>

@protocol DisconnectDelegate  <NSObject>
- (void)onDisconnected;
@end

class DisconnectCallback : public mars::stn::MQTTDisconnectCallback {
private:
  id<DisconnectDelegate> m_delegate;
public:
  DisconnectCallback(id<DisconnectDelegate> delegate) : m_delegate(delegate) {};
  virtual void onDisconnected() {
    [m_delegate onDisconnected];
    delete this;
  }
};


class CSCB : public mars::stn::ConnectionStatusCallback {
public:
  CSCB(id<ConnectionStatusDelegate> delegate) : m_delegate(delegate) {
  }
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

@interface NetworkService () <ConnectionStatusDelegate, ReceivePublishDelegate, DisconnectDelegate>

@end

@implementation NetworkService

static NetworkService * sharedSingleton = nil;

- (void)onDisconnected {
  mars::baseevent::OnDestroy();
}

- (void)onConnectionStatusChanged:(int)status {
  NSLog(@"Connection statuc changed to (%d)", status);
  if (!_logined) {
    [self logout];
    return;
  }
  if (_connectionStatusDelegate) {
    [_connectionStatusDelegate onConnectionStatusChanged:status];
  }
}

- (void)onReceivePublish:(NSString *)topic message:(NSData *)data {
  NSLog(@"Received topic(%@), content(%@)", topic, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  if (_receivePublishDelegate) {
    [_receivePublishDelegate onReceivePublish:topic message:data];
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
  [self setLongLinkAddress:@"localhost" port:1883];
  std::string name([userName cStringUsingEncoding:NSUTF8StringEncoding]);
  std::string pwd([password cStringUsingEncoding:NSUTF8StringEncoding]);
  mars::stn::login(name, pwd);
  [[NetworkStatus sharedInstance] Start:[NetworkService sharedInstance]];
}

- (void)logout {
  _logined = NO;
  if (mars::stn::getConnectionStatus() != mars::stn::kConnectionStatusConnected) {
    [self destroyMars];
  } else {
    mars::stn::MQTTDisconnectTask *disconnectTask = new mars::stn::MQTTDisconnectTask(new DisconnectCallback(self));
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

- (void)reportEvent_OnNetworkChange {
    mars::baseevent::OnNetworkChange();
}


#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
    
}

@end

