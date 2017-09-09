//
//  MediaMessageCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MediaMessageCell.h"

@interface MediaMessageCell ()
@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, strong)UIActivityIndicatorView *activityView;
@end

@implementation MediaMessageCell

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartDownloading:) name:kMediaMessageStartDownloading object:@(model.message.messageId)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadFinished:) name:kMediaMessageDownloadFinished object:@(model.message.messageId)];
    
    if (model.mediaDownloading) {
        [self onStartDownloading:self];
    } else {
        [self onDownloadFinished:self];
    }
}

- (void)onStartDownloading:(id)sender {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        [self.bubbleView addSubview:_maskView];
        [_maskView setBackgroundColor:[UIColor grayColor]];
        [_maskView setAlpha:0.5];
        [_maskView setClipsToBounds:YES];
    }
    _maskView.frame = self.bubbleView.bounds;
    [self.bubbleView bringSubviewToFront:_maskView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        [_maskView addSubview:_activityView];
    }
    _activityView.center = CGPointMake(self.maskView.bounds.size.width/2, self.maskView.bounds.size.height/2);
    [_activityView startAnimating];
    
}

- (void)onDownloadFinished:(id)sender {
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }

    if (_activityView) {
        [_activityView removeFromSuperview];
        [_activityView stopAnimating];
        _activityView = nil;
    }
}
@end
