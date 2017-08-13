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
#import "Conversation.pbobjc.h"

#import <mars/stn/stn.h>


class IMSendMessageCallback : public mars::stn::SendMessageCallback {
private:
    void(^m_successBlock)(long messageId, long timestamp);
    void(^m_errorBlock)(int error_code);
    Message *m_message;
public:
    IMSendMessageCallback(Message *message, void(^successBlock)(long messageId, long timestamp), void(^errorBlock)(int error_code)) : mars::stn::SendMessageCallback(), m_message(message), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
     void onSuccess(long messageUid, long long timestamp) {
         
        if (m_successBlock) {
            m_successBlock(messageUid, timestamp);
        }
        delete this;
    }
    void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    void onPrepared(long messageId) {
        
    }
    virtual ~IMSendMessageCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
        m_message = nil;
    }
};


class IMCreateGroupCallback : public mars::stn::CreateGroupCallback {
private:
    void(^m_successBlock)(NSString *groupId);
    void(^m_errorBlock)(int error_code);
public:
    IMCreateGroupCallback(void(^successBlock)(NSString *groupId), void(^errorBlock)(int error_code)) : mars::stn::CreateGroupCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    void onSuccess(std::string groupId) {
        if (m_successBlock) {
            m_successBlock([NSString stringWithUTF8String:groupId.c_str()]);
        }
        delete this;
    }
    void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    void onPrepared(long messageId) {
        
    }
    virtual ~IMCreateGroupCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};

class IMGeneralGroupOperationCallback : public mars::stn::GeneralGroupOperationCallback {
private:
    void(^m_successBlock)();
    void(^m_errorBlock)(int error_code);
public:
    IMGeneralGroupOperationCallback(void(^successBlock)(), void(^errorBlock)(int error_code)) : mars::stn::GeneralGroupOperationCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    void onSuccess() {
        if (m_successBlock) {
            m_successBlock();
        }
        delete this;
    }
    void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }

    virtual ~IMGeneralGroupOperationCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};


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

- (int)send:(Message *)message success:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock {
    return mars::stn::sendMessage(message.conversation.type, [message.conversation.target UTF8String], message.content.type, [message.content.searchableContent UTF8String], [message.content.pushContent UTF8String], (const unsigned char *)message.content.data_p.bytes, message.content.data_p.length, new IMSendMessageCallback(message, successBlock, errorBlock));
}

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock {
//    
//    CreateGroupRequest *request = [[CreateGroupRequest alloc] init];
//    request.group.groupInfo.targetId = groupId;
//    request.group.groupInfo.name = groupName;
//    request.group.groupInfo.portrait = groupPortrait;
//    [request.group.membersArray addObjectsFromArray:groupMembers];
//    request.notifyContent = notifyContent;
//    
//    
//    NSData *data = request.data;
//    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:createGroupTopic message:data];
//    
//    
//    [publishTask send:^(NSData *data){
//        if (data) {
//            if (successBlock) {
//                successBlock(groupId);
//            }
//        }
//    } error:^(int error_code) {
//        if (errorBlock) {
//            errorBlock(error_code);
//        }
//    }];
    std::list<std::string> memberList;
    for (NSString *member in groupMembers) {
        memberList.push_back([member UTF8String]);
    }
    mars::stn::createGroup([groupId UTF8String], [groupName UTF8String], [groupPortrait UTF8String], memberList, notifyContent.type, [notifyContent.searchableContent UTF8String], [notifyContent.pushContent UTF8String], (const unsigned char *)notifyContent.data_p.bytes, notifyContent.data_p.length, new IMCreateGroupCallback(successBlock, errorBlock));
}

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock {
//    AddGroupMemberRequest *request = [[AddGroupMemberRequest alloc] init];
//    request.groupId = groupId;
//    [request.addedMemberArray addObjectsFromArray:members];
//    request.notifyContent = notifyContent;
//    
//    NSData *data = request.data;
//    PublishTask *addMemberTask = [[PublishTask alloc] initWithTopic:addGroupMemberTopic message:data];
//    
//    
//    [addMemberTask send:^(NSData *data){
//        if (data) {
//            if (successBlock) {
//                successBlock();
//            }
//        }
//    } error:^(int error_code) {
//        if (errorBlock) {
//            errorBlock(error_code);
//        }
//    }];
    std::list<std::string> memberList;
    for (NSString *member in members) {
        memberList.push_back([member UTF8String]);
    }

    mars::stn::addMembers([groupId UTF8String], memberList, notifyContent.type, [notifyContent.searchableContent UTF8String], [notifyContent.pushContent UTF8String], (const unsigned char *)notifyContent.data_p.bytes, notifyContent.data_p.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock {
//    RemoveGroupMemberRequest *request = [[RemoveGroupMemberRequest alloc] init];
//    request.groupId = groupId;
//    [request.removedMemberArray addObjectsFromArray:members];
//    request.notifyContent = notifyContent;
//    
//    NSData *data = request.data;
//    PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:kickoffGroupMemberTopic message:data];
//    
//    
//    [removeMemberTask send:^(NSData *data){
//        if (data) {
//            if (successBlock) {
//                successBlock();
//            }
//        }
//    } error:^(int error_code) {
//        if (errorBlock) {
//            errorBlock(error_code);
//        }
//    }];
    std::list<std::string> memberList;
    for (NSString *member in members) {
        memberList.push_back([member UTF8String]);
    }
    
    mars::stn::kickoffMembers([groupId UTF8String], memberList, notifyContent.type, [notifyContent.searchableContent UTF8String], [notifyContent.pushContent UTF8String], (const unsigned char *)notifyContent.data_p.bytes, notifyContent.data_p.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {
//    QuitGroupRequest *request = [[QuitGroupRequest alloc] init];
//    request.groupId = groupId;
//    request.notifyContent = notifyContent;
//    
//    NSData *data = request.data;
//    PublishTask *task = [[PublishTask alloc] initWithTopic:quitGroupTopic message:data];
//    
//    
//    [task send:^(NSData *data){
//        if (data) {
//            if (successBlock) {
//                successBlock();
//            }
//        }
//    } error:^(int error_code) {
//        if (errorBlock) {
//            errorBlock(error_code);
//        }
//    }];
        mars::stn::quitGroup([groupId UTF8String], notifyContent.type, [notifyContent.searchableContent UTF8String], [notifyContent.pushContent UTF8String], (const unsigned char *)notifyContent.data_p.bytes, notifyContent.data_p.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {
//    DismissGroupRequest *request = [[DismissGroupRequest alloc] init];
//    request.groupId = groupId;
//    request.notifyContent = notifyContent;
//    
//    NSData *data = request.data;
//    PublishTask *removeMemberTask = [[PublishTask alloc] initWithTopic:dismissGroupTopic message:data];
//    
//    
//    [removeMemberTask send:^(NSData *data){
//        if (data) {
//            if (successBlock) {
//                successBlock();
//            }
//        }
//    } error:^(int error_code) {
//        if (errorBlock) {
//            errorBlock(error_code);
//        }
//    }];
//    
    mars::stn::dismissGroup([groupId UTF8String], notifyContent.type, [notifyContent.searchableContent UTF8String], [notifyContent.pushContent UTF8String], (const unsigned char *)notifyContent.data_p.bytes, notifyContent.data_p.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
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
