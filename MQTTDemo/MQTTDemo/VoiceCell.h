//
//  VoiceCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MediaMessageCell.h"

#define kVoiceMessageStartPlaying @"kVoiceMessageStartPlaying"
#define kVoiceMessagePlayStoped @"kVoiceMessagePlayStoped"


@interface VoiceCell : MediaMessageCell
@property (nonatomic, strong)UIImageView *voiceBtn;
@end
