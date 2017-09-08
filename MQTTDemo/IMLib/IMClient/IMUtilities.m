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
        NSUInteger location = [localPath rangeOfString:@"Containers/Data/Application/"].location;
        if (location != NSNotFound) {
            location =
                MIN(MIN([localPath rangeOfString:@"Documents" options:NSCaseInsensitiveSearch range:NSMakeRange(location, localPath.length - location)].location,
                    [localPath rangeOfString:@"Library" options:NSCaseInsensitiveSearch range:NSMakeRange(location, localPath.length - location)].location),
                [localPath rangeOfString:@"tmp" options:NSCaseInsensitiveSearch range:NSMakeRange(location, localPath.length - location)].location);
        }
        
        if (location != NSNotFound) {
            NSString *relativePath = [localPath substringFromIndex:location];
            return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
        } else {
            return localPath;
        }
    }
}
@end
