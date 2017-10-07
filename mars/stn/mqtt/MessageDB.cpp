//
//  MessageDB.cpp
//  stn
//
//  Created by Tao Li on 2017/8/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#include "MessageDB.hpp"
#include "DB.hpp"
#include <WCDB/core_base.hpp>
#include <WCDB/database.hpp>
#include <WCDB/statement_create_table.hpp>
#include <WCDB/declare.hpp>
#include <WCDB/expr.hpp>
#include <WCDB/order.hpp>
#include <WCDB/column_type.hpp>
#include "mars/stn/mqtt/stn_callback.h"

namespace mars {
    namespace stn {
        
        MessageDB* MessageDB::instance_ = NULL;
        
        MessageDB* MessageDB::Instance() {
            if(instance_ == NULL) {
                instance_ = new MessageDB();
            }
            
            return instance_;
        }
        
        MessageDB::MessageDB() {
            
        }
        
        MessageDB::~MessageDB() {
            
        }
    
        
        long MessageDB::InsertMessage(TMessage &msg) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return -1;
            }
            

            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(MESSAGE_TABLE_NAME, {"_conv_type","_conv_target","_conv_line","_from","_cont_type","_cont_searchable","_cont_push","_cont","_cont_data","_cont_local","_cont_media_type","_cont_remote_media_url","_cont_local_media_path","_direction","_status","_uid","_timestamp"});
            db->Bind(statementHandle, msg.conversationType, 1);
            db->Bind(statementHandle, msg.target, 2);
            db->Bind(statementHandle, msg.line, 3);
            db->Bind(statementHandle, msg.from, 4);
            
            db->Bind(statementHandle, msg.content.type, 5);
            db->Bind(statementHandle, msg.content.searchableContent, 6);
            db->Bind(statementHandle, msg.content.pushContent, 7);
            db->Bind(statementHandle, msg.content.content, 8);
            db->Bind(statementHandle, (const void *)msg.content.binaryContent.c_str(), (int)msg.content.binaryContent.length(), 9);
            db->Bind(statementHandle, msg.content.localContent, 10);
            db->Bind(statementHandle, msg.content.mediaType, 11);
            db->Bind(statementHandle, msg.content.remoteMediaUrl, 12);
            db->Bind(statementHandle, msg.content.localMediaPath, 13);
            
            db->Bind(statementHandle, msg.direction, 14);
            db->Bind(statementHandle, msg.status, 15);
            
            db->Bind(statementHandle, msg.messageUid, 16);
            db->Bind(statementHandle, msg.timestamp, 17);
            
