//
//  ConversationSearchInfo.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/22.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
#import "Message.h"

@interface ConversationSearchInfo : NSObject
@property (nonatomic, strong)Conversation *conversation;
@property (nonatomic, strong)Message *marchedMessage;
@property (nonatomic, assign)int marchedCount;
@end
