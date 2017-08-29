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
#import "LoginViewController.h"
#import "NetworkService.h"
#import "PublishTask.h"
#import "SubscribeTask.h"
#import "UnsubscribeTask.h"
#import "Message.h"
#import "Conversation.h"
#import "IMService.h"
#import "TextMessageContent.h"

@interface ConversationTableViewController ()<ConnectionStatusDelegate, ReceiveMessageDelegate>
@property (nonatomic, strong)NSMutableArray<ConversationInfo *> *conversations;
@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversations = [[NSMutableArray alloc] init];
  [NetworkService sharedInstance].connectionStatusDelegate = self;
  [NetworkService sharedInstance].receiveMessageDelegate = self;
  [self onConnectionStatusChanged:[NetworkService sharedInstance].currentConnectionStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReceiveMessage:(NSArray<Message *> *)messages hasMore:(BOOL)hasMore {

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.conversations = [[[NetworkService sharedInstance] getConversations:@[@(0), @(1), @(2)]] mutableCopy];
  [self.tableView reloadData];
}

- (void)onConnectionStatusChanged:(ConnectionStatus)status {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIView *title;
    if (status == kConnectionStatusLogout) {
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      LoginViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
      [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    } else if (status != kConnectionStatusConnectiong) {
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
  });
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
    
  ConversationInfo *info = self.conversations[indexPath.row];
  cell.targetView.text = info.conversation.target;
  cell.digestView.text = info.lastMessage.content.digest;
  cell.timeView.text = [NSString stringWithFormat:@"%lld", info.timestamp];
  
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
