//
//  InformationCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "InformationCell.h"
#import "NotificationMessageContent.h"
#import "Utilities.h"


#define TEXT_LABEL_TOP_PADDING 2
#define TEXT_LABEL_BUTTOM_PADDING 6

#define TEXT_LABEL_LEFT_PADDING 30
#define TEXT_LABEL_RIGHT_PADDING 30

@implementation InformationCell

+ (CGSize)sizeForCell:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
    CGFloat height = [super hightForTimeLabel:msgModel];
    if ([msgModel.message.content isKindOfClass:[NotificationMessageContent class]]) {
        NotificationMessageContent *content = (NotificationMessageContent *)msgModel.message.content;
        CGSize size = [Utilities getTextDrawingSize:[content formatNotification] font:[UIFont systemFontOfSize:14] constrainedSize:CGSizeMake(width - TEXT_LABEL_LEFT_PADDING - TEXT_LABEL_RIGHT_PADDING, 8000)];
        size.height += TEXT_LABEL_TOP_PADDING + TEXT_LABEL_BUTTOM_PADDING;
        size.height += height;
        return CGSizeMake(width, size.height);
    }
    
    return CGSizeZero;
}

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    if ([model.message.content isKindOfClass:[NotificationMessageContent class]]) {
        NotificationMessageContent *content = (NotificationMessageContent *)model.message.content;
        CGFloat width = self.contentView.bounds.size.width;
        
        CGSize size = [Utilities getTextDrawingSize:[content formatNotification] font:[UIFont systemFontOfSize:14] constrainedSize:CGSizeMake(width - TEXT_LABEL_LEFT_PADDING - TEXT_LABEL_RIGHT_PADDING, 8000)];
        
        
        self.infoLabel.text = [content formatNotification];
        self.infoLabel.frame = CGRectMake((width - size.width)/2 - 4, self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + TEXT_LABEL_TOP_PADDING, size.width + 8, size.height);
    }
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:14];
        
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:14.f];
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.layer.cornerRadius = 3.f;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.backgroundColor = [UIColor colorWithRed:201/255.f green:201/255.f blue:201/255.f alpha:1.f];
        
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel; 
}
@end
