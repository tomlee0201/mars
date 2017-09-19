//
//  MessageContent.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/15.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MESSAGE_CONTENT_TYPE_TEXT 1 
#define MESSAGE_CONTENT_TYPE_SOUND 2
#define MESSAGE_CONTENT_TYPE_IMAGE 3
#define MESSAGE_CONTENT_TYPE_CREATE_GROUP 4


typedef enum : NSUInteger {
    Media_Type_IMAGE = 1,
    Media_Type_VOICE = 2,
    Media_Type_File = 3
} MediaType;

@interface MessagePayload : NSObject
@property (nonatomic, assign)int contentType;
@property (nonatomic, strong)NSString *searchableContent;
@property (nonatomic, strong)NSString *pushContent;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSData *binaryContent;
//前面的属性都会在网络发送，下面的属性只在本地存储
@property (nonatomic, strong)NSString *localContent;
@end

@interface MediaMessagePayload : MessagePayload
@property (nonatomic, assign)MediaType mediaType;
@property (nonatomic, strong)NSString *remoteMediaUrl;
//前面的属性都会在网络发送，下面的属性只在本地存储
@property (nonatomic, strong)NSString *localMediaPath;
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
