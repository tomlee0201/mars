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
#import "IMUtilities.h"

@implementation ImageMessageContent
+ (instancetype)contentFrom:(UIImage *)image {
    ImageMessageContent *content = [[ImageMessageContent alloc] init];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *path = [[IMUtilities getDocumentPathWithComponent:@"/IMG"] stringByAppendingPathComponent:[NSString stringWithFormat:@"img%lld.jpg", recordTime]];
    
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.92);
    
    [imgData writeToFile:path atomically:YES];
    
    content.localPath = path;
    content.thumbnail = [IMUtilities generateThumbnail:image withWidth:120 withHeight:120];
    
    return content;
}
- (MessagePayload *)encode {
    MediaMessagePayload *payload = [[MediaMessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = @"[图片]";
    payload.binaryContent = UIImageJPEGRepresentation(self.thumbnail, 0.67);
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
        _thumbnail = [IMUtilities generateThumbnail:image withWidth:120 withHeight:120];
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
