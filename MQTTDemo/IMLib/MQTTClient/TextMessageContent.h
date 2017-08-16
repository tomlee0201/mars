//
//  TextMessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageContent.h"

@interface TextMessageContent : MessageContent
+ (instancetype)contentWith:(NSString *)text;
@property (nonatomic, strong)NSString *text;
@end
