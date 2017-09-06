//
//  MediaMessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/6.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageContent.h"

@interface MediaMessageContent : MessageContent
@property (nonatomic, strong)NSString *localPath;
@property (nonatomic, strong)NSString *remoteUrl;
@end
