//
//  MessageModel.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageModel : NSObject
+ (instancetype)modelOf:(Message *)message showName:(BOOL)showName showTime:(BOOL)showTime;
@property (nonatomic, assign)BOOL showTimeLabel;
@property (nonatomic, assign)BOOL showNameLabel;
@property (nonatomic, strong)Message *message;
@property (nonatomic, assign)BOOL mediaDownloading;
@property (nonatomic, assign)int mediaDownloadProgress;
@property (nonatomic, assign)BOOL voicePlaying;
@end
