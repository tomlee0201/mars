//
//  ContactSelectTableViewCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/25.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactSelectTableViewCell : UITableViewCell
@property(nonatomic, strong)NSString *friendUid;
@property(nonatomic, assign)BOOL multiSelect;
@property(nonatomic, assign)BOOL checked;
@end
