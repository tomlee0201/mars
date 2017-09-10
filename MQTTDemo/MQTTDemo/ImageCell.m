//
//  ImageCell.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/9/2.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "ImageCell.h"
#import "ImageMessageContent.h"

@interface ImageCell ()
@property(nonatomic, strong) UIImageView *shadowMaskView;
@end

@implementation ImageCell

+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
    ImageMessageContent *imgContent = (ImageMessageContent *)msgModel.message.content;
    
    return imgContent.thumbnail.size;
}

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    
    ImageMessageContent *imgContent = (ImageMessageContent *)model.message.content;
    self.thumbnailView.frame = self.bubbleView.bounds;
    self.thumbnailView.image = imgContent.thumbnail;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] init];
        [self.bubbleView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

- (void)setMaskImage:(UIImage *)maskImage{
    [super setMaskImage:maskImage];
    if (_shadowMaskView) {
        [_shadowMaskView removeFromSuperview];
    }
    _shadowMaskView = [[UIImageView alloc] initWithImage:maskImage];
    
    CGRect frame = CGRectMake(self.bubbleView.frame.origin.x - 1, self.bubbleView.frame.origin.y - 1, self.bubbleView.frame.size.width + 2, self.bubbleView.frame.size.height + 2);
    _shadowMaskView.frame = frame;
    [self.contentView addSubview:_shadowMaskView];
    [self.contentView bringSubviewToFront:self.bubbleView];
    
}

@end
