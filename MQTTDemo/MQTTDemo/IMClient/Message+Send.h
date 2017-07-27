//
//  Message+Send.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/27.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "Message.pbobjc.h"

@interface Message (Send)
- (void)send:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock;
@end
