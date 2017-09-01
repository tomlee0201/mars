//
//  TextMessageContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "TextMessageContent.h"
#import "NetworkService.h"

@implementation TextMessageContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = self.text;
    return payload;
}

- (void)decode:(MessagePayload *)payload {
    self.text = payload.searchableContent;
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_TEXT;
}

+ (int)getContentFlags {
    return 3;
}

+ (instancetype)contentWith:(NSString *)text {
    TextMessageContent *content = [[TextMessageContent alloc] init];
    content.text = text;
    return content;
}

+ (void)load {
    [[NetworkService sharedInstance] registerMessageContent:self];
}

- (NSString *)digest {
  return self.text;
}
@end
