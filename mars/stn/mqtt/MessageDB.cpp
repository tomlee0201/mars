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
        
        
//        std::list<const WCDB::ColumnDef> messageDefList = {
//            WCDB::ColumnDef(Column("_id"), ColumnType::Integer32).makePrimary(OrderTerm::NotSet, true),
//            WCDB::ColumnDef(Column("_conv_type"), ColumnType::Integer32).makeNotNull(),
//            WCDB::ColumnDef(Column("_conv_target"), ColumnType::Text).makeNotNull(),
//            WCDB::ColumnDef(Column("_from"), ColumnType::Text).makeNotNull(),
//            
//            WCDB::ColumnDef(Column("_cont_type"), ColumnType::Integer32).makeNotNull(),
//            WCDB::ColumnDef(Column("_cont_searchable"), ColumnType::Text).makeDefault(NULL),
//            WCDB::ColumnDef(Column("_cont_push"), ColumnType::Text).makeDefault(NULL),
//            WCDB::ColumnDef(Column("_cont_data"), ColumnType::BLOB).makeDefault(NULL),
//            
//            WCDB::ColumnDef(Column("_direction"), ColumnType::Integer32).makeDefault(0),
//            WCDB::ColumnDef(Column("_status"), ColumnType::Integer32).makeDefault(0),
//            WCDB::ColumnDef(Column("_uid"), ColumnType::Integer64).makeDefault(0),
//            WCDB::ColumnDef(Column("_timestamp"), ColumnType::Integer64).makeDefault(0)
//        };
        
        long MessageDB::InsertMessage(TMessage &msg) {
            DB *db = DB::Instance();
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
            WCDB::RecyclableStatement statementHandle = db->GetUpdateStatement("timeline", {"_head"});
            db->Bind(statementHandle, timeline, 1);
            return db->ExecuteUpdate(statementHandle) > 0;
        }
        
        int64_t MessageDB::GetMessageTimeline() {
            DB *db = DB::Instance();
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
            WCDB::Error error;
            
            WCDB::Expr where = ((WCDB::Expr("_conv_type") == conversationType) && (WCDB::Expr("_conv_target") == target));
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
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr("_conv_type") == conversationType) && (WCDB::Expr("_conv_target") == target));
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
            WCDB::Error error;
            
            
            WCDB::Expr where = ((WCDB::Expr("_conv_type") == conversationType) && (WCDB::Expr("_conv_target") == target));
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
        TConversation MessageDB::GetConversation(int conversationType, const std::string &target) {
            DB *db = DB::Instance();
            WCDB::Error error;
            TConversation conv;
            ;
            WCDB::Expr where = WCDB::Expr("_conv_type") == conversationType ;//&& WCDB::Expr("_conv_target") == target;
            WCDB::RecyclableStatement statementHandle = db->GetSelectStatement("conversation", {"_draft",  "_istop", "_timestamp"}, error, &where);
            
            conv.target = target;
            conv.conversationType = conversationType;
            if (statementHandle->step()) {
                conv.draft = db->getStringValue(statementHandle, 0);
                conv.isTop = db->getIntValue(statementHandle, 1);
                conv.timestamp = db->getBigIntValue(statementHandle, 2);
            }
            return conv;
        }
    }
}
