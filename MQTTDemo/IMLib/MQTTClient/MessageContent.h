//
//  MessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/15.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MESSAGE_CONTENT_TYPE_TEXT 1 
#define MESSAGE_CONTENT_TYPE_VOICE 2
#define MESSAGE_CONTENT_TYPE_IMAGE 3

@interface MessagePayload : NSObject
@property (nonatomic, assign)int contentType;
@property (nonatomic, strong)NSString *searchableContent;
@property (nonatomic, strong)NSString *pushContent;
@property (nonatomic, strong)NSData *data;
@property (nonatomic, strong)NSData *mediaData;
@end

@protocol MessageContent <NSObject>
- (MessagePayload *)encode;
- (void)decode:(MessagePayload *)payload;
+ (int)getContentType;
+ (int)getContentFlags;
- (NSString *)digest;
@end


@interface MessageContent : NSObject <MessageContent>

@end
