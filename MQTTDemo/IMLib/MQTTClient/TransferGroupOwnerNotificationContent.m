//
//  TransferGroupOwnerNotificationContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "TransferGroupOwnerNotificationContent.h"
#import "IMService.h"
#import "NetworkService.h"


@implementation TransferGroupOwnerNotificationContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.operateUser) {
        [dataDict setObject:self.operateUser forKey:@"m"];
    }
    if (self.owner) {
        [dataDict setObject:self.owner forKey:@"o"];
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
        self.owner = dictionary[@"o"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_TRANSFER_GROUP_OWNER;
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
        formatMsg = [NSString stringWithFormat:@"你把群主转让给了%@", self.owner];
    } else {
        formatMsg = [NSString stringWithFormat:@"%@把群主转让给了", self.operateUser];
        if ([[NetworkService sharedInstance].userId isEqualToString:self.owner]) {
            formatMsg = [formatMsg stringByAppendingString:@"你"];
        } else {
            formatMsg = [formatMsg stringByAppendingString:self.owner];
        }
    }
    
    return formatMsg;
}
@end
