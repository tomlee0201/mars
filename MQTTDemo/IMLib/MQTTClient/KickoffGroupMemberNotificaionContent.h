//
//  KickoffGroupMemberNotificaionContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/20.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "NotificationMessageContent.h"

@interface KickoffGroupMemberNotificaionContent : NotificationMessageContent
@property (nonatomic, strong)NSString *operateUser;
@property (nonatomic, strong)NSArray<NSString *> *kickedMembers;

@end
