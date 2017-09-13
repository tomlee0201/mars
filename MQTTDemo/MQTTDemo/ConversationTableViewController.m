//
//  ConversationTableViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "ConversationInfo.h"
#import "ConversationTableViewCell.h"

#import "MessageViewController.h"


#import "NetworkService.h"
#import "PublishTask.h"
#import "SubscribeTask.h"
#import "UnsubscribeTask.h"
#import "Message.h"
#import "Conversation.h"
#import "IMService.h"
#import "TextMessageContent.h"

#import "Utilities.h"
#import "UITabBar+badge.h"

@interface ConversationTableViewController ()
@property (nonatomic, strong)NSMutableArray<ConversationInfo *> *conversations;
@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversations = [[NSMutableArray alloc] init];
  [self updateConnectionStatus:[NetworkService sharedInstance].currentConnectionStatus];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectionStatusChanged:) name:@"kConnectionStatusChanged" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMessages:) name:@"kReceiveMessages" object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClearAllUnread:) name:@"kTabBarClearBadgeNotification" object:nil];
}

- (void)updateConnectionStatus:(ConnectionStatus)status {
  UIView *title;
  if (status != kConnectionStatusConnectiong) {
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, 0, 80, 44)];
    switch (status) {
      case kConnectionStatusLogout:
        navLabel.text = @"未登录";
        break;
      case kConnectionStatusUnconnected:
        navLabel.text = @"未连接";
        break;
      case kConnectionStatusConnected:
        navLabel.text = @"已连接";
        break;
        
      default:
        break;
    }
    
    navLabel.textColor = [UIColor blueColor];
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    title = navLabel;
  } else {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width/2, self.navigationController.navigationBar.bounds.size.height/2);
    [indicatorView startAnimating];
    title = indicatorView;
  }
  self.navigationItem.titleView = title;
}

- (void)onConnectionStatusChanged:(NSNotification *)notification {
  ConnectionStatus status = [notification.object intValue];
  [self updateConnectionStatus:status];
}

- (void)onReceiveMessages:(NSNotification *)notification {
  NSArray<Message *> *messages = notification.object;
  [self refreshList];
}

- (void)onClearAllUnread:(NSNotification *)notification {
    [[IMService sharedIMService] clearAllUnreadStatus];
    [self refreshList];
}

- (void)refreshList {
  self.conversations = [[[IMService sharedIMService] getConversations:@[@(0), @(1), @(2)] lines:@[@(0), @(1)]] mutableCopy];
    [self updateBadgeNumber];
  [self.tableView reloadData];
}

- (void)updateBadgeNumber {
    int count = 0;
    for (ConversationInfo *info in self.conversations) {
        count += info.unreadCount;
    }
    [self.tabBarController.tabBar showBadgeOnItemIndex:0 badgeValue:count];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refreshList];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseableConversationCell" forIndexPath:indexPath];
    
    cell.info = self.conversations[indexPath.row];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 56;
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[MessageViewController class]]) {
    MessageViewController *mvc = (MessageViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    ConversationInfo *info = self.conversations[indexPath.row];
    mvc.conversation = info.conversation;
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
