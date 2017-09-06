//
//  ImageMessageContent.h
//  MQTTDemo
//
//  Created by Tom Lee on 2017/9/2.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "MediaMessageContent.h"
#import <UIKit/UIKit.h>

@interface ImageMessageContent : MediaMessageContent
+ (instancetype)contentFrom:(UIImage *)image;
@property (nonatomic, strong)UIImage *thumbnail;
@end
