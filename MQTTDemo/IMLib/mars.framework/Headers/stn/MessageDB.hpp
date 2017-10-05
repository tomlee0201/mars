//
//  MessageDB.hpp
//  stn
//
//  Created by Tao Li on 2017/8/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef MessageDB_hpp
#define MessageDB_hpp


#include <stdio.h>
#include "mars/app/app.h"
#include "mars/app/app_logic.h"
#include "mars/stn/stn.h"
namespace mars {
    namespace stn {
        class MessageDB {
            
        private:
            MessageDB();
            ~MessageDB();
            
        public:
            static MessageDB* Instance();
            long InsertMessage(TMessage &msg);
            
            bool UpdateMessageContent(long messageId, TMessageContent &msgConstnet);
            bool DeleteMessage(long messageId);
            
            bool UpdateMessageContentByUid(int64_t messageUid, TMessageContent &msgConstnet);
            bool DeleteMessageByUid(int64_t messageUid);
            
            bool UpdateMessageTimeline(int64_t timeline);
            int64_t GetMessageTimeline();
            
            bool updateConversationTimestamp(int conversationType, const std::string &target, int line, int64_t timestamp);
            bool updateConversationIsTop(int conversationType, const std::string &target, int line, bool istop);
            bool updateConversationDraft(int conversationType, const std::string &target, int line, const std::string &draft);
            
            TConversation GetConversation(int conversationType, const std::string &target, int line);
            std::list<TConversation> GetConversationList(const std::list<int> &conversationTypes, const std::list<int> &lines);
            
            bool RemoveConversation(int conversationType, const std::string &target, int line, bool clearMessage = false);
            
            std::list<TMessage> GetMessages(int conversationType, const std::string &target, int line, bool desc, int count, long startPoint);
            
            bool updateMessageStatus(long messageId, MessageStatus status);
            bool updateMessageRemoteMediaUrl(long messageId, const std::string &remoteMediaUrl);
            bool updateMessageLocalMediaPath(long messageId, const std::string &localMediaPath);
            
            int GetUnreadCount(int conversationType, const std::string &target, int line);
            
            int GetUnreadCount(const std::list<int> &conversationTypes, const std::list<int> lines);
            bool ClearUnreadStatus(int conversationType, const std::string &target, int line);
            bool ClearAllUnreadStatus();
            
            bool FailSendingMessages();
            
            
            TGroupInfo GetGroupInfo(const std::string &groupId, int line, bool refresh);
            long InsertGroupInfo(const TGroupInfo &groupInfo);
            
            TUserInfo getUserInfo(const std::string &userId, bool refresh);
            long InsertUserInfoOrReplace(const TUserInfo &userInfo);
        private:
            static MessageDB* instance_;
        };
        
    }
}


#endif /* MessageDB_hpp */
