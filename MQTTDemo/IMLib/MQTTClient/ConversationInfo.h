//
//  ConversationInfo.h
//  MQTTDemo
//
//  Created by Tom Lee on 2017/8/29.
//  Copyright © 2017年 TomLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
#import "Message.h"

@interface ConversationInfo : NSObject
@property (nonatomic, strong)Conversation *conversation;
@property (nonatomic, strong)Message *lastMessage;
@property (nonatomic, strong)NSString *draft;
@property (nonatomic, assign)long long timestamp;
@property (nonatomic, assign)int unreadCount;
@property (nonatomic, assign)BOOL isTop;
@end


