//
//  NotificationMessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/19.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageContent.h"


@protocol NotificationMessageContent <MessageContent>
- (NSString *)formatNotification;
@end


@interface NotificationMessageContent : MessageContent <NotificationMessageContent>

@end
