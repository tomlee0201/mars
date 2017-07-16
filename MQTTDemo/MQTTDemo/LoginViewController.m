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

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NetworkService sharedInstance] login:self.userNameField.text password:self.passwordField.text];
    }];
}
@end
