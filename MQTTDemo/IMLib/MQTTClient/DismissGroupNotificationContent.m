//
//  DismissGroupNotificationContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "DismissGroupNotificationContent.h"
#import "IMService.h"
#import "NetworkService.h"

@implementation DismissGroupNotificationContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.operateUser) {
        [dataDict setObject:self.operateUser forKey:@"m"];
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
        self.operateUser = dictionary[@"m"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_DISMISS_GROUP;
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
    if ([[NetworkService sharedInstance].userId isEqualToString:self.operateUser]) {
        formatMsg = @"你解散了群聊";
    } else {
        formatMsg = [NSString stringWithFormat:@"%@解散了群聊", self.operateUser];
    }
    
    return formatMsg;
}
@end
