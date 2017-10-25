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
    if (self.selectContact && self.multiSelect) {
        self.selectedContacts = [[NSMutableArray alloc] init];
    }
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
#define REUSEIDENTIFY @"resueCell"
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSEIDENTIFY];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSEIDENTIFY];
    }
    if (self.selectContact) {
        NSString *friendUid = self.dataArray[indexPath.row];
        UserInfo *friendInfo = [[IMService sharedIMService] getUserInfo:friendUid refresh:NO];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friendInfo.portrait]];
        cell.textLabel.text = friendInfo.displayName;
    } else {
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@""];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"新朋友";
            } else {
                cell.textLabel.text = @"群组";
            }
        } else {
            NSString *friendUid = self.dataArray[indexPath.row];
            UserInfo *friendInfo = [[IMService sharedIMService] getUserInfo:friendUid refresh:NO];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friendInfo.portrait]];
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
            //record here
            
        } else {
            [self.delegate didSelectContact:[NSArray arrayWithObjects:self.dataArray[indexPath.row], nil]];
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
