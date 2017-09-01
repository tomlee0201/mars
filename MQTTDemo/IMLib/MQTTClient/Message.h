//
//  Message.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
#import "MessageContent.h"

//Conversation conversation = 1;
//string from_user = 2;
//MessageContent content = 3;
//int64 message_id = 4;
//int64 server_timestamp = 5;

typedef enum : NSUInteger {
  MessageDirection_Send,
  MessageDirection_Receive
} MessageDirection;

@interface Message : NSObject
@property (nonatomic, assign)long messageId;
@property (nonatomic, strong)Conversation *conversation;
@property (nonatomic, strong)NSString * fromUser;
@property (nonatomic, strong)MessageContent *content;
@property (nonatomic, assign)MessageDirection direction;
@property (nonatomic, assign)long long messageUid;
@property (nonatomic, assign)long long serverTime;
@end
