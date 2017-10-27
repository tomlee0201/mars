//
//  ProfileTableViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/22.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "SDWebImage.h"
#import "IMService.h"
#import "MessageViewController.h"
#import "MBProgressHUD.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *mobileCell;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *socialCell;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *sendMessageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *voipCallCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addFriendCell;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.portrait] placeholderImage: [UIImage imageNamed:@"PersonalChat"]];
    [self.nameLabel setText:self.userInfo.name];
    self.displayNameLabel.text = self.userInfo.displayName;
    
    if (self.userInfo.mobile.length > 0) {
        self.mobileLabel.text = self.userInfo.mobile;
    } else {
        self.mobileCell.hidden = YES;
    }
    
    if (self.userInfo.email.length > 0) {
        self.emailLabel.text = self.userInfo.email;
    } else {
        self.emailCell.hidden = YES;
    }
    
    if (self.userInfo.address.length) {
        self.addressLabel.text = self.userInfo.address;
    } else {
        self.addressCell.hidden = YES;
    }
    
    if (self.userInfo.company.length) {
        self.companyLabel.text = self.userInfo.company;
    } else {
        self.companyCell.hidden = YES;
    }
    
    if (self.userInfo.social.length) {
        self.socialLabel.text = self.userInfo.social;
    } else {
        self.socialCell.hidden = YES;
    }
    
    if ([[IMService sharedIMService] isMyFriend:self.userInfo.userId]) {
        self.addFriendCell.hidden = YES;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (IBAction)onSendMessageBtn:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *mvc = [sb instantiateViewControllerWithIdentifier:@"messageVC"];
    mvc.conversation = [Conversation conversationWithType:Single_Type target:self.userInfo.userId line:0];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (IBAction)onVoipCallBtn:(id)sender {
    
}

- (IBAction)onAddFriendBtn:(id)sender {
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"更新中...";
    [hud showAnimated:YES];
    
    [[IMService sharedIMService] sendFriendRequest:self.userInfo.userId reason:@"请求添加您为好友" success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text = @"请求发送成功";
            [hud hideAnimated:YES afterDelay:1.f];
        });
    } error:^(int error_code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text = @"请求发送失败";
            [hud hideAnimated:YES afterDelay:1.f];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
