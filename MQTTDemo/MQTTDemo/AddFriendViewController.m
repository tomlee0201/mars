//
//  AddFriendViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "AddFriendViewController.h"
#import "UserInfo.h"
#import "IMService.h"


@interface AddFriendViewController () <UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate>
@property (nonatomic, strong)  UITableView              *tableView;
@property (nonatomic, strong)  UISearchController       *searchController;

//数据源
@property (nonatomic, strong) NSMutableArray            *dataList;
@property (nonatomic, strong) NSMutableArray            *searchList;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchUIAndData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(onCancel:)];
}

- (void)onCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSearchUIAndData {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加好友";
    
    //初始化数据源
    _dataList   = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    //设置代理
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//取消分割线
    
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    //    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    //    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    //    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    [self.view addSubview:_tableView];
    
    
}

//生成三个随机字母
- (NSString *)shuffledAlphabet
{
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",
                                                                         @"H",@"I",@"J",@"K",@"L",@"M",@"N",
                                                                         @"O",@"P",@"Q",@"R",@"S",@"T",@"U",
                                                                         @"V",@"W",@"X",@"Y",@"Z"]];
    
    NSString *strTest = [[NSString alloc]init];
    
    for (int i = 0; i < 3; i++)
    {
        int x = arc4random() % 25;//0~24 的随机数
        strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
        
    }
    
    return strTest;
}

#pragma mark - UITableViewDataSource

//table 返回的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchList count];
    } else {
        return [self.dataList count];
    }
    
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *flag = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    
    if (self.searchController.active)//如果正在搜索
    {
        UserInfo *userInfo = self.searchList[indexPath.row];
        [cell.textLabel setText:userInfo.displayName];
        
    }
    else//如果没有搜索
    {
        [cell.textLabel setText:self.dataList[indexPath.row]];
        
    }
    return cell;
    
}

#pragma mark - UISearchControllerDelegate
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
    
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
    
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
    
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
    
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
    
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"updateSearchResultsForSearchController");
    __weak typeof(self) ws = self;
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    self.timer = [NSTimer timerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSString *searchString = [ws.searchController.searchBar text];
        if (searchString.length) {
            [[IMService sharedIMService] searchUser:searchString
                                            success:^(NSArray<UserInfo *> *machedUsers) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [ws.searchList removeAllObjects];
                                                    [ws.searchList addObjectsFromArray:machedUsers];
                                                    [ws.tableView reloadData];
                                                });
                                            }
                                              error:^(int errorCode) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [ws.searchList removeAllObjects];
                                                      [ws.tableView reloadData];
                                                  });
                                                  NSLog(@"Search failed, errorCode(%d)", errorCode);
                                              }];
            
        } else {
            [ws.searchList removeAllObjects];
            [ws.tableView reloadData];
        }
        
    }
                  ];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    _tableView        = nil;
    _searchController = nil;
    _dataList         = nil;
    _searchList       = nil;
}
@end
