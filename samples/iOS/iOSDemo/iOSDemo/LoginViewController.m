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
//  LoginViewController.m
//  iOSDemo
//
//  Created by Hanguang on 2017/1/10.
//  Copyright © 2017年 曹少琨. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ConnectTask.h"
#import "NetworkService.h"

@interface LoginViewController () <UITextFieldDelegate, UINotifyDelegate>
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.username = textField.text;
//        [self dismissViewControllerAnimated:YES completion:nil];
      
      ConnectTask *connect = [[ConnectTask alloc] initAll:ChannelType_LongConn AndCmdId:10  AndCGIUri:nil AndHost:nil];
      [[NetworkService sharedInstance] startTask:connect ForUI:self];
      
    }
    return NO;
}

-(NSData*)requestSendData {
  return [@"Hello" dataUsingEncoding:kCFStringEncodingUTF8];
}

-(int)onPostDecode:(NSData*)responseData {
  return 0;
}

-(int)onTaskEnd:(uint32_t)tid errType:(uint32_t)errtype errCode:(uint32_t)errcode {
  [self dismissViewControllerAnimated:YES completion:nil];
  return 0;
}

@end
