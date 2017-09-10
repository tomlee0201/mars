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

#define TEXT_LABEL_TOP_PADDING 2
#define TEXT_LABEL_BUTTOM_PADDING 6

@implementation TextCell
+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
  TextMessageContent *txtContent = (TextMessageContent *)msgModel.message.content;
    CGSize size = [Utilities getTextDrawingSize:txtContent.text font:[UIFont systemFontOfSize:18] constrainedSize:CGSizeMake(width, 8000)];
    size.height += TEXT_LABEL_TOP_PADDING + TEXT_LABEL_BUTTOM_PADDING;
  return size;
}

- (void)setModel:(MessageModel *)model {
  [super setModel:model];
    
  TextMessageContent *txtContent = (TextMessageContent *)model.message.content;
    CGRect frame = self.contentArea.bounds;
    frame.origin.y -= TEXT_LABEL_TOP_PADDING;
    frame.size.height -= TEXT_LABEL_TOP_PADDING;
    frame.size.height -= TEXT_LABEL_BUTTOM_PADDING;
  self.textLabel.frame = self.contentArea.bounds;
  self.textLabel.text = txtContent.text;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:18];
        [self.contentArea addSubview:_textLabel];
    }
    return _textLabel;
}
@end
