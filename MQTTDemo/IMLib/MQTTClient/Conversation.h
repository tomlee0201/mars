//
//  Conversation.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Single_Type,
    Group_Type,
    Chatroom_Type,
} ConversationType;

@interface Conversation : NSObject
+(instancetype)conversationWithType:(ConversationType)type target:(NSString *)target line:(int)line;
@property (nonatomic, assign)ConversationType type;
@property (nonatomic, strong)NSString *target;
@property (nonatomic, assign)int line;
@end
