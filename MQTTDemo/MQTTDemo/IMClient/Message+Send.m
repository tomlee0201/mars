//
//  Message+Send.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/27.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "Message+Send.h"
#import "PublishTask.h"
#import "IMTopic.h"

@implementation Message (Send)
- (void)send:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock {
  NSData *data = [self data];
  PublishTask *publishTask = [[PublishTask alloc] initWithTopic:sendMessageTopic message:data];
  
  __weak typeof(self) weakSelf = self;
  
  [publishTask send:^(NSData *data){
    long long messageId = 0;
    long long timestamp = 0;
    if (data.length == 16) {
      const unsigned char* p = data.bytes;
      for (int i = 0; i < 8; i++) {
        messageId = (messageId << 8) + *(p + i);
        timestamp = (timestamp << 8) + *(p + 8 + i);
      }
    }
    weakSelf.messageId = messageId;
    weakSelf.serverTimestamp = timestamp;
    successBlock(messageId, timestamp);
  } error:^(int error_code) {
    errorBlock(error_code);
  }];

}
@end
