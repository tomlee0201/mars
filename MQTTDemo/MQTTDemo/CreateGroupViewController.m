//
//  CreateGroupViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/14.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "IMService.h"
#import "TextMessageContent.h"
#import "CreateGroupNotificationContent.h"
#import "NetworkService.h"

@interface CreateGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *member1Field;
@property (weak, nonatomic) IBOutlet UITextField *member2Field;
@property (weak, nonatomic) IBOutlet UITextField *member3Field;
@property (weak, nonatomic) IBOutlet UITextField *member4Field;
@property (weak, nonatomic) IBOutlet UITextField *member5Field;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onDone:(id)sender {
    NSMutableArray *membes = [[NSMutableArray alloc] init];
    if ([self.member1Field.text length]) {
        [membes addObject:self.member1Field.text];
    }
    
    if ([self.member2Field.text length]) {
        [membes addObject:self.member2Field.text];
    }
    
    if ([self.member3Field.text length]) {
        [membes addObject:self.member3Field.text];
    }
    
    if ([self.member4Field.text length]) {
        [membes addObject:self.member4Field.text];
    }
    
    if ([self.member5Field.text length]) {
        [membes addObject:self.member5Field.text];
    }
    
    CreateGroupNotificationContent *notifyContent = [[CreateGroupNotificationContent alloc] init];
    notifyContent.creator = [NetworkService sharedInstance].userId;
    notifyContent.groupName = self.nameField.text;
    
    [[IMService sharedIMService] createGroup:nil name:self.nameField.text portrait:nil members:membes notifyLines:@[@(0)] notifyContent:notifyContent success:^(NSString *groupId) {
        NSLog(@"create group success");
    } error:^(int error_code) {
        NSLog(@"create group failure");
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
