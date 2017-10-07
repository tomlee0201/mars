//
//  SettingTableViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/6.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserInfo.h"
#import "IMService.h"
#import "NetworkService.h"
#import "SDWebImage.h"


@interface SettingTableViewController ()
  @property (weak, nonatomic) IBOutlet UIImageView *myPortraitView;
  @property (weak, nonatomic) IBOutlet UILabel *myDisplayNameLabel;
  @property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
  @property (nonatomic, strong)UserInfo *myInfo;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoUpdated:) name:kUserInfoUpdated object:[NetworkService sharedInstance].userId];
    
    self.title = @"设置";
    
    self.myPortraitView.autoresizingMask = UIViewAutoresizingNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myInfo = [[IMService sharedIMService] getUserInfo:[NetworkService sharedInstance].userId refresh:YES];
}

  - (void)onUserInfoUpdated:(NSNotification *)notification {
    UserInfo *userInfo = notification.userInfo[@"userInfo"];
    self.myInfo = userInfo;
  }
  
  - (void)setMyInfo:(UserInfo *)myInfo {
    _myInfo = myInfo;
    [self.myPortraitView sd_setImageWithURL:[NSURL URLWithString:myInfo.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    self.myNameLabel.text = myInfo.name;
    self.myDisplayNameLabel.text = myInfo.displayName;
  }
  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedPwd"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedUserId"];
        [[NetworkService sharedInstance] logout];

    }
}
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
