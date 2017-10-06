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

class IMGetMyGroupCallback : public mars::stn::GetMyGroupsCallback {
private:
    void(^m_successBlock)(NSArray<NSString *> *);
    void(^m_errorBlock)(int error_code);
public:
    IMGetMyGroupCallback(void(^successBlock)(NSArray<NSString *> *), void(^errorBlock)(int error_code)) : mars::stn::GetMyGroupsCallback(), m_successBlock(successBlock), m_errorBlock(errorBlock) {};
    void onSuccess(std::list<std::string> MyGroupList) {
        if (m_successBlock) {
            NSMutableArray *ret = [[NSMutableArray alloc] init];
            for (std::list<std::string>::iterator it = MyGroupList.begin(); it != MyGroupList.end(); it++) {
                
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
    
    virtual ~IMGetMyGroupCallback() {
        m_successBlock = nil;
        m_errorBlock = nil;
    }
};

class GeneralUpdateMediaCallback : public mars::stn::UpdateMediaCallback {
public:
  void(^m_successBlock)(NSString *remoteUrl);
  void(^m_errorBlock)(int error_code);
  
  GeneralUpdateMediaCallback(void(^successBlock)(NSString *remoteUrl), void(^errorBlock)(int error_code)) : mars::stn::UpdateMediaCallback(), m_successBlock(successBlock) {}
  
  void onSuccess(const std::string &remoteUrl) {
    m_successBlock([NSString stringWithUTF8String:remoteUrl.c_str()]);
    delete this;
  }
  
  void onFalure(int errorCode) {
    m_errorBlock(errorCode);
    delete this;
  }
  
  ~GeneralUpdateMediaCallback() {
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
- (int)getUnreadCount:(Conversation *)conversation {
    return mars::stn::MessageDB::Instance()->GetUnreadCount(conversation.type, [conversation.target UTF8String], conversation.line);
}

- (int)getUnreadCount:(NSArray<NSNumber *> *)conversationTypes lines:(NSArray<NSNumber *>*)lines {
    std::list<int> types;
    std::list<int> ls;
    for (NSNumber *type in conversationTypes) {
        types.insert(types.end(), type.intValue);
    }
    
    for (NSNumber *line in lines) {
        ls.insert(ls.end(), line.intValue);
    }
    return mars::stn::MessageDB::Instance()->GetUnreadCount(types, ls);
}

- (void)clearUnreadStatus:(Conversation *)conversation {
    mars::stn::MessageDB::Instance()->ClearUnreadStatus(conversation.type, [conversation.target UTF8String], conversation.line);
}

- (void)clearAllUnreadStatus {
    mars::stn::MessageDB::Instance()->ClearAllUnreadStatus();
}

- (void)removeConversation:(Conversation *)conversation clearMessage:(BOOL)clearMessage {
    mars::stn::MessageDB::Instance()->RemoveConversation(conversation.type, [conversation.target UTF8String], conversation.line, clearMessage);
}

- (void)setConversation:(Conversation *)conversation top:(BOOL)top {
    mars::stn::MessageDB::Instance()->updateConversationIsTop(conversation.type, [conversation.target UTF8String], conversation.line, top);
}
- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
        notifyLines:(NSArray<NSNumber *> *)notifyLines
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
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    mars::stn::createGroup(groupId == nil ? "" : [groupId UTF8String], groupName == nil ? "" : [groupName UTF8String], groupPortrait == nil ? "" : [groupPortrait UTF8String], memberList, lines, tmsg, new IMCreateGroupCallback(successBlock, errorBlock));
}

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
       notifyLines:(NSArray<NSNumber *> *)notifyLines
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
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::addMembers([groupId UTF8String], memberList, lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
           notifyLines:(NSArray<NSNumber *> *)notifyLines
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
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::kickoffMembers([groupId UTF8String], memberList, lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)quitGroup:(NSString *)groupId
      notifyLines:(NSArray<NSNumber *> *)notifyLines
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock {

        MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::quitGroup([groupId UTF8String], lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)dismissGroup:(NSString *)groupId
         notifyLines:(NSArray<NSNumber *> *)notifyLines
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock {

    MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::dismissGroup([groupId UTF8String], lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
            notifyLines:(NSArray<NSNumber *> *)notifyLines
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
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::modifyGroupInfo([groupInfo.target UTF8String], tInfo, lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)getGroupInfo:(NSArray<NSString *> *)groupIds success:(void(^)(NSArray<GroupInfo *> *))successBlock error:(void(^)(int error_code))errorBlock {

    std::list<std::string> idList;
    for (NSString *groupId in groupIds) {
        idList.push_back([groupId UTF8String]);
    }
    
   // mars::stn::getGroupInfo(idList, new IMGetGroupInfoCallback(successBlock, errorBlock));
}

- (void)getGroupMembers:(NSString *)groupId success:(void(^)(NSArray<NSString *> *))successBlock error:(void(^)(int error_code))errorBlock {

    mars::stn::getGroupMembers([groupId UTF8String], new IMGetGroupMemberCallback(successBlock, errorBlock));
}

- (void)getMyGroups:(void(^)(NSArray<NSString *> *))successBlock
              error:(void(^)(int error_code))errorBlock {
    mars::stn::getMyGroups(new IMGetMyGroupCallback(successBlock, errorBlock));
}

- (void)transferGroup:(NSString *)groupId
                   to:(NSString *)newOwner
          notifyLines:(NSArray<NSNumber *> *)notifyLines
        notifyContent:(MessageContent *)notifyContent
              success:(void(^)())successBlock
                error:(void(^)(int error_code))errorBlock {
    MessagePayload *payload = [notifyContent encode];
    mars::stn::TMessage tmsg;
    fillTMessage(tmsg, nil, payload);
    
    std::list<int> lines;
    for (NSNumber *number in notifyLines) {
        lines.push_back([number intValue]);
    }
    
    mars::stn::transferGroup([groupId UTF8String], [newOwner UTF8String], lines, tmsg, new IMGeneralGroupOperationCallback(successBlock, errorBlock));
}

- (void)uploadMedia:(NSData *)mediaData mediaType:(MediaType)mediaType success:(void(^)(NSString *remoteUrl))successBlock error:(void(^)(int error_code))errorBlock {
  mars::stn::uploadGeneralMedia(std::string((char *)mediaData.bytes, mediaData.length), mediaType, new GeneralUpdateMediaCallback(successBlock, errorBlock));
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

- (BOOL)deleteMessage:(long)messageId {
    return mars::stn::MessageDB::Instance()->DeleteMessage(messageId);
}

- (GroupInfo *)getGroupInfo:(NSString *)groupId refresh:(BOOL)refresh {
    mars::stn::TGroupInfo tgi = mars::stn::MessageDB::Instance()->GetGroupInfo([groupId UTF8String], refresh);
    if (!tgi.target.empty()) {
        GroupInfo *groupInfo = [[GroupInfo alloc] init];
        groupInfo.type = (GroupType)tgi.type;
        groupInfo.target = [NSString stringWithUTF8String:tgi.target.c_str()];
        groupInfo.name = [NSString stringWithUTF8String:tgi.name.c_str()];
        groupInfo.extra = [NSData dataWithBytes:tgi.extra.c_str() length:tgi.extra.length()];
        groupInfo.portrait = [NSString stringWithUTF8String:tgi.portrait.c_str()];
        groupInfo.owner = [NSString stringWithUTF8String:tgi.owner.c_str()];
        return groupInfo;
    }
    return nil;
}

- (UserInfo *)getUserInfo:(NSString *)userId refresh:(BOOL)refresh {
    mars::stn::TUserInfo tui = mars::stn::MessageDB::Instance()->getUserInfo([userId UTF8String], refresh);
    if (!tui.uid.empty()) {
        UserInfo *userInfo = [[UserInfo alloc] init];
        userInfo.userId = [NSString stringWithUTF8String:tui.uid.c_str()];
        userInfo.name = [NSString stringWithUTF8String:tui.name.c_str()];
        userInfo.portrait = [NSString stringWithUTF8String:tui.portrait.c_str()];
        
        userInfo.displayName = [NSString stringWithUTF8String:tui.displayName.c_str()];
        userInfo.mobile = [NSString stringWithUTF8String:tui.mobile.c_str()];
        userInfo.email = [NSString stringWithUTF8String:tui.email.c_str()];
        userInfo.address = [NSString stringWithUTF8String:tui.address.c_str()];
        userInfo.company = [NSString stringWithUTF8String:tui.company.c_str()];
        userInfo.social = [NSString stringWithUTF8String:tui.social.c_str()];
        userInfo.extra = [NSString stringWithUTF8String:tui.extra.c_str()];
        userInfo.updateDt = tui.updateDt;
        return userInfo;
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
