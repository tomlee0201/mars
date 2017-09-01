//
//  MessageModel.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (instancetype)modelOf:(Message *)message showName:(BOOL)showName showTime:(BOOL)showTime {
  MessageModel *model = [[MessageModel alloc] init];
  model.message = message;
  model.showNameLabel = showName;
  model.showTimeLabel = showTime;
  return model;
}
@end
