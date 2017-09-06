//
//  MessageContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/15.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageContent.h"


@implementation MessagePayload
@end

@implementation MediaMessagePayload
@end

@implementation MessageContent
+ (void)load {
    
}
- (MessagePayload *)encode {
    return nil;
}
- (void)decode:(MessagePayload *)payload {
    
}
+ (int)getContentType {
    return 0;
}
+ (int)getContentFlags {
    return 0;
}
- (NSString *)digest {
  return @"Unimplement digest function";
}
@end
