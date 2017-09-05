//
//  IMService.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "IMService.h"
#import "PublishTask.h"
#import <mars/stn/stn.h>


class IMSendMessageCallback : public mars::stn::SendMessageCallback {
private:
    void(^m_successBlock)(long messageId, long timestamp);
    void(^m_errorBlock)(int error_code);
    Message *m_message;
public:
    IMSendMessageCallback(Message *message, void(^successBlock)(long messageId, long timestamp), void(^errorBlock)(int error_code)) : mars::stn::SendMessageCallback(), m_message(message), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
     void onSuccess(long messageUid, long long timestamp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_message.messageUid = messageUid;
            m_message.serverTime = timestamp;
            m_message.status = Message_Status_Sent;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMessageStatusChanged" object:@(m_message.messageId) userInfo:@{@"status":@(Message_Status_Sent), @"messageUid":@(messageUid), @"timestamp":@(timestamp)}];
            if (m_successBlock) {
                m_successBlock(messageUid, timestamp);
            }
            delete this;

        });
     }
    void onFalure(int errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_message.status = Message_Status_Send_Failure;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMessageStatusChanged" object:@(m_message.messageId) userInfo:@{@"status":@(Message_Status_Send_Failure)}];
            if (m_errorBlock) {
                m_errorBlock(errorCode);
            }
            delete this;
        });
    }
    void onPrepared(long messageId) {
        m_message.messageId = messageId;
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

class IMGetGroupInfoCallback : public mars::stn::GetGroupInfoCallback {
private:
    void(^m_successBlock)(NSArray<GroupInfo *> *);
    void(^m_errorBlock)(int error_code);
public:
    IMGetGroupInfoCallback(void(^successBlock)(NSArray<GroupInfo *> *), void(^errorBlock)(int error_code)) : mars::stn::GetGroupInfoCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    void onSuccess(std::list<mars::stn::TGroupInfo> groupInfoList) {
        if (m_successBlock) {
            NSMutableArray *ret = [[NSMutableArray alloc] init];
            for (std::list<mars::stn::TGroupInfo>::iterator it = groupInfoList.begin(); it != groupInfoList.end(); it++) {
                GroupInfo *gi = [[GroupInfo alloc] init];
                mars::stn::TGroupInfo &tgi = *it;
                gi.target = [NSString stringWithUTF8String:tgi.target.c_str()];
                gi.type = (GroupType)tgi.type;
                gi.name = [NSString stringWithUTF8String:tgi.name.c_str()];
                gi.owner = [NSString stringWithUTF8String:tgi.owner.c_str()];
                gi.extra = [NSData dataWithBytes:(const void *)tgi.extraData length:tgi.extraLen];
                [ret addObject:gi];
            }
            m_successBlock(ret);
        }
        delete this;
    }
    void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    
    virtual ~IMGetGroupInfoCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};

class IMGetGroupMemberCallback : public mars::stn::GetGroupMembersCallback {
private:
    void(^m_successBlock)(NSArray<NSString *> *);
    void(^m_errorBlock)(int error_code);
public:
    IMGetGroupMemberCallback(void(^successBlock)(NSArray<NSString *> *), void(^errorBlock)(int error_code)) : mars::stn::GetGroupMembersCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    void onSuccess(std::list<std::string> groupMemberList) {
        if (m_successBlock) {
            NSMutableArray *ret = [[NSMutableArray alloc] init];
            for (std::list<std::string>::iterator it = groupMemberList.begin(); it != groupMemberList.end(); it++) {
                
                [ret addObject:[NSString stringWithUTF8String:(*it).c_str()]];
            }
            m_successBlock(ret);
        }
        delete this;
    }
    void onFalure(int errorCode) {
        if (m_errorBlock) {
            m_errorBlock(errorCode);
        }
        delete this;
    }
    
    virtual ~IMGetGroupMemberCallback() {
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

- (Message *)send:(Conversation *)conversation content:(MessageContent *)content success:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock {
    Message *message = [[Message alloc] init];
    message.conversation = conversation;
    message.content = content;
    MessagePayload *payload = [content encode];
    mars::stn::sendMessage(conversation.type, [conversation.target UTF8String], payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMSendMessageCallback(message, successBlock, errorBlock), (const unsigned char *)payload.mediaData.bytes, payload.mediaData.length);
    return message;
}

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock {

    std::list<std::string> memberList;
    for (NSString *member in groupMembers) {
        memberList.push_back([member UTF8String]);
    }
    MessagePayload *payload = [notifyContent encode];
    mars::stn::createGroup([groupId UTF8String], [groupName UTF8String], [groupPortrait UTF8String], memberList, payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMCreateGroupCallback(successBlock, errorBlock));
}

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock {

    std::list<std::string> memberList;
    for (NSString *member in members) {
        memberList.push_back([member UTF8String]);
    }
    MessagePayload *payload = [notifyContent encode];
    mars::stn::addMembers([groupId UTF8String], memberList, payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock {

    std::list<std::string> memberList;
    for (NSString *member in members) {
        memberList.push_back([member UTF8String]);
    }
    MessagePayload *payload = [notifyContent encode];
    mars::stn::kickoffMembers([groupId UTF8String], memberList, payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {

        MessagePayload *payload = [notifyContent encode];
        mars::stn::quitGroup([groupId UTF8String], payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {

    MessagePayload *payload = [notifyContent encode];
    mars::stn::dismissGroup([groupId UTF8String], payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char *)payload.data.bytes, payload.data.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
          notifyContent:(MessageContent *)notifyContent
                success:(void(^)())successBlock
                  error:(void(^)(int error_code))errorBlock {
    
    mars::stn::TGroupInfo tInfo;
    tInfo.target = [groupInfo.target UTF8String];
    if (groupInfo.name) {
        tInfo.name = [groupInfo.name UTF8String];
    }
    if (groupInfo.portrait) {
        tInfo.portrait = [groupInfo.portrait UTF8String];
    }
    if (groupInfo.owner) {
        tInfo.owner = [groupInfo.owner UTF8String];
    }
    if (groupInfo.extra) {
        tInfo.extraData = (unsigned char *)groupInfo.extra.bytes;
        tInfo.extraLen = groupInfo.extra.length;
    }
    MessagePayload *payload = [notifyContent encode];
    mars::stn::modifyGroupInfo([groupInfo.target UTF8String], tInfo, payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], (const unsigned char*)payload.data.bytes, payload.data.length, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)getGroupInfo:(NSArray<NSString *> *)groupIds success:(void(^)(NSArray<GroupInfo *> *))successBlock error:(void(^)(int error_code))errorBlock {

    std::list<std::string> idList;
    for (NSString *groupId in groupIds) {
        idList.push_back([groupId UTF8String]);
    }
    
    mars::stn::getGroupInfo(idList, new IMGetGroupInfoCallback(successBlock, errorBlock));
}

- (void)getGroupMembers:(NSString *)groupId success:(void(^)(NSArray<NSString *> *))successBlock error:(void(^)(int error_code))errorBlock {

    mars::stn::getGroupMembers([groupId UTF8String], new IMGetGroupMemberCallback(successBlock, errorBlock));
}

@end
