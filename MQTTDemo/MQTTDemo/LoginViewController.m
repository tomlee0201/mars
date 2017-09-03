//
//  LoginViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/7/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "NetworkService.h"
#import "AppDelegate.h"

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (rand()%2) {
        self.userNameField.text = @"user1";
        self.passwordField.text = @"jqO1RBqPweQMQ2fhLFs91ZoblwlOSnregkl4PyooJG8=";
    } else {
        self.userNameField.text = @"user2";
        self.passwordField.text = @"jqO1RBqPweRov3/TT5hBgfLYJSq7ShKvkTK5s6WviTM=";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
      [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:@"savedName"];
      [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"savedPwd"];
        [[NetworkService sharedInstance] login:self.userNameField.text password:self.passwordField.text];
      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
      UIViewController *rootVC =  [sb instantiateViewControllerWithIdentifier:@"rootVC"];
      [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
}
@end
