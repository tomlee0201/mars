//
//  VoiceCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "VoiceCell.h"
#import "SoundMessageContent.h"

@implementation VoiceCell
+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
    SoundMessageContent *soundContent = (SoundMessageContent *)msgModel.message.content;
    long duration = soundContent.duration;
    return CGSizeMake(MAX(40, width * 0.62 * (MIN(duration, 60)/60)), 40);
}

- (void)setModel:(MessageModel *)model {
    [super setModel:model];
    
    self.voiceBtn.frame = self.contentArea.bounds;
    if (model.message.direction == MessageDirection_Send) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"sent_voice"] forState:UIControlStateNormal];
    } else {
        [self.voiceBtn setImage:[UIImage imageNamed:@"received_voice"] forState:UIControlStateNormal];
    }
    
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchDown];
        [self.contentArea addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (void)startPlay:(id)sender {
    
}
@end
