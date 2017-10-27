//
//  ContactListViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ContactListViewController.h"
#import "IMService.h"
#import "SDWebImage.h"
#import "MessageViewController.h"
#import "ContactSelectTableViewCell.h"


@interface ContactListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *selectedContacts;
@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, frame.size.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    if (self.selectContact) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(onLeftBarBtn:)];
        
        if(self.multiSelect) {
            self.selectedContacts = [[NSMutableArray alloc] init];
            [self updateRightBarBtn];
        }
    }
    
}
- (void)updateRightBarBtn {
    if(self.selectedContacts.count == 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onRightBarBtn:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"确定(%d)", (int)self.selectedContacts.count] style:UIBarButtonItemStyleDone target:self action:@selector(onRightBarBtn:)];
    }
}
- (void)onRightBarBtn:(UIBarButtonItem *)sender {
    [self.delegate didSelectContact:self.selectedContacts];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onLeftBarBtn:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataArray = [[IMService sharedIMService] getMyFriendList:YES];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectContact) {
        return self.dataArray.count;
    } else {
        if (section == 0) {
            return 2;
        } else {
            return self.dataArray.count;
        }
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (self.selectContact) {
#define SELECT_REUSEIDENTIFY @"resueSelectCell"
        ContactSelectTableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:SELECT_REUSEIDENTIFY];
        if (selectCell == nil) {
            selectCell = [[ContactSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SELECT_REUSEIDENTIFY];
        }
        NSString *friendUid = self.dataArray[indexPath.row];
        selectCell.friendUid = friendUid;
        selectCell.multiSelect = self.multiSelect;
        
        if (self.multiSelect) {
            if ([self.selectedContacts containsObject:friendUid]) {
                selectCell.checked = YES;
            } else {
                selectCell.checked = NO;
            }
        }
        cell = selectCell;
    } else {
#define REUSEIDENTIFY @"resueCell"
        cell = [tableView dequeueReusableCellWithIdentifier:REUSEIDENTIFY];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSEIDENTIFY];
        }
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@""];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"新朋友";
              cell.imageView.image = [UIImage imageNamed:@"friend_request_icon"];
            } else {
                cell.textLabel.text = @"群组";
              cell.imageView.image = [UIImage imageNamed:@"contact_group_icon"];
            }
        } else {
            NSString *friendUid = self.dataArray[indexPath.row];
            UserInfo *friendInfo = [[IMService sharedIMService] getUserInfo:friendUid refresh:NO];

          CGRect frame = cell.imageView.frame;
          frame.size.width = 36;
          frame.size.height = 36;
          cell.imageView.frame = frame;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friendInfo.portrait] placeholderImage: [UIImage imageNamed:@"PersonalChat"]];
            cell.textLabel.text = friendInfo.displayName;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectContact) {
        return 1;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return @"  ";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self.selectContact) {
        if (self.multiSelect) {
            if ([self.selectedContacts containsObject:self.dataArray[indexPath.row]]) {
                [self.selectedContacts removeObject:self.dataArray[indexPath.row]];
                ((ContactSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).checked = NO;
            } else {
                [self.selectedContacts addObject:self.dataArray[indexPath.row]];
                ((ContactSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).checked = YES;
            }
            [self updateRightBarBtn];
        } else {
            [self.delegate didSelectContact:[NSArray arrayWithObjects:self.dataArray[indexPath.row], nil]];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UIViewController *addFriendVC = [sb instantiateViewControllerWithIdentifier:@"searchToAddFriendVC"];
                [self.navigationController presentViewController:addFriendVC animated:YES completion:nil];
            } else {
                UIViewController *groupVC = [sb instantiateViewControllerWithIdentifier:@"groupTableView"];
                [self.navigationController pushViewController:groupVC animated:YES];
            }
        } else if (indexPath.section == 1) {
            MessageViewController *mvc = [sb instantiateViewControllerWithIdentifier:@"messageVC"];
            NSString *friendUid = self.dataArray[indexPath.row];
            mvc.conversation = [Conversation conversationWithType:Single_Type target:friendUid line:0];
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
}
@end
