//
//  ImageMessageContent.h
//  MQTTDemo
//
//  Created by Tom Lee on 2017/9/2.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "MessageContent.h"
#import <UIKit/UIKit.h>

@interface ImageMessageContent : MessageContent
+ (instancetype)contentFrom:(UIImage *)image;
@property (nonatomic, strong)NSString *localPath;
@property (nonatomic, strong)NSString *remotePath;
@property (nonatomic, strong)UIImage *thumbnail;
@end
