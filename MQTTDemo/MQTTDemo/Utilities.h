//
//  Utilities.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utilities : NSObject
+ (CGSize)getTextDrawingSize:(NSString *)text
                        font:(UIFont *)font
             constrainedSize:(CGSize)constrainedSize;
+ (NSString *)formatTimeLabel:(int64_t)timestamp;
+ (NSString *)formatTimeDetailLabel:(int64_t)timestamp;
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage maxSize:(CGSize)size;
@end
