//
//  Conversation.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation
+(instancetype)conversationWithType:(ConversationType)type target:(NSString *)target {
    Conversation *conversation = [[Conversation alloc] init];
    conversation.type = type;
    conversation.target = target;
    return conversation;
}
@end
