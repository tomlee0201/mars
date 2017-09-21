//
//  KickoffGroupMemberNotificaionContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "KickoffGroupMemberNotificaionContent.h"
#import "IMService.h"
#import "NetworkService.h"

@implementation KickoffGroupMemberNotificaionContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.operateUser) {
        [dataDict setObject:self.operateUser forKey:@"o"];
    }
    if (self.kickedMembers) {
        [dataDict setObject:self.kickedMembers forKey:@"kms"];
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
        self.operateUser = dictionary[@"o"];
        self.kickedMembers = dictionary[@"kms"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_KICKOF_GROUP_MEMBER;
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
        formatMsg = @"你把";
    } else {
        formatMsg = [NSString stringWithFormat:@"%@把", self.operateUser];
    }
    
    for (NSString *member in self.kickedMembers) {
        if ([member isEqualToString:[NetworkService sharedInstance].userId]) {
            formatMsg = [formatMsg stringByAppendingString:@" 你"];
        } else {
            formatMsg = [formatMsg stringByAppendingFormat:@" %@", member];
        }
    }
    formatMsg = [formatMsg stringByAppendingString:@"移出群聊"];
    return formatMsg;
}
@end
