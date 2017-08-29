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

namespace mars {
    namespace stn {
        
        static const std::string DB_NAME = "data";
        static const std::string VERSION_TABLE_NAME = "version";
        static const std::string VERSION_COLUMN_VERSION = "_version";
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
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement("message", {"_conv_type","_conv_target","_from","_cont_type","_cont_searchable","_cont_push","_cont_data","_direction","_status","_uid","_timestamp"});
            db->Bind(statementHandle, msg.conversationType, 1);
            db->Bind(statementHandle, msg.target, 2);
            db->Bind(statementHandle, msg.from, 3);
            
            db->Bind(statementHandle, msg.content.type, 4);
            db->Bind(statementHandle, msg.content.searchableContent, 5);
            db->Bind(statementHandle, msg.content.pushContent, 6);
            
            db->Bind(statementHandle, (const void *)msg.content.data, (int)msg.content.dataLen, 7);
            db->Bind(statementHandle, msg.direction, 8);
            db->Bind(statementHandle, msg.status, 9);
            
            db->Bind(statementHandle, msg.messageUid, 10);
            db->Bind(statementHandle, msg.timestamp, 11);
            
            db->ExecuteInsert(statementHandle, &(msg.messageId));
            return msg.messageId;
        }
        
        bool MessageDB::UpdateMessageTimeline(int64_t timeline) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::RecyclableStatement statementHandle = db->GetUpdateStatement("timeline", {"_head"});
            db->Bind(statementHandle, timeline, 1);
            return db->ExecuteUpdate(statementHandle) > 0;
        }
        
        int64_t MessageDB::GetMessageTimeline() {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return -1;
            }
          
            WCDB::Error error;
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement("timeline", {"_head"}, error);
            if (statementHandle->step()) {
                int64_t head = db->getBigIntValue(statementHandle, 0);
                return head;
            }
            
            return 0;
        }

        bool MessageDB::updateConversationTimestamp(int conversationType, const std::string &target, int64_t timestamp) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
          
            WCDB::Error error;
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement("conversation", {"_timestamp"}, &where);
            db->Bind(updateStatementHandle, timestamp, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement("conversation", {"_conv_type", "_conv_target", "_timestamp"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, timestamp, 3);
            return db->ExecuteInsert(statementHandle);
        }
        
        bool MessageDB::updateConversationIsTop(int conversationType, const std::string &target, bool istop) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement("conversation", {"_istop"}, &where);
            db->Bind(updateStatementHandle, istop, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement("conversation", {"_conv_type", "_conv_target", "_istop"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, istop, 3);
            return db->ExecuteInsert(statementHandle);
        }
        
        bool MessageDB::updateConversationDraft(int conversationType, const std::string &target, const std::string &draft) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return false;
            }
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr(WCDB::Column("_conv_type")) == conversationType) && (WCDB::Expr(WCDB::Column("_conv_target")) == target));
            WCDB::RecyclableStatement updateStatementHandle = db->GetUpdateStatement("conversation", {"_draft"}, &where);
            db->Bind(updateStatementHandle, draft, 1);
            int count = db->ExecuteUpdate(updateStatementHandle);
            
            if (count > 0) {
                return true;
            }
            
            
            WCDB::RecyclableStatement statementHandle = db->GetInsertStatement("conversation", {"_conv_type", "_conv_target", "_draft"}, true);
            db->Bind(statementHandle, conversationType, 1);
            db->Bind(statementHandle, target, 2);
            db->Bind(statementHandle, draft, 3);
            return db->ExecuteInsert(statementHandle);
        }
        std::list<TConversation> MessageDB::GetConversationList(const std::list<int> &conversationTypes) {
            DB *db = DB::Instance();
            if (!db->isOpened()) {
              return std::list<TConversation>();
            }
            WCDB::Error error;
          
            std::list<const WCDB::Expr> exprs;
            for (std::list<int>::const_iterator it = conversationTypes.begin(); it != conversationTypes.end(); it++) {
                exprs.push_back(WCDB::Expr(*it));
            }
            WCDB::Expr where = WCDB::Expr(WCDB::Column("_conv_type")).in(exprs);
            std::list<const WCDB::Order> orderBy = {WCDB::Order(WCDB::Expr(WCDB::Column("_timestamp")), WCDB::OrderTerm::DESC)};
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement("conversation", {"_conv_type", "_conv_target", "_draft",  "_istop", "_timestamp"}, error, &where, &orderBy);
            
            std::list<TConversation> convs;
            if (statementHandle->step()) {
                TConversation conv;
                conv.target = db->getStringValue(statementHandle, 0);
                conv.conversationType = db->getIntValue(statementHandle, 1);
                
                conv.draft = db->getStringValue(statementHandle, 2);
                conv.isTop = db->getIntValue(statementHandle, 3);
                conv.timestamp = db->getBigIntValue(statementHandle, 3);
                
                std::list<TMessage> lastMessages = GetMessages(conv.conversationType, conv.target, true, 1, LONG_LONG_MAX);
                if (lastMessages.size() > 0) {
                    conv.lastMessage = *lastMessages.begin();
                }
                convs.push_back(conv);
            }
            return convs;
        }
        TConversation MessageDB::GetConversation(int conversationType, const std::string &target) {
            DB *db = DB::Instance();
            WCDB::Error error;
            TConversation conv;
            if (!db->isOpened()) {
              return conv;
            }
          
            WCDB::Expr where = WCDB::Expr(WCDB::Column("_conv_type")) == conversationType && WCDB::Expr(WCDB::Column("_conv_target")) == target;
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement("conversation", {"_draft",  "_istop", "_timestamp"}, error, &where);
            
            conv.target = target;
            conv.conversationType = conversationType;
            if (statementHandle->step()) {
                conv.draft = db->getStringValue(statementHandle, 0);
                conv.isTop = db->getIntValue(statementHandle, 1);
                conv.timestamp = db->getBigIntValue(statementHandle, 2);
                
                std::list<TMessage> lastMessages = GetMessages(conversationType, target, true, 1, LONG_LONG_MAX);
                if (lastMessages.size() > 0) {
                    conv.lastMessage = *lastMessages.begin();
                }
            }
            return conv;
        }
        std::list<TMessage> MessageDB::GetMessages(int conversationType, const std::string &target, bool desc, int count, int64_t startPoint) {
            DB *db = DB::Instance();
            WCDB::Error error;
          if (!db->isOpened()) {
            return std::list<TMessage>();
          }
          
            WCDB::Expr where = WCDB::Expr(WCDB::Column("_conv_type")) == conversationType && WCDB::Expr(WCDB::Column("_conv_target")) == target;
            if (desc) {
                where = where && WCDB::Expr(WCDB::Column("_timestamp")) < startPoint;
            } else {
                where = where && WCDB::Expr(WCDB::Column("_timestamp")) > startPoint;
            }
            
            std::list<const WCDB::Order> orderBy = {WCDB::Order(WCDB::Expr(WCDB::Column("_timestamp")), WCDB::OrderTerm::DESC)};
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement("message",
                {
                    "_id",
                    "_conv_type",
                    "_conv_target",
                    "_from",
                    "_cont_type",
                    "_cont_searchable",
                    "_cont_push",
                    "_cont_data",
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
                msg.from = db->getStringValue(statementHandle, 3);
                msg.content.type = db->getIntValue(statementHandle, 4);
                msg.content.searchableContent = db->getStringValue(statementHandle, 5);
                msg.content.pushContent = db->getStringValue(statementHandle, 6);
                int size;
                const void *p = db->getBlobValue(statementHandle, 7, size);
                msg.content.dataLen = size;
                msg.content.data = new unsigned char[msg.content.dataLen + 1];
                memcpy(msg.content.data, p, msg.content.dataLen);
                msg.direction = db->getIntValue(statementHandle, 8);
                msg.status = (MessageStatus)db->getIntValue(statementHandle, 9);
                msg.messageUid = db->getBigIntValue(statementHandle, 10);
                msg.timestamp = db->getBigIntValue(statementHandle, 11);
                
                result.push_back(msg);
            }
            return result;
        }
    }
}
