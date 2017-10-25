//
//  LoginViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/7/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkService.h"
#import "AppDelegate.h"
//#import <CommonCrypto/CommonCryptor.h>
#import "AFNetworking.h"
#import "Config.h"
#import "MBProgressHUD.h"

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedName"];
    NSString *savedPwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPwd"];
    
    self.userNameField.text = savedName;
    self.passwordField.text = savedPwd;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
+ (void)login:(NSString *)user password:(NSString *)password success:(void(^)(NSString *userId, NSString *token))successBlock error:(void(^)(int errCode, NSString *message))errorBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[NSString stringWithFormat:@"%@:%d%@", [NSString stringWithFormat:@"http://%@", SERVER_HOST], SHORT_LINK_PORT, @"/api/login"]
       parameters:@{@"name":user, @"password":password}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dict = responseObject;
              if([dict[@"code"] intValue] == 0) {
                  NSString *userId = dict[@"result"][@"userId"];
                  NSString *token = dict[@"result"][@"token"];
                  successBlock(userId, token);
              } else {
                  errorBlock([dict[@"code"] intValue], dict[@"message"]);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              errorBlock(-1, error.description);
          }];
}
    
- (IBAction)onLoginButton:(id)sender {
    NSString *user = self.userNameField.text;
    NSString *password = self.passwordField.text;
  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"登陆中...";
  [hud showAnimated:YES];
  
    [self.class login:user password:password success:^(NSString *userId, NSString *token) {
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"savedName"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"savedPwd"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"savedToken"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"savedUserId"];
        
        [[NetworkService sharedInstance] login:userId password:token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [hud hideAnimated:YES];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *rootVC =  [sb instantiateViewControllerWithIdentifier:@"rootVC"];
            [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
        });
    } error:^(int errCode, NSString *message) {
        NSLog(@"login error with code %d, message %@", errCode, message);
      dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"登陆失败";
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.f];
      });
    }];
}
@end
