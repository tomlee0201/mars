//
//  SubscribeTask.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "SubscribeTask.h"
#import <mars/stn/stn.h>
#import <mars/stn/stn_logic.h>
#import "NetworkService.h"

class SubscribeCallback : public mars::stn::MQTTGeneralCallback {
private:
    void(^m_successBlock)();
    void(^m_errorBlock)(int error_code);
public:
    SubscribeCallback(void(^successBlock)(), void(^errorBlock)(int error_code)) : mars::stn::MQTTGeneralCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    virtual void onSuccess() {
        if (m_successBlock) {
            m_successBlock();
        }
        delete this;
    }
    virtual void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    ~SubscribeCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};

@implementation SubscribeTask
- (instancetype)initWithTopic:(NSString *)topic {
    self = [super init];
    if (self) {
        _topic = topic;
    }
    return self;
}
- (void)send:(void(^)())successBlock error:(void(^)(int error_code))errorBlock {
    mars::stn::MQTTSubscribeTask *subscribeTask = new mars::stn::MQTTSubscribeTask(new SubscribeCallback(successBlock, errorBlock));
    subscribeTask->topic = [self.topic cStringUsingEncoding:NSUTF8StringEncoding];
    mars::stn::StartTask(*subscribeTask);
}
- (void)dealloc {
    NSLog(@"dealloced");
}
@end
