//
//  GroupTableViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/13.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupTableViewCell.h"
#import "IMService.h"
#import "MessageViewController.h"
#import "GroupInfo.h"
#import "NetworkService.h"
#import "TextMessageContent.h"
#import "GroupMemberTableViewController.h"
#import "InviteGroupMemberViewController.h"

#import "AddGroupeMemberNotificationContent.h"
#import "KickoffGroupMemberNotificaionContent.h"
#import "QuitGroupNotificationContent.h"
#import "DismissGroupNotificationContent.h"
#import "TransferGroupOwnerNotificationContent.h"


@interface GroupTableViewController ()
@property (nonatomic, strong)NSMutableArray<GroupInfo *> *groups;
@end

@implementation GroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups = [[NSMutableArray alloc] init];
}

- (void)refreshList {
    __weak typeof(self) ws = self;
    [[IMService sharedIMService] getMyGroups:^(NSArray<NSString *> *ids) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.groups removeAllObjects];
            for (NSString *groupId in ids) {
                GroupInfo *groupInfo = [[IMService sharedIMService] getGroupInfo:groupId refresh:NO];
                groupInfo.target = groupId;
                [ws.groups addObject:groupInfo];
                [[NSNotificationCenter defaultCenter] addObserver:ws selector:@selector(onGroupInfoUpdated:) name:kGroupInfoUpdated object:groupId];
            }
            [ws.tableView reloadData];
        });
    } error:^(int error_code) {
        
    }];
}

- (void)onGroupInfoUpdated:(NSNotification *)notification {
    GroupInfo *groupInfo = notification.userInfo[@"groupInfo"];
    for (int i = 0; i < self.groups.count; i++) {
        if([self.groups[i].target isEqualToString:groupInfo.target]) {
            self.groups[i] = groupInfo;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupTableViewCell *cell = (GroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"groupCellId" forIndexPath:indexPath];
    
    cell.groupInfo = self.groups[indexPath.row];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupId = self.groups[indexPath.row].target;
    __weak typeof(self) ws = self;
    UITableViewRowAction *invite = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"邀请" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        InviteGroupMemberViewController *igmvc = [[InviteGroupMemberViewController alloc] init];
        igmvc.groupId = groupId;
        
        igmvc.inviteMember = ^(NSString *groupId, NSArray<NSString *> *memberIds) {
            AddGroupeMemberNotificationContent *content = [[AddGroupeMemberNotificationContent alloc] init];
            content.invitor = [NetworkService sharedInstance].userId;
            content.invitees = memberIds;
            [[IMService sharedIMService] addMembers:memberIds toGroup:groupId notifyLines:@[@(0)] notifyContent:content success:^{
                [ws refreshList];
            } error:^(int error_code) {
                
            }];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:igmvc];
        [ws presentViewController:nav animated:YES completion:nil];
    }];
    
    UITableViewRowAction *kickoff = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        GroupMemberTableViewController *gmtvc = [[GroupMemberTableViewController alloc] init];
        gmtvc.groupId = groupId;
        gmtvc.selectable = YES;
        gmtvc.multiSelect = YES;
        gmtvc.selectResult = ^(NSString *groupId, NSArray<NSString *> *memberIds) {
            KickoffGroupMemberNotificaionContent *content = [[KickoffGroupMemberNotificaionContent alloc] init];
            content.operateUser = [NetworkService sharedInstance].userId;
            content.kickedMembers = memberIds;
            [[IMService sharedIMService] kickoffMembers:memberIds fromGroup:groupId notifyLines:@[@(0)] notifyContent:content success:^{
                [ws refreshList];
            } error:^(int error_code) {
                
            }];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gmtvc];
        [ws presentViewController:nav animated:YES completion:nil];
    }];
    
    UITableViewRowAction *transfer = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"转让" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        GroupMemberTableViewController *gmtvc = [[GroupMemberTableViewController alloc] init];
        gmtvc.groupId = groupId;
        gmtvc.selectable = YES;
        gmtvc.multiSelect = NO;
        gmtvc.selectResult = ^(NSString *groupId, NSArray<NSString *> *memberIds) {
            if (memberIds.count == 0) {
                return;
            }
            TransferGroupOwnerNotificationContent *content = [[TransferGroupOwnerNotificationContent alloc] init];
            content.operateUser = [NetworkService sharedInstance].userId;
            content.owner = memberIds[0];
            [[IMService sharedIMService] transferGroup:groupId to:memberIds[0] notifyLines:@[@(0)] notifyContent:content success:^{
                [ws refreshList];
            } error:^(int error_code) {
                
            }];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gmtvc];
        [ws presentViewController:nav animated:YES completion:nil];
    }];

    
    UITableViewRowAction *quit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"退出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        QuitGroupNotificationContent *content = [[QuitGroupNotificationContent alloc] init];
        content.quitMember = [NetworkService sharedInstance].userId;
        //Todo: add animination here
        [[IMService sharedIMService] quitGroup:groupId notifyLines:@[@(0)] notifyContent:content success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws refreshList];
            });
        } error:^(int error_code) {
            
        }];
    }];
    
    UITableViewRowAction *dismiss = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解散" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        DismissGroupNotificationContent *content = [[DismissGroupNotificationContent alloc] init];
        content.operateUser = [NetworkService sharedInstance].userId;
        
        //Todo: add animination here
        [[IMService sharedIMService] dismissGroup:groupId notifyLines:@[@(0)] notifyContent:content success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws refreshList];
            });
        } error:^(int error_code) {
            
        }];

    }];
    
    kickoff.backgroundColor = [UIColor purpleColor];
    transfer.backgroundColor = [UIColor orangeColor];
    
    GroupInfo *groupInfo = self.groups[indexPath.row];
    if (groupInfo == nil || groupInfo.name.length == 0) {
        return @[];
    } else {
        switch (groupInfo.type) {
            case GroupType_Free:
                return @[invite, quit];
                break;
                
            case GroupType_Normal:
                if ([groupInfo.owner isEqualToString:[NetworkService sharedInstance].userId]) {
                    return @[dismiss, transfer, kickoff, invite];
                } else {
                    return @[quit, invite];
                }
                break;
                
            case GroupType_Restricted:
                if ([groupInfo.owner isEqualToString:[NetworkService sharedInstance].userId]) {
                    return @[dismiss, transfer, kickoff, invite];
                } else {
                    return @[quit];
                }
            default:
                break;
        }
    }
    

    return @[];
};

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[MessageViewController class]]) {
        MessageViewController *mvc = (MessageViewController *)segue.destinationViewController;
        NSString *groupId = self.groups[self.tableView.indexPathForSelectedRow.row].target;
        mvc.conversation = [Conversation conversationWithType:Group_Type target:groupId line:0];
    }
}


@end
