//
//  QuitGroupNotificationContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "QuitGroupNotificationContent.h"
#import "IMService.h"
#import "NetworkService.h"

@implementation QuitGroupNotificationContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.quitMember) {
        [dataDict setObject:self.quitMember forKey:@"m"];
    }
    
    
    payload.binaryContent = [NSJSONSerialization dataWithJSONObject:dataDict
                                                            options:kNilOptions
                                                              error:nil];
    
    return payload;
}

- (void)decode:(MessagePayload *)payload {
    NSError *__error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:payload.binaryContent
                                                               options:kNilOptions
                                                                 error:&__error];
    if (!__error) {
        self.quitMember = dictionary[@"m"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_QUIT_GROUP;
}

+ (int)getContentFlags {
    return 1;
}


+ (void)load {
    [[IMService sharedIMService] registerMessageContent:self];
}

- (NSString *)digest {
    return [self formatNotification];
}

- (NSString *)formatNotification {
    NSString *formatMsg;
    if ([[NetworkService sharedInstance].userId isEqualToString:self.quitMember]) {
        formatMsg = @"你退出了群聊";
    } else {
        formatMsg = [NSString stringWithFormat:@"%@退出了群聊", self.quitMember];
    }
    
    return formatMsg;
}
@end
