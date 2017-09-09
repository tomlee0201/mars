//
//  SoundMessageContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "SoundMessageContent.h"
#import "IMUtilities.h"
#import "wav_amr.h"
#import "IMService.h"


@implementation SoundMessageContent
+ (instancetype)soundMessageContentForWav:(NSString *)wavPath duration:(long)duration {
    SoundMessageContent *soundMsg = [[SoundMessageContent alloc] init];
    soundMsg.duration = duration;
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *amrPath = [[IMUtilities getDocumentPathWithComponent:@"/Vioce"] stringByAppendingPathComponent:[NSString stringWithFormat:@"img%lld.amr", recordTime]];
    
    encode_amr([wavPath UTF8String], [amrPath UTF8String]);
    
    soundMsg.localPath = amrPath;
    
    return soundMsg;
}

- (void)updateAmrData:(NSData *)voiceData {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *amrPath = [[IMUtilities getDocumentPathWithComponent:@"/Vioce"] stringByAppendingPathComponent:[NSString stringWithFormat:@"img%lld.amr", recordTime]];
    [voiceData writeToFile:amrPath atomically:YES];
    
    self.localPath = amrPath;
}
- (NSData *)getWavData {
    NSMutableData *data = [[NSMutableData alloc] init];
    decode_amr([self.localPath UTF8String], data);
    
//    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
//    NSString *amrPath = [[IMUtilities getDocumentPathWithComponent:@"/Vioce"] stringByAppendingPathComponent:[NSString stringWithFormat:@"img%lld.wav", recordTime]];
//    
//    [data writeToFile:amrPath atomically:YES];
    return data;
}

- (MessagePayload *)encode {
    MediaMessagePayload *payload = [[MediaMessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = @"[声音]";
    payload.mediaType = Media_Type_VOICE;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(_duration) forKey:@"duration"];
    payload.content = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    
    payload.remoteMediaUrl = self.remoteUrl;
    payload.localMediaPath = self.localPath;
    return payload;
}

- (void)decode:(MessagePayload *)payload {
    if ([payload isKindOfClass:[MediaMessagePayload class]]) {
        MediaMessagePayload *mediaPayload = (MediaMessagePayload *)payload;
        self.remoteUrl = mediaPayload.remoteMediaUrl;
        self.localPath = mediaPayload.localMediaPath;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[payload.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:kNilOptions
                                                                     error:nil];
        self.duration = [dictionary[@"duration"] longValue];
    }
}


+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_SOUND;
}

+ (int)getContentFlags {
    return 3;
}

+ (void)load {
    [[IMService sharedIMService] registerMessageContent:self];
}

- (NSString *)digest {
    return @"[声音]";
}
@end
