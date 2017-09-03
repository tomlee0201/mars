//
//  ImageCell.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/9/2.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "ImageCell.h"
#import "ImageMessageContent.h"


@implementation ImageCell

+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
    ImageMessageContent *imgContent = (ImageMessageContent *)msgModel.message.content;
    
    return imgContent.thumbnail.size;
}

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    
    ImageMessageContent *imgContent = (ImageMessageContent *)model.message.content;
    self.thumbnailView.frame = self.contentArea.bounds;
    self.thumbnailView.image = imgContent.thumbnail;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] init];
        [self.contentArea addSubview:_thumbnailView];
    
    }
    return _thumbnailView;
}
@end
