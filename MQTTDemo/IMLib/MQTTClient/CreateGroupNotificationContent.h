//
//  CreateGroupNotificationContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/19.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "NotificationMessageContent.h"

@interface CreateGroupNotificationContent : NotificationMessageContent
@property (nonatomic, strong)NSString *creator;
@property (nonatomic, strong)NSString *groupName;
@end
