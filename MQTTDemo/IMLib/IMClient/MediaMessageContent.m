//
//  MediaMessageContent.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/6.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MediaMessageContent.h"
#import "IMUtilities.h"
@implementation MediaMessageContent
- (NSString *)localPath {
    _localPath = [IMUtilities getSendBoxFilePath:_localPath];
    return _localPath;
}
@end
