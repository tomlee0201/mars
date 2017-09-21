//
//  AddGroupeMemberNotificationContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "AddGroupeMemberNotificationContent.h"
#import "IMService.h"
#import "NetworkService.h"

@implementation AddGroupeMemberNotificationContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.invitor) {
        [dataDict setObject:self.invitor forKey:@"i"];
    }
    if (self.invitees) {
        [dataDict setObject:self.invitees forKey:@"ies"];
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
        self.invitor = dictionary[@"i"];
        self.invitees = dictionary[@"ies"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_ADD_GROUP_MEMBER;
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
    if ([[NetworkService sharedInstance].userId isEqualToString:self.invitor]) {
        formatMsg = @"你邀请";
    } else {
        formatMsg = [NSString stringWithFormat:@"%@邀请", self.invitor];
    }
    
    for (NSString *member in self.invitees) {
        if ([member isEqualToString:[NetworkService sharedInstance].userId]) {
            formatMsg = [formatMsg stringByAppendingString:@" 你"];
        } else {
            formatMsg = [formatMsg stringByAppendingFormat:@" %@", member];
        }
    }
    formatMsg = [formatMsg stringByAppendingString:@"加入了群聊"];
    return formatMsg;
}
@end
