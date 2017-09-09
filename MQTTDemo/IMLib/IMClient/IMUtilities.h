//
//  IMUtilities.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMUtilities : NSObject
+ (UIImage *)generateThumbnail:(UIImage *)image
                     withWidth:(CGFloat)targetWidth
                    withHeight:(CGFloat)targetHeight;
+ (NSString *)getSendBoxFilePath:(NSString *)localPath;
+ (NSString *)getDocumentPathWithComponent:(NSString *)componentPath;
@end
