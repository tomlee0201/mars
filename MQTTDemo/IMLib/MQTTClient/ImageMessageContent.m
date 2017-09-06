//
//  ImageMessageContent.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/9/2.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "ImageMessageContent.h"
#import "NetworkService.h"
#import "Utilities.h"
#import "IMService.h"

@implementation ImageMessageContent
+ (instancetype)contentFrom:(UIImage *)image {
    ImageMessageContent *content = [[ImageMessageContent alloc] init];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"img%lld.jpg", recordTime]];
    
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.92);
    
    [imgData writeToFile:path atomically:YES];
    
    content.localPath = path;
    content.thumbnail = [Utilities generateThumbnail:image withWidth:240 withHeight:240];
    
    return content;
}
- (MessagePayload *)encode {
    MediaMessagePayload *payload = [[MediaMessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = @"[图片]";
    payload.binaryContent = UIImageJPEGRepresentation(self.thumbnail, 0.92);
    payload.mediaType = Media_Type_IMAGE;
    payload.remoteMediaUrl = self.remoteUrl;
    payload.localMediaPath = self.localPath;
    return payload;
}

- (void)decode:(MessagePayload *)payload {
    if ([payload isKindOfClass:[MediaMessagePayload class]]) {
        MediaMessagePayload *mediaPayload = (MediaMessagePayload *)payload;
        self.thumbnail = [UIImage imageWithData:payload.binaryContent];
        self.remoteUrl = mediaPayload.remoteMediaUrl;
        self.localPath = mediaPayload.localMediaPath;
    }
}

- (UIImage *)thumbnail {
    if (!_thumbnail) {
        UIImage *image = [UIImage imageWithContentsOfFile:self.localPath];
        _thumbnail = [Utilities generateThumbnail:image withWidth:240 withHeight:240];
    }
    return _thumbnail;
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_IMAGE;
}

+ (int)getContentFlags {
    return 3;
}



+ (void)load {
    [[IMService sharedIMService] registerMessageContent:self];
}

- (NSString *)digest {
    return @"[图片]";
}
@end
