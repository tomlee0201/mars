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
#import "MediaMessageContent.h"
#import <mars/stn/MessageDB.hpp>
#import <objc/runtime.h>


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
    void onPrepared(long messageId, int64_t savedTime) {
        m_message.messageId = messageId;
        m_message.serverTime = savedTime;
    }
    void onMediaUploaded(std::string remoteUrl) {
        if ([m_message.content isKindOfClass:[MediaMessageContent class]]) {
            MediaMessageContent *mediaContent = (MediaMessageContent *)m_message.content;
            mediaContent.remoteUrl = [NSString stringWithUTF8String:remoteUrl.c_str()];
        }
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
                gi.extra = [NSData dataWithBytes:(const void *)tgi.extra.c_str() length:tgi.extra.length()];
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


static Message *convertProtoMessage(const mars::stn::TMessage *tMessage) {
    Message *ret = [[Message alloc] init];
    ret.fromUser = [NSString stringWithUTF8String:tMessage->from.c_str()];
    ret.conversation = [[Conversation alloc] init];
    ret.conversation.type = (ConversationType)tMessage->conversationType;
    ret.conversation.target = [NSString stringWithUTF8String:tMessage->target.c_str()];
    ret.conversation.line = tMessage->line;
    ret.messageId = tMessage->messageId;
    ret.messageUid = tMessage->messageUid;
    ret.serverTime = tMessage->timestamp;
    ret.direction = (MessageDirection)tMessage->direction;
    ret.status = (MessageStatus)tMessage->status;
    
    MediaMessagePayload *payload = [[MediaMessagePayload alloc] init];
    payload.contentType = tMessage->content.type;
    payload.searchableContent = [NSString stringWithUTF8String:tMessage->content.searchableContent.c_str()];
    payload.pushContent = [NSString stringWithUTF8String:tMessage->content.pushContent.c_str()];
    
    payload.content = [NSString stringWithUTF8String:tMessage->content.content.c_str()];
    payload.binaryContent = [NSData dataWithBytes:tMessage->content.binaryContent.c_str() length:tMessage->content.binaryContent.length()];
    payload.localContent = [NSString stringWithUTF8String:tMessage->content.localContent.c_str()];
    payload.mediaType = (MediaType)tMessage->content.mediaType;
    payload.remoteMediaUrl = [NSString stringWithUTF8String:tMessage->content.remoteMediaUrl.c_str()];
    payload.localMediaPath = [NSString stringWithUTF8String:tMessage->content.localMediaPath.c_str()];
    
    ret.content = [[IMService sharedIMService] messageContentFromPayload:payload];
    return ret;
}


NSMutableArray* convertProtoMessageList(const std::list<mars::stn::TMessage> &messageList) {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (std::list<mars::stn::TMessage>::const_iterator it = messageList.begin(); it != messageList.end(); it++) {
        const mars::stn::TMessage &tmsg = *it;
        Message *msg = convertProtoMessage(&tmsg);
        [messages insertObject:msg atIndex:0];
        
    }
    return messages;
}


static IMService * sharedSingleton = nil;

static void fillTMessage(mars::stn::TMessage &tmsg, Conversation *conv, MessagePayload *payload) {
    tmsg.conversationType = conv.type;
    tmsg.target = conv.target ? [conv.target UTF8String] : "";
    tmsg.line = conv.line;
    tmsg.from = mars::app::GetUserName();
    tmsg.content.type = payload.contentType;
    
 
    
    tmsg.content.searchableContent = [payload.searchableContent UTF8String] ? [payload.searchableContent UTF8String] : "";
    tmsg.content.pushContent = [payload.pushContent UTF8String] ? [payload.pushContent UTF8String] : "";
    
    tmsg.content.content = [payload.content UTF8String] ? [payload.content UTF8String] : "";
    if (payload.binaryContent != nil) {
        tmsg.content.binaryContent = std::string((const char *)payload.binaryContent.bytes, payload.binaryContent.length);
    }
    tmsg.content.localContent = [payload.localContent UTF8String] ? [payload.localContent UTF8String] : "";
    if ([payload isKindOfClass:[MediaMessagePayload class]]) {
        MediaMessagePayload *mediaPayload = (MediaMessagePayload *)payload;
        tmsg.content.mediaType = mediaPayload.mediaType;
        tmsg.content.remoteMediaUrl = [mediaPayload.remoteMediaUrl UTF8String] ? [mediaPayload.remoteMediaUrl UTF8String] : "";
        tmsg.content.localMediaPath = [mediaPayload.localMediaPath UTF8String] ? [mediaPayload.localMediaPath UTF8String] : "";
    }
    
    tmsg.status = mars::stn::MessageStatus::Message_Status_Sending;
    tmsg.timestamp = time(NULL)*1000;
    tmsg.direction = 0;
}

@interface IMService ()
@property(nonatomic, strong)NSMutableDictionary<NSNumber *, Class> *MessageContentMaps;
@end
@implementation IMService
+ (IMService *)sharedIMService {
    if (sharedSingleton == nil) {
        @synchronized (self) {
            if (sharedSingleton == nil) {
                sharedSingleton = [[IMService alloc] init];
                sharedSingleton.MessageContentMaps = [[NSMutableDictionary alloc] init];
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
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, conversation, payload);
    mars::stn::sendMessage(tmsg, new IMSendMessageCallback(message, successBlock, errorBlock));
    return message;
}

- (NSArray<ConversationInfo *> *)getConversations:(NSArray<NSNumber *> *)conversationTypes lines:(NSArray<NSNumber *> *)lines{
    std::list<int> types;
    for (NSNumber *type in conversationTypes) {
        types.push_back([type intValue]);
    }
    
    std::list<int> ls;
    for (NSNumber *type in lines) {
        ls.push_back([type intValue]);
    }
    std::list<mars::stn::TConversation> convers = mars::stn::MessageDB::Instance()->GetConversationList(types, ls);
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (std::list<mars::stn::TConversation>::iterator it = convers.begin(); it != convers.end(); it++) {
        mars::stn::TConversation &tConv = *it;
        ConversationInfo *info = [[ConversationInfo alloc] init];
        info.conversation = [[Conversation alloc] init];
        info.conversation.type = (ConversationType)tConv.conversationType;
        info.conversation.target = [NSString stringWithUTF8String:tConv.target.c_str()];
        info.conversation.line = tConv.line;
        info.lastMessage = convertProtoMessage(&tConv.lastMessage);
        info.draft = [NSString stringWithUTF8String:tConv.draft.c_str()];
        info.timestamp = tConv.timestamp;
        info.unreadCount = tConv.unreadCount;
        info.isTop = tConv.isTop;
        [ret addObject:info];
    }
    return ret;
}

- (NSArray<Message *> *)getMessages:(Conversation *)conversation from:(NSUInteger)fromIndex count:(NSUInteger)count {
    std::list<mars::stn::TMessage> messages = mars::stn::MessageDB::Instance()->GetMessages(conversation.type, [conversation.target UTF8String], conversation.line, true, (int)count, fromIndex);
    return convertProtoMessageList(messages);
}

- (void)createGroup:(NSString *)groupId
               line:(int)line
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
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    mars::stn::createGroup([groupId UTF8String], [groupName UTF8String], [groupPortrait UTF8String], memberList, tmsg, new IMCreateGroupCallback(successBlock, errorBlock));
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
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    mars::stn::addMembers([groupId UTF8String], memberList, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
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
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    mars::stn::kickoffMembers([groupId UTF8String], memberList, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)quitGroup:(NSString *)groupId
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {

        MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
        mars::stn::quitGroup([groupId UTF8String], tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)dismissGroup:(NSString *)groupId
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {

    MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    mars::stn::dismissGroup([groupId UTF8String], tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
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
        tInfo.extra = std::string((char *)groupInfo.extra.bytes, groupInfo.extra.length);
    }
    MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    mars::stn::modifyGroupInfo([groupInfo.target UTF8String], tInfo, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
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

- (MessageContent *)messageContentFromPayload:(MessagePayload *)payload {
    int contenttype = payload.contentType;
    Class contentClass = self.MessageContentMaps[@(contenttype)];
    if (contentClass != nil) {
        id messageInstance = [[contentClass alloc] init];
        
        if ([contentClass conformsToProtocol:@protocol(MessageContent)]) {
            if ([messageInstance respondsToSelector:@selector(decode:)]) {
                [messageInstance performSelector:@selector(decode:)
                                      withObject:payload];
            }
        }
        return messageInstance;
    }
    return nil;
}

- (void)registerMessageContent:(Class)contentClass {
    int contenttype;
    if (class_getClassMethod(contentClass, @selector(getContentType))) {
        contenttype = [contentClass getContentType];
        self.MessageContentMaps[@(contenttype)] = contentClass;
    } else {
        return;
    }
}


@end
