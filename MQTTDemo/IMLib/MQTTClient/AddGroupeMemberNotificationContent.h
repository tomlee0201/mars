//
//  AddGroupeMemberNotificationContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "NotificationMessageContent.h"

@interface AddGroupeMemberNotificationContent : NotificationMessageContent
@property (nonatomic, strong)NSString *invitor;
@property (nonatomic, strong)NSArray<NSString *> *invitees;
@end
