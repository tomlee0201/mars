//
//  TextCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "TextCell.h"
#import "TextMessageContent.h"
#import "Utilities.h"

@implementation TextCell
+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
  TextMessageContent *txtContent = (TextMessageContent *)msgModel.message.content;
  return [Utilities getTextDrawingSize:txtContent.text font:[UIFont systemFontOfSize:18] constrainedSize:CGSizeMake(width, 8000)];
}
- (void)setModel:(MessageModel *)model {
  [super setModel:model];
    
  TextMessageContent *txtContent = (TextMessageContent *)model.message.content;
  self.textLabel.frame = self.contentArea.bounds;
  self.textLabel.text = txtContent.text;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        [self.contentArea addSubview:_textLabel];
    }
    return _textLabel;
}
@end
