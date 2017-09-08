//
//  MessageCellBase.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@class MessageCellBase;

@protocol MessageCellDelegate <NSObject>
- (void)didTapMessageCell:(MessageCellBase *)cell withModel:(MessageModel *)model;
@end

@interface MessageCellBase : UICollectionViewCell
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)MessageModel *model;
@property (nonatomic, weak)id<MessageCellDelegate> delegate;
+ (CGSize)sizeForCell:(MessageModel *)msgModel withViewWidth:(CGFloat)width;
+ (CGFloat)hightForTimeLabel:(MessageModel *)msgModel;
@end
