//
//  PublishTask.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishTask : NSObject
@property(nonatomic, strong)NSString *topic;
@property(nonatomic, strong)NSData *message;
- (instancetype)initWithTopic:(NSString *)topic message:(NSData *)message;
- (void)send:(void(^)())successBlock error:(void(^)(int error_code))errorBlock;
@end
