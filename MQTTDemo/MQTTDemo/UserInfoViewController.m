//
//  UserInfoViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/15.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NetworkService.h"
#import "IMService.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NetworkService sharedInstance].userId isEqualToString:self.userInfo.userId]) {
        //Todo show self info
    } else {
        //Todo show friend buttun;
        if ([[IMService sharedIMService] isMyFriend:self.userInfo.userId]) {
            
        } else {
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
