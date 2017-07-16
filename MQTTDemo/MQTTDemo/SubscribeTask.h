//
//  SubscribeTask.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeTask : NSObject
@property(nonatomic, strong)NSString *topic;
- (instancetype)initWithTopic:(NSString *)topic;
- (void)send:(void(^)())successBlock error:(void(^)(int error_code))errorBlock;
@end
