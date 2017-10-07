//
//  ContactListViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ContactListViewController.h"

@interface ContactListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
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
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@""];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"新朋友";
        } else {
            cell.textLabel.text = @"群组";
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@""];
        cell.textLabel.text = @"好友1";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIViewController *addFriendVC = [sb instantiateViewControllerWithIdentifier:@"searchToAddFriendVC"];
            [self.navigationController presentViewController:addFriendVC animated:YES completion:nil];
        } else {
            UIViewController *groupVC = [sb instantiateViewControllerWithIdentifier:@"groupTableView"];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
    }
}
@end
