//
//  SoundMessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MediaMessageContent.h"

@interface SoundMessageContent : MediaMessageContent
+ (instancetype)soundMessageContentForWav:(NSString *)wavPath duration:(long)duration;
@property (nonatomic, assign)long duration;
- (void)updateAmrData:(NSData *)voiceData;
- (NSData *)getWavData;
@end
