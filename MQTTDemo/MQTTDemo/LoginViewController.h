//
//  LoginViewController.h
//  MQTTDemo
//
//  Created by Tom Lee on 2017/7/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
+ (void)login:(NSString *)user password:(NSString *)password success:(void(^)(NSString *userId, NSString *token))successBlock error:(void(^)(int errCode, NSString *message))errorBlock;
@end
