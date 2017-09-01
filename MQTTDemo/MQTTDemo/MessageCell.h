//
//  MessageCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellBase.h"

@interface MessageCell : MessageCellBase
+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width;
@property (nonatomic, strong)UIImageView *portraitView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIView *contentArea;
@end
