//
//  IMService.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "IMService.h"
#import "PublishTask.h"
#import "IMTopic.h"
#import "CreateGroupRequest.pbobjc.h"
#import "Group.pbobjc.h"
#import "MessageContent.pbobjc.h"
#import "AddGroupMemberRequest.pbobjc.h"
#import "QuitGroupRequest.pbobjc.h"
#import "DismissGroupRequest.pbobjc.h"
#import "ModifyGroupInfoRequest.pbobjc.h"
#import "RemoveGroupMemberRequest.pbobjc.h"
#import "IdListBuf.pbobjc.h"
#import "IdBuf.pbobjc.h"
#import "PullGroupInfoResult.pbobjc.h"
#import "PullGroupMemberResult.pbobjc.h"

static IMService * sharedSingleton = nil;
@implementation IMService
+ (IMService *)sharedIMService {
    if (sharedSingleton == nil) {
        @synchronized (self) {
            if (sharedSingleton == nil) {
                sharedSingleton = [[IMService alloc] init];
            }
        }
    }

    return sharedSingleton;
}

- (void)send:(Message *)message success:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock {
    NSData *data = [message data];
    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:sendMessageTopic message:data];
    
    [publishTask send:^(NSData *data){
        long long messageId = 0;
        long long timestamp = 0;
        if (data.length == 16) {
            const unsigned char* p = data.bytes;
            for (int i = 0; i < 8; i++) {
                messageId = (messageId << 8) + *(p + i);
                timestamp = (timestamp << 8) + *(p + 8 + i);
            }
        }
        message.messageId = messageId;
        message.serverTimestamp = timestamp;
        successBlock(messageId, timestamp);
    } error:^(int error_code) {
        errorBlock(error_code);
    }];
}

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock {
    
    CreateGroupRequest *request = [[CreateGroupRequest alloc] init];
    request.group.groupInfo.targetId = groupId;
    request.group.groupInfo.name = groupName;
    request.group.groupInfo.portrait = groupPortrait;
    [request.group.membersArray addObjectsFromArray:groupMembers];
    request.notifyContent = notifyContent;
    
    
    NSData *data = request.data;
    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:createGroupTopic message:data];
    
    
    [publishTask send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock(groupId);
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock {
    AddGroupMemberRequest *request = [[AddGroupMemberRequest alloc] init];
    request.groupId = groupId;
    [request.addedMemberArray addObjectsFromArray:members];
    request.notifyContent = notifyContent;
    
    NSData *data = request.data;
    PublishTask *addMemberTask = [[PublishTask alloc] initWithTopic:addGroupMemberTopic message:data];
    
    
    [addMemberTask send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock();
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock {
    RemoveGroupMemberRequest *request = [[RemoveGroupMemberRequest alloc] init];
    request.groupId = groupId;
    [request.removedMemberArray addObjectsFromArray:members];
    request.notifyContent = notifyContent;
    
    NSData *data = request.data;
    PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:kickoffGroupMemberTopic message:data];
    
    
    [removeMemberTask send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock();
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {
    QuitGroupRequest *request = [[QuitGroupRequest alloc] init];
    request.groupId = groupId;
    request.notifyContent = notifyContent;
    
    NSData *data = request.data;
    PublishTask *task = [[PublishTask alloc] initWithTopic:quitGroupTopic message:data];
    
    
    [task send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock();
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {
    DismissGroupRequest *request = [[DismissGroupRequest alloc] init];
    request.groupId = groupId;
    request.notifyContent = notifyContent;
    
    NSData *data = request.data;
    PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:dismissGroupTopic message:data];
    
    
    [removeMemberTask send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock();
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
          notifyContent:(MessageContent *)notifyContent
                success:(void(^)())successBlock
                  error:(void(^)(int error_code))errorBlock {
    ModifyGroupInfoRequest *request = [[ModifyGroupInfoRequest alloc] init];
    request.groupInfo = groupInfo;
    request.notifyContent = notifyContent;
    
    NSData *data = request.data;
    PublishTask *task = [[PublishTask alloc] initWithTopic:modifyGroupInfoTopic message:data];
    
    
    [task send:^(NSData *data){
        if (data) {
            if (successBlock) {
                successBlock();
            }
        }
    } error:^(int error_code) {
        if (errorBlock) {
            errorBlock(error_code);
        }
    }];
}

- (void)getGroupInfo:(NSArray<NSString *> *)groupIds success:(void(^)(NSArray<GroupInfo *> *))successBlock error:(void(^)(int error_code))errorBlock {
    IDListBuf *request = [[IDListBuf alloc] init];
    [request.idArray addObjectsFromArray:groupIds];
    
    NSData *data = request.data;
    PublishTask *task = [[PublishTask alloc] initWithTopic:getGroupInfoTopic message:data];
    
    
    [task send:^(NSData *data){
        if (data) {
            PullGroupInfoResult *result = [PullGroupInfoResult parseFromData:data error:nil];
            successBlock(result.infoArray);
        }
    } error:^(int error_code) {
        errorBlock(error_code);
    }];
}

- (void)getGroupMembers:(NSString *)groupId success:(void(^)(NSArray<NSString *> *))successBlock error:(void(^)(int error_code))errorBlock {
    IDBuf *request = [[IDBuf alloc] init];
    request.id_p = groupId;
    
    NSData *data = request.data;
    PublishTask *task = [[PublishTask alloc] initWithTopic:getGroupMemberTopic message:data];
    
    
    [task send:^(NSData *data){
        if (data) {
            PullGroupMemberResult *result = [PullGroupMemberResult parseFromData:data error:nil];
            successBlock(result.memberArray);
        }
    } error:^(int error_code) {
        errorBlock(error_code);
    }];
}
@end
