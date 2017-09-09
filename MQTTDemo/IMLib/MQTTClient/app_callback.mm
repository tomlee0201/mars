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
//  appcomm_callback.mm
//  MPApp
//
//  Created by yanguoyue on 16/3/3.
//  Copyright © 2016年 tencent. All rights reserved.
//

#include "app_callback.h"

#include <mars/comm/autobuffer.h>
#import <UIKit/UIKit.h>
#import "IMUtilities.h"

namespace mars {
    namespace app {

AppCallBack* AppCallBack::instance_ = NULL;

AppCallBack* AppCallBack::Instance() {
    if(instance_ == NULL) {
        instance_ = new AppCallBack();
    }
    
    return instance_;
}

void AppCallBack::Release() {
    delete instance_;
    instance_ = NULL;
}
        
    AppCallBack::AppCallBack() {
        
        
    }

        
        void AppCallBack::SetAccountUserName(const std::string &userName) {
            info.username = userName;
            
            NSString *path = [IMUtilities getDocumentPathWithComponent:[NSString stringWithUTF8String:info.username.c_str()]];
            filePath = [path UTF8String];
        }
        
        void AppCallBack::SetAccountLogoned(bool isLogoned) {
            info.is_logoned = isLogoned;
        }
        
// return your app path
std::string AppCallBack::GetAppFilePath(){
    return filePath;
}
        
AccountInfo AppCallBack::GetAccountInfo() {
    return info;
}

unsigned int AppCallBack::GetClientVersion() {
    
    return 0;
}

DeviceInfo AppCallBack::GetDeviceInfo() {
    DeviceInfo info;

    info.devicename = [[UIDevice currentDevice].identifierForVendor.UUIDString cStringUsingEncoding:NSUTF8StringEncoding];
    info.devicetype = 1;
    
    return info;
}

}}
