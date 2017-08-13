//
//  PublishTask.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "PublishTask.h"
#import <mars/stn/stn.h>
#import <mars/stn/stn_logic.h>
#import "NetworkService.h"

class PublishCallback : public mars::stn::MQTTPublishCallback {
private:
    void(^m_successBlock)(NSData *data);
    void(^m_errorBlock)(int error_code);
public:
    PublishCallback(void(^successBlock)(NSData *data), void(^errorBlock)(int error_code)) : mars::stn::MQTTPublishCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    virtual void onSuccess(const unsigned char* data, size_t len) {
        if (m_successBlock) {
            NSData *nsdata = [NSData dataWithBytes:data length:len];
            m_successBlock(nsdata);
        }
        delete this;
    }
    virtual void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    ~PublishCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};

@implementation PublishTask
- (instancetype)initWithTopic:(NSString *)topic message:(NSData *)message {
    self = [super init];
    if (self) {
        _topic = topic;
        _message = message;
    }
    return self;
}

- (void)send:(void(^)(NSData *data))successBlock error:(void(^)(int error_code))errorBlock {
    
    mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new PublishCallback(successBlock, errorBlock));
    publishTask->topic = [self.topic cStringUsingEncoding:NSUTF8StringEncoding];
    publishTask->length = self.message.length;
    publishTask->body = new unsigned char[publishTask->length];
    memcpy(publishTask->body, self.message.bytes, publishTask->length);
    mars::stn::StartTask(*publishTask);
}
@end
