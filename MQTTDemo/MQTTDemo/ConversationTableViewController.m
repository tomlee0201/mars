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
#import "ContactListViewController.h"

#import "MessageViewController.h"
#import "NetworkService.h"
#import "Message.h"
#import "Conversation.h"
#import "IMService.h"
#import "TextMessageContent.h"

#import "Utilities.h"
#import "UITabBar+badge.h"
#import "ConversationSearchInfo.h"
#import "KxMenu.h"

@interface ConversationTableViewController () <UISearchControllerDelegate, UISearchResultsUpdating, ContactSelectDelegate>
@property (nonatomic, strong)NSMutableArray<ConversationInfo *> *conversations;

@property (nonatomic, strong)  UISearchController       *searchController;
@property (nonatomic, strong) NSArray            *searchList;
@end

@implementation ConversationTableViewController
- (void)initSearchUIAndData {
    //self.view.backgroundColor = [UIColor whiteColor];
    
    _searchList = [NSMutableArray array];
    
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;//取消分割线
    
    //创建UISearchController
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    //    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    //    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(onRightBarBtn:)];
}

- (void)onRightBarBtn:(UIBarButtonItem *)sender {    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.bounds.size.width - 48, 64, 48, 5)
                 menuItems:@[
                             [KxMenuItem menuItem:@"创建聊天"
                                            image:nil
                                           target:self
                                           action:@selector(menuItemAction:)],
                             ]];
}

- (void)menuItemAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactListViewController *pvc = [sb instantiateViewControllerWithIdentifier:@"contactVC"];
    pvc.selectContact = YES;
    pvc.multiSelect = YES;
    pvc.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversations = [[NSMutableArray alloc] init];
  [self updateConnectionStatus:[NetworkService sharedInstance].currentConnectionStatus];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectionStatusChanged:) name:@"kConnectionStatusChanged" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMessages:) name:@"kReceiveMessages" object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClearAllUnread:) name:@"kTabBarClearBadgeNotification" object:nil];
    
    [self initSearchUIAndData];
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
    if (self.searchController.active) {
        return self.searchList.count;
    } else {
        return self.conversations.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseableConversationCell" forIndexPath:indexPath];
    
    if (self.searchController.active) {
        cell.searchInfo = self.searchList[indexPath.row];
    } else {
        cell.info = self.conversations[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 56;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (self.searchController.active) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) ws = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[IMService sharedIMService] removeConversation:ws.conversations[indexPath.row].conversation clearMessage:YES];
        [ws.conversations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UITableViewRowAction *setTop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[IMService sharedIMService] setConversation:ws.conversations[indexPath.row].conversation top:YES];
        [self refreshList];
    }];
    
    UITableViewRowAction *setUntop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[IMService sharedIMService] setConversation:ws.conversations[indexPath.row].conversation top:NO];
        [self refreshList];
    }];
    
   
    
    setTop.backgroundColor = [UIColor purpleColor];
    setUntop.backgroundColor = [UIColor orangeColor];
    
    if (self.conversations[indexPath.row].isTop) {
        return @[delete, setUntop ];
    } else {
        return @[delete, setTop];
    }
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
  if ([segue.destinationViewController isKindOfClass:[MessageViewController class]]) {
    MessageViewController *mvc = (MessageViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
      if (self.searchController.active) {
          NSString *searchString = [self.searchController.searchBar text];
          ConversationSearchInfo *info = self.searchList[indexPath.row];
          mvc.conversation = info.conversation;
          mvc.keyword = searchString;
          self.searchController.active = NO;
      } else {
        ConversationInfo *info = self.conversations[indexPath.row];
        mvc.conversation = info.conversation;
      }
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchController = nil;
    _searchList       = nil;
}

#pragma mark - UISearchControllerDelegate
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"presentSearchController");
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    
    self.searchList = [[IMService sharedIMService] searchConversation:searchString];
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - ContactSelectDelegate
- (void)didSelectContact:(NSArray<NSString *> *)contacts {
    if (contacts.count == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *mvc = [sb instantiateViewControllerWithIdentifier:@"messageVC"];
        mvc.conversation = [Conversation conversationWithType:Single_Type target:contacts[0] line:0];
        [self.navigationController pushViewController:mvc animated:YES];
    } else {
        
    }
}
@end
