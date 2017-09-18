//
//  GroupMemberTableViewCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/18.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberTableViewCell : UITableViewCell
@property (nonatomic, assign)BOOL isSelectable;
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, strong)UIImageView *portraitView;
@property (nonatomic, strong)UILabel *groupNameView;
@property (nonatomic, strong)UIImageView *selectView;
@end
