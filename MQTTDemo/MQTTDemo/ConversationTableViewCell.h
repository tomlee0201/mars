//
//  ConversationTableViewCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *potraitView;
@property (weak, nonatomic) IBOutlet UILabel *targetView;
@property (weak, nonatomic) IBOutlet UILabel *digestView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;

@end
