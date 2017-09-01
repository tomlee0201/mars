//
//  MessageCellBase.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageCellBase.h"
#import "Utilities.h"

@implementation MessageCellBase
+ (CGSize)sizeForCell:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
  return CGSizeMake(width, 80);
}
+ (CGFloat)hightForTimeLabel:(MessageModel *)msgModel {
  if (msgModel.showTimeLabel) {
    return 25;
  }
  return 5;
}
- (void)setModel:(MessageModel *)model {
  _model = model;
  if (model.showTimeLabel) {
    if (self.timeLabel == nil) {
      self.timeLabel = [[UILabel alloc] init];
      _timeLabel.font = [UIFont systemFontOfSize:12.f];
      
      [self addSubview:self.timeLabel];
    }
    _timeLabel.hidden = NO;
    _timeLabel.text = @"20:30";

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [Utilities getTextDrawingSize:_timeLabel.text font:_timeLabel.font constrainedSize:CGSizeMake(screenWidth, 8000)];
    CGRect rect = CGRectMake((screenWidth - size.width)/2, 9, size.width, size.height);
    _timeLabel.frame = rect;
  } else {
    _timeLabel.hidden = YES;
  }
}


@end
