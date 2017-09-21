//
//  GroupMemberTableViewController.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/18.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberTableViewController : UITableViewController
@property (nonatomic, strong)NSString *groupId;
@property (nonatomic, assign)BOOL selectable;
@property (nonatomic, assign)BOOL multiSelect;
@property (nonatomic, copy)void (^selectResult)(NSString *groupId, NSArray<NSString *> *memberIds);
@end
