//
//  CreateGroupNotificationContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/19.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "CreateGroupNotificationContent.h"
#import "IMService.h"
#import "NetworkService.h"


@implementation CreateGroupNotificationContent
- (MessagePayload *)encode {
    MessagePayload *payload = [[MessagePayload alloc] init];
    payload.contentType = [self.class getContentType];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.creator) {
        [dataDict setObject:self.creator forKey:@"c"];
    }
    if (self.groupName) {
        [dataDict setObject:self.groupName forKey:@"n"];
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
        self.creator = dictionary[@"c"];
        self.groupName = dictionary[@"n"];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_CREATE_GROUP;
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
    if ([[NetworkService sharedInstance].userId isEqualToString:self.creator]) {
        return [NSString stringWithFormat:@"你创建了群\"%@\"", self.groupName];
    } else {
        return [NSString stringWithFormat:@"%@创建了群\"%@\"", self.creator, self.groupName];
    }
}
@end
