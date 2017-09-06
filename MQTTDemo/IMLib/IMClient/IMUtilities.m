//
//  IMUtilities.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "IMUtilities.h"

@implementation IMUtilities
+ (NSString *)getSendBoxFilePath:(NSString *)localPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        return localPath;
    } else {
        NSUInteger location =
        MIN(MIN([localPath rangeOfString:@"Documents"].location,
                [localPath rangeOfString:@"Library"].location),
            [localPath rangeOfString:@"tmp"].location);
        
        if (location != NSNotFound) {
            NSString *relativePath = [localPath substringFromIndex:location];
            return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
        } else {
            return localPath;
        }
    }
}
@end
