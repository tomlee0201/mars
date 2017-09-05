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
    
    content.image = image;
    content.localPath = path;
    content.thumbnail = [Utilities generateThumbnail:image withWidth:240 withHeight:240];
    
    return content;
}
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = [UIImageJPEGRepresentation(self.thumbnail, 0.92) base64EncodedStringWithOptions:0];
    payload.mediaData = UIImageJPEGRepresentation(self.image, 0.92);
    return payload;
}

- (void)decode:(MessagePayload *)payload {
    self.thumbnail = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:payload.searchableContent options:0]];
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_IMAGE;
}

+ (int)getContentFlags {
    return 3;
}



+ (void)load {
    [[NetworkService sharedInstance] registerMessageContent:self];
}

- (NSString *)digest {
    return @"[图片]";
}
@end
