//
//  VoiceCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "VoiceCell.h"
#import "SoundMessageContent.h"

@interface VoiceCell ()
@property(nonatomic, strong) NSTimer *animationTimer;
@property(nonatomic) int animationIndex;
@end

@implementation VoiceCell
+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
    SoundMessageContent *soundContent = (SoundMessageContent *)msgModel.message.content;
    long duration = soundContent.duration;
    return CGSizeMake(MAX(40, width * 0.62 * (MIN(duration, 60)/60)), 40);
}

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    
    self.voiceBtn.frame = self.contentArea.bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimationTimer) name:kVoiceMessageStartPlaying object:@(model.message.messageId)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimationTimer) name:kVoiceMessagePlayStoped object:nil];
    if (model.voicePlaying) {
        [self startAnimationTimer];
    } else {
        [self stopAnimationTimer];
    }
}

- (UIImageView *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIImageView alloc] init];
        [self.contentArea addSubview:_voiceBtn];
    }
    return _voiceBtn;
}


- (void)startAnimationTimer {
    [self stopAnimationTimer];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                           target:self
                                                         selector:@selector(scheduleAnimation:)
                                                         userInfo:nil
                                                          repeats:YES];
    [self.animationTimer fire];
}


- (void)scheduleAnimation:(id)sender {
    NSString *_playingImg;
    
    if (MessageDirection_Send == self.model.message.direction) {
        _playingImg = [NSString stringWithFormat:@"sent_voice_%d", (self.animationIndex++ % 3) + 1];
    } else {
        _playingImg = [NSString stringWithFormat:@"received_voice_%d", (self.animationIndex++ % 3) + 1];
    }

    [self.voiceBtn setImage:[UIImage imageNamed:_playingImg]];
}

- (void)stopAnimationTimer {
    if (self.animationTimer && [self.animationTimer isValid]) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        self.animationIndex = 0;
    }
    
    if (self.model.message.direction == MessageDirection_Send) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"sent_voice"]];
    } else {
        [self.voiceBtn setImage:[UIImage imageNamed:@"received_voice"]];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
