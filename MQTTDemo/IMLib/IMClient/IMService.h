//
//  IMService.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.pbobjc.h"
#import "Group.pbobjc.h"


@interface IMService : NSObject
+ (IMService*)sharedIMService;

- (void)send:(Message *)message success:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock;

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock;

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock;

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock;

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock;

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock;

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
          notifyContent:(MessageContent *)notifyContent
                success:(void(^)())successBlock
                  error:(void(^)(int error_code))errorBlock;

- (void)getGroupInfo:(NSArray<NSString *> *)groupIds
             success:(void(^)(NSArray<GroupInfo *> *))successBlock
               error:(void(^)(int error_code))errorBlock;

- (void)getGroupMembers:(NSString *)groupId
                success:(void(^)(NSArray<NSString *> *))successBlock
                  error:(void(^)(int error_code))errorBlock;
@end