            db->ExecuteInsert(statementHandle, &(msg.messageId));
            return msg.messageId;
        }
        
        bool MessageDB::UpdateMessageContent(long messageId, TMessageContent &content) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_id")) == messageId);
            WCDB::RecyclableStatement statementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_cont_type","_cont_searchable","_cont_push","_cont","_cont_data","_cont_local","_cont_media_type","_cont_remote_media_url","_cont_local_media_path"}, &where);
            
            db->Bind(statementHandle, content.type, 5);
            db->Bind(statementHandle, content.searchableContent, 6);
            db->Bind(statementHandle, content.pushContent, 7);
            db->Bind(statementHandle, content.content, 8);
            db->Bind(statementHandle, (const void *)content.binaryContent.c_str(), (int)content.binaryContent.length(), 9);
            db->Bind(statementHandle, content.localContent, 10);
            db->Bind(statementHandle, content.mediaType, 11);
            db->Bind(statementHandle, content.remoteMediaUrl, 12);
            db->Bind(statementHandle, content.localMediaPath, 13);
            
            int count = db->ExecuteUpdate(statementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;

        }
        bool MessageDB::DeleteMessage(long messageId) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            std::list<const WCDB::Expr> exprsType;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_id")) == messageId);
            
            WCDB::RecyclableStatement statementHandle = db->GetDeleteStatement(MESSAGE_TABLE_NAME, &where);
            
            if (db->ExecuteDelete(statementHandle) > 0) {
                return true;
            }
            
            return false;
        }
        
        bool MessageDB::UpdateMessageContentByUid(int64_t messageUid, TMessageContent &content) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_uid")) == messageUid);
            WCDB::RecyclableStatement statementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_cont_type","_cont_searchable","_cont_push","_cont","_cont_data","_cont_local","_cont_media_type","_cont_remote_media_url","_cont_local_media_path"}, &where);
            
            db->Bind(statementHandle, content.type, 5);
            db->Bind(statementHandle, content.searchableContent, 6);
            db->Bind(statementHandle, content.pushContent, 7);
            db->Bind(statementHandle, content.content, 8);
            db->Bind(statementHandle, (const void *)content.binaryContent.c_str(), (int)content.binaryContent.length(), 9);
            db->Bind(statementHandle, content.localContent, 10);
            db->Bind(statementHandle, content.mediaType, 11);
            db->Bind(statementHandle, content.remoteMediaUrl, 12);
            db->Bind(statementHandle, content.localMediaPath, 13);
            
            int count = db->ExecuteUpdate(statementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        bool MessageDB::DeleteMessageByUid(int64_t messageUid) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            
            WCDB::Error error;
            std::list<const WCDB::Expr> exprsType;
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_uid")) == messageUid);
            WCDB::RecyclableStatement statementHandle = db->GetDeleteStatement(MESSAGE_TABLE_NAME, &where);
            
            if (db->ExecuteDelete(statementHandle) > 0) {
                return true;
            }
            
            return false;
        }
        
        bool MessageDB::UpdateMessageTimeline(int64_t timeline) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::RecyclableStatement statementHandle = db->GetUpdateStatement(TIMELINE_TABLE_NAME, {"_head"});
            db->Bind(statementHandle, timeline, 1);
            return db->ExecuteUpdate(statementHandle) > 0;
        }
        
        int64_t MessageDB::GetMessageTimeline() {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return -1;
            }
          
            WCDB::Error error;
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(TIMELINE_TABLE_NAME, {"_head"}, error);
            if (statementHandle->step()) {
                int64_t head = db->getBigIntValue(statementHandle, 0);
                return head;
            }
            
            return 0;
        }

        bool MessageDB::updateConversationTimestamp(int conversationType, const std::string &target, int line, int64_t timestamp) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
          
            WCDB::Error error;
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(CONVERSATION_TABLE_NAME, {"_timestamp"}, &where);
            db->Bind(updateStatementHandle, timestamp, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(CONVERSATION_TABLE_NAME, {"_conv_type", "_conv_target", "_conv_line", "_timestamp"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, line, 3);
            db->Bind(statementHandle, timestamp, 4);
            return db->ExecuteInsert(statementHandle);
        }
        
        bool MessageDB::updateConversationIsTop(int conversationType, const std::string &target, int line, bool istop) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(CONVERSATION_TABLE_NAME, {"_istop"}, &where);
            db->Bind(updateStatementHandle, istop, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(CONVERSATION_TABLE_NAME, {"_conv_type", "_conv_target", "_conv_line", "_istop"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, line, 3);
            db->Bind(statementHandle, istop, 4);
            return db->ExecuteInsert(statementHandle);
        }
        
        bool MessageDB::updateConversationDraft(int conversationType, const std::string &target, int line, const std::string &draft) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(CONVERSATION_TABLE_NAME, {"_draft"}, &where);
            db->Bind(updateStatementHandle, draft, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(CONVERSATION_TABLE_NAME, {"_conv_type", "_conv_target", "_conv_line", "_draft"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, line, 3);
            db->Bind(statementHandle, draft, 4);
            return db->ExecuteInsert(statementHandle);
        }
        std::list<TConversation> MessageDB::GetConversationList(const std::list<int> &conversationTypes, const std::list<int> &lines) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return std::list<TConversation>();
            }
            WCDB::Error error;
          
            std::list<const WCDB::Expr> exprsType;
            for (std::list<int>::const_iterator it = conversationTypes.begin(); it != conversationTypes.end(); it++) {
                exprsType.push_back(WCDB::Expr(*it));
            }
            
            std::list<const WCDB::Expr> exprsLine;
            for (std::list<int>::const_iterator it = lines.begin(); it != lines.end(); it++) {
                exprsLine.push_back(WCDB::Expr(*it));
            }

            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")).in(exprsType)) && WCDB::Expr(WCDB::Column("_conv_line")).in(exprsLine);
            std::list<const WCDB::Order> orderBy = {WCDB::Order(WCDB::Expr(WCDB::Column("_istop")), WCDB::OrderTerm::DESC), WCDB::Order(WCDB::Expr(WCDB::Column("_timestamp")), WCDB::OrderTerm::DESC)};
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(CONVERSATION_TABLE_NAME, {"_conv_type", "_conv_target", "_conv_line", "_draft",  "_istop", "_timestamp"}, error, &where, &orderBy);
            
            std::list<TConversation> convs;
          while(statementHandle->step()) {
                TConversation conv;
                conv.conversationType = db->getIntValue(statementHandle, 0);
                conv.target = db->getStringValue(statementHandle, 1);
                conv.line = db->getIntValue(statementHandle, 2);
                conv.draft = db->getStringValue(statementHandle, 3);
                conv.isTop = db->getIntValue(statementHandle, 4);
                conv.timestamp = db->getBigIntValue(statementHandle, 5);
                
                std::list<TMessage> lastMessages = GetMessages(conv.conversationType, conv.target, conv.line, true, 1, LONG_MAX);
                if (lastMessages.size() > 0) {
                    conv.lastMessage = *lastMessages.begin();
                }
              
              conv.unreadCount = GetUnreadCount(conv.conversationType, conv.target, conv.line);
              
                convs.push_back(conv);
            }
            return convs;
        }
        bool MessageDB::RemoveConversation(int conversationType, const std::string &target, int line, bool clearMessage) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            std::list<const WCDB::Expr> exprsType;
            
            
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line));
            
            WCDB::RecyclableStatement statementHandle = db->GetDeleteStatement(CONVERSATION_TABLE_NAME, &where);
            
            if (db->ExecuteDelete(statementHandle) > 0) {
                if (clearMessage) {
                    statementHandle = db->GetDeleteStatement(MESSAGE_TABLE_NAME, &where);
                    db->ExecuteDelete(statementHandle);
                }
                
                return true;
            }
            
            return false;
        }
        
        TConversation MessageDB::GetConversation(int conversationType, const std::string &target, int line) {
            DB *db = DB::Instance();
            WCDB::Error error;
            TConversation conv;
            if (!db->isOpened()) {
              return conv;
            }
          
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line);
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(CONVERSATION_TABLE_NAME, {"_draft",  "_istop", "_timestamp"}, error, &where);
            
            conv.target = target;
            conv.conversationType = conversationType;
            if (statementHandle->step()) {
                conv.draft = db->getStringValue(statementHandle, 0);
                conv.isTop = db->getIntValue(statementHandle, 1);
                conv.timestamp = db->getBigIntValue(statementHandle, 2);
                
                std::list<TMessage> lastMessages = GetMessages(conversationType, target, line, true, 1, LONG_MAX);
                if (lastMessages.size() > 0) {
                    conv.lastMessage = *lastMessages.begin();
                }
            }
            
            conv.unreadCount = GetUnreadCount(conversationType, target, line);
            
            return conv;
        }
        int MessageDB::GetUnreadCount(int conversationType, const std::string &target, int line) {
            DB *db = DB::Instance();
            WCDB::Error error;

            if (!db->isOpened()) {
                return 0;
            }
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line) && (WCDB::Expr(WCDB::Column("_status")) == Message_Status_Unread);
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(MESSAGE_TABLE_NAME, {"count(*)"}, error, &where);
            
            if (statementHandle->step()) {
                return db->getIntValue(statementHandle, 0);
            }
            
            return 0;
        }
        
        int MessageDB::GetUnreadCount(const std::list<int> &conversationTypes, const std::list<int> lines) {
            DB *db = DB::Instance();
            WCDB::Error error;
            
            if (!db->isOpened()) {
                return 0;
            }
            
            std::list<const WCDB::Expr> types;
            for (std::list<int>::const_iterator it = conversationTypes.begin(); it != conversationTypes.end(); it++) {
                types.insert(types.end(), WCDB::Expr(*it));
            }
            
            std::list<const WCDB::Expr> ls;
            for (std::list<int>::const_iterator it = lines.begin(); it != lines.end(); it++) {
                ls.insert(ls.end(), WCDB::Expr(*it));
            }
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")).in(types)) && (WCDB::Expr(WCDB::Column("_conv_line")).in(ls)) && (WCDB::Expr(WCDB::Column("_status")) == Message_Status_Unread);
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(MESSAGE_TABLE_NAME, {"count(*)"}, error, &where);
            
            if (statementHandle->step()) {
                return db->getIntValue(statementHandle, 0);
            }
            
            return 0;
        }
        
        std::list<TMessage> MessageDB::GetMessages(int conversationType, const std::string &target, int line, bool old, int count, long startPoint) {
            DB *db = DB::Instance();
            WCDB::Error error;
          if (!db->isOpened()) {
            return std::list<TMessage>();
          }
          
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line);
            if (old) {
              if (startPoint == 0) {
                startPoint = LONG_MAX;
              }
                where = where && WCDB::Expr(WCDB::Column("_id")) < startPoint;
            } else {
                where = where && WCDB::Expr(WCDB::Column("_id")) > startPoint;
            }
            
          std::list<const WCDB::Order> orderBy = {WCDB::Order(WCDB::Expr(WCDB::Column("_timestamp")), old ? WCDB::OrderTerm::DESC : WCDB::OrderTerm::ASC)};
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(MESSAGE_TABLE_NAME,
                {
                    "_id",
                    "_conv_type",
                    "_conv_target",
                    "_conv_line",
                    "_from",
                    "_cont_type",
                    "_cont_searchable",
                    "_cont_push",
                    "_cont",
                    "_cont_data",
                    "_cont_local",
                    "_cont_media_type",
                    "_cont_remote_media_url",
                    "_cont_local_media_path",
                    "_direction",
                    "_status",
                    "_uid",
                    "_timestamp"}, error, &where, &orderBy, count);
            
            std::list<TMessage> result;
            
            while (statementHandle->step()) {
                TMessage msg;
                msg.messageId = db->getIntValue(statementHandle, 0);
                msg.conversationType = db->getIntValue(statementHandle, 1);
                msg.target = db->getStringValue(statementHandle, 2);
                msg.line = db->getIntValue(statementHandle, 3);
                msg.from = db->getStringValue(statementHandle, 4);
                
                msg.content.type = db->getIntValue(statementHandle, 5);
                msg.content.searchableContent = db->getStringValue(statementHandle, 6);
                msg.content.pushContent = db->getStringValue(statementHandle, 7);
                msg.content.content = db->getStringValue(statementHandle, 8);
                int size = 0;
                const void *p = db->getBlobValue(statementHandle, 9, size);
                msg.content.binaryContent = std::string((const char *)p, size);
                msg.content.localContent = db->getStringValue(statementHandle, 10);
                msg.content.mediaType = db->getIntValue(statementHandle, 11);
                msg.content.remoteMediaUrl = db->getStringValue(statementHandle, 12);
                msg.content.localMediaPath = db->getStringValue(statementHandle, 13);
                
                msg.direction = db->getIntValue(statementHandle, 14);
                msg.status = (MessageStatus)db->getIntValue(statementHandle, 15);
                msg.messageUid = db->getBigIntValue(statementHandle, 16);
                msg.timestamp = db->getBigIntValue(statementHandle, 17);
                
                result.push_back(msg);
            }
            if (old) {
                result.reverse();
            }
            
            return result;
        }
        bool MessageDB::updateMessageStatus(long messageId, MessageStatus status) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_id")) == messageId);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_status"}, &where);
            db->Bind(updateStatementHandle, status, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        bool MessageDB::updateMessageRemoteMediaUrl(long messageId, const std::string &remoteMediaUrl) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_id")) == messageId);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_cont_remote_media_url"}, &where);
            db->Bind(updateStatementHandle, remoteMediaUrl, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        
        bool MessageDB::updateMessageLocalMediaPath(long messageId, const std::string &localMediaPath) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_id")) == messageId);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_cont_local_media_path"}, &where);
            db->Bind(updateStatementHandle, localMediaPath, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }

        bool MessageDB::ClearUnreadStatus(int conversationType, const std::string &target, int line) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target) && (WCDB::Expr(WCDB::Column("_conv_line")) == line) && (WCDB::Expr(WCDB::Column("_status")) == Message_Status_Unread);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_status"}, &where);
            db->Bind(updateStatementHandle, Message_Status_Readed, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        
        bool MessageDB::ClearAllUnreadStatus() {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_status")) == Message_Status_Unread);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_status"}, &where);
            db->Bind(updateStatementHandle, Message_Status_Readed, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        
        bool MessageDB::FailSendingMessages() {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_status")) == Message_Status_Sending);
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement(MESSAGE_TABLE_NAME, {"_status"}, &where);
            db->Bind(updateStatementHandle, Message_Status_Send_Failure, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            return false;
        }
        
        class TGetGroupInfoCallback : public GetGroupInfoCallback {
            void onSuccess(const std::list<const mars::stn::TGroupInfo> &groupInfoList) {
                for (std::list<const TGroupInfo>::const_iterator it = groupInfoList.begin(); it != groupInfoList.end(); it++) {
                    MessageDB::Instance()->InsertGroupInfo(*it);
                }
                if(StnCallBack::Instance()->m_getGroupInfoCB) {
                    StnCallBack::Instance()->m_getGroupInfoCB->onSuccess(groupInfoList);
                }
                delete this;
            }
            void onFalure(int errorCode) {
                if(StnCallBack::Instance()->m_getGroupInfoCB) {
                    StnCallBack::Instance()->m_getGroupInfoCB->onFalure(errorCode);
                }
                delete this;
            }
            virtual ~TGetGroupInfoCallback() {}
        };
        
        TGroupInfo MessageDB::GetGroupInfo(const std::string &groupId, bool refresh) {
            DB *db = DB::Instance();
            WCDB::Error error;
            TGroupInfo gi;
            if (!db->isOpened()) {
                return gi;
            }
           
            
            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_uid")) == groupId);
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(GROUP_TABLE_NAME, {"_name",  "_portrait", "_owner", "_type", "_extra", "_update_dt"}, error, &where);
            
            gi.target = groupId;
            
            if (statementHandle->step()) {
                gi.name = db->getStringValue(statementHandle, 0);
                gi.portrait = db->getStringValue(statementHandle, 1);
                gi.owner = db->getStringValue(statementHandle, 2);
                gi.type = db->getIntValue(statementHandle, 3);
                gi.extra = db->getStringValue(statementHandle, 4);
                gi.updateDt = db->getBigIntValue(statementHandle, 5);
                
            } else {
                gi.target = "";//empty
                gi.updateDt = 0;
            }
            
            if (refresh || gi.target.empty()) {
                getGroupInfo({std::pair<std::string, int64_t>(groupId, gi.updateDt)}, new TGetGroupInfoCallback());
            }
            return gi;
        }
        
        long MessageDB::InsertGroupInfo(const TGroupInfo &groupInfo) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
                return -1;
            }
            
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(GROUP_TABLE_NAME, {"_uid", "_name", "_portrait", "_owner", "_type", "_extra", "_update_dt"}, true);
            db->Bind(statementHandle, groupInfo.target, 1);
            db->Bind(statementHandle, groupInfo.name, 2);
            db->Bind(statementHandle, groupInfo.portrait, 3);
            
            db->Bind(statementHandle, groupInfo.owner, 4);
            db->Bind(statementHandle, groupInfo.type, 5);
            db->Bind(statementHandle, groupInfo.extra, 6);
            db->Bind(statementHandle, groupInfo.updateDt, 7);
            long ret = 0;
            db->ExecuteInsert(statementHandle, &ret);
            return ret;

        }
        
        TUserInfo MessageDB::getUserInfo(const std::string &userId, bool refresh) {
            DB *db = DB::Instance();
            WCDB::Error error;
            TUserInfo ui;
            if (!db->isOpened()) {
                return ui;
            }

            WCDB::Expr where = (WCDB::Expr(WCDB::Column("_uid")) == userId);
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement(USER_TABLE_NAME, {"_uid",  "_name", "_display_name", "_portrait", "_mobile", "_email", "_address", "_company", "_social", "_extra", "_update_dt"}, error, &where);
            
            std::list<std::pair<std::string, int64_t>> refreshReqList;
            
            if (statementHandle->step()) {
                ui.uid = db->getStringValue(statementHandle, 0);
                ui.name = db->getStringValue(statementHandle, 1);
                ui.displayName = db->getStringValue(statementHandle, 2);
                ui.portrait = db->getStringValue(statementHandle, 3);
                ui.mobile = db->getStringValue(statementHandle, 4);
                ui.email = db->getStringValue(statementHandle, 5);
                ui.address = db->getStringValue(statementHandle, 6);
                ui.company = db->getStringValue(statementHandle, 7);
                ui.social = db->getStringValue(statementHandle, 8);
                ui.extra = db->getStringValue(statementHandle, 9);
                ui.updateDt = db->getBigIntValue(statementHandle, 10);
            } else {
                ui.updateDt = 0;
            }
            
            if (refresh || ui.uid.empty()) {
                reloadUserInfoFromRemote({std::pair<std::string, int64_t>(userId, ui.updateDt)});
            }
            return ui;
        }
        
        long MessageDB::InsertUserInfoOrReplace(const TUserInfo &userInfo) {
            DB *db = DB::Instance();
            WCDB::Error error;
            if (!db->isOpened()) {
                return 0L;
            }
            
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement(USER_TABLE_NAME, {"_uid",  "_name", "_display_name", "_portrait", "_mobile", "_email", "_address", "_company", "_social", "_extra", "_update_dt"}, true);
            db->Bind(statementHandle, userInfo.uid, 1);
            db->Bind(statementHandle, userInfo.name, 2);
            db->Bind(statementHandle, userInfo.displayName, 3);
            db->Bind(statementHandle, userInfo.portrait, 4);
            
            db->Bind(statementHandle, userInfo.mobile, 5);
            db->Bind(statementHandle, userInfo.email, 6);
            db->Bind(statementHandle, userInfo.address, 7);
            db->Bind(statementHandle, userInfo.company, 8);
            db->Bind(statementHandle, userInfo.social, 9);

            db->Bind(statementHandle, userInfo.extra, 10);
            db->Bind(statementHandle, userInfo.updateDt, 11);
            
            long ret = 0;
            db->ExecuteInsert(statementHandle, &ret);
            return ret;
        }
    }
}
