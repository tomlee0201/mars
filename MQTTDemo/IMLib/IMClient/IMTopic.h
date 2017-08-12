//
//  IMTopic.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/7/27.
//  Copyright © 2017年 litao. All rights reserved.
//

#ifndef IMTopic_h
#define IMTopic_h
#import <Foundation/Foundation.h>

extern NSString *sendMessageTopic;
extern NSString *pullMessageTopic;
extern NSString *notifyMessageTopic;

extern NSString *createGroupTopic;
extern NSString *addGroupMemberTopic;
extern NSString *kickoffGroupMemberTopic;
extern NSString *quitGroupTopic;
extern NSString *dismissGroupTopic;
extern NSString *modifyGroupInfoTopic;
extern NSString *getGroupInfoTopic;
extern NSString *getGroupMemberTopic;
#endif /* IMTopic_h */
