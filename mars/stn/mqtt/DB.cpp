//
//  DB.cpp
//  stn
//
//  Created by Tao Li on 2017/8/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#include "DB.hpp"

#include "mars/app/app.h"
#include <WCDB/statement_create_index.hpp>

using namespace WCDB;

namespace mars {
    namespace stn {
        
        static const std::string DB_NAME = "data";
        static const std::string VERSION_TABLE_NAME = "version";
        static const std::string VERSION_COLUMN_VERSION = "_version";
        DB* DB::instance_ = NULL;
        
        DB* DB::Instance() {
            if(instance_ == NULL) {
                instance_ = new DB();
            }
            
            return instance_;
        }

        DB::DB() : opened(false) {
            
        }
        
        DB::~DB() {
            
        }
      
      bool DB::isOpened() {
        return opened;
      }
      
        void DB::Open() {
            std::string dbPath = app::GetAppFilePath() + "/" + DB_NAME;
            _database = new WCDB::Database(dbPath.c_str());
            
            std::function<void(void)> callback = nullptr;
            
            callback = []() {
                //WCDB::Error unixError;
                //DB::Instance()->_database->removeFiles(unixError);
            };
            
            _database->close(callback);
          opened = true;
        }
        
        WCDB::RecyclableStatement DB::GetSelectStatement(const std::string &tableName, const std::list<const std::string> &columns, WCDB::Error &error, const WCDB::Expr *where, const std::list<const WCDB::Order> *orderBy, int limit, int offset) {
            WCDB::StatementSelect statement;
            std::list<const WCDB::ColumnResult> selectList;
            for (std::list<const std::string>::const_iterator it = columns.begin(); it != columns.end(); ++it) {
                WCDB::ColumnResult column((WCDB::Expr(WCDB::Column(*it))));
                selectList.push_back(column);
            }
            statement.select(selectList).from(tableName);
            if (where != NULL) {
                statement.where(*where);
            }
            if (orderBy) {
                statement.orderBy(*orderBy);
            }
            if (limit > 0) {
                statement.limit(Expr(limit));
            }
            if (offset > 0) {
                statement.offset(Expr(offset));
            }
            
            WCDB::RecyclableStatement statementHandle = _database->prepare(statement, error);
            return statementHandle;
        }
        
        WCDB::RecyclableStatement DB::GetInsertStatement(const std::string &table, const std::list<const std::string> &columns, bool replace) {
            std::list<const WCDB::Column> columnList;
            for (std::list<const std::string>::const_iterator it = columns.begin(); it != columns.end(); ++it) {
                
                columnList.push_back(WCDB::Column(*it));
            }

            Error error;
            
            WCDB::StatementInsert _statement = WCDB::StatementInsert().insert(table,
                                                                              columnList,
                                                                              replace ? WCDB::Conflict::Replace : WCDB::Conflict::NotSet)
            .values(WCDB::ExprList(columnList.size(), WCDB::Expr::BindParameter));
            
            WCDB::RecyclableStatement statementHandle = _database->prepare(_statement, error);
            return statementHandle;
            
        }
        
        bool DB::ExecuteInsert(WCDB::RecyclableStatement statementHandle, long *rowId) {
            Error error;
            statementHandle->step();
            if (!statementHandle->isOK()) {
                error = statementHandle->getError();
                return false;
            }
            
            statementHandle->resetBinding();
            if (!statementHandle->isOK()) {
                error = statementHandle->getError();
                return false;
            }
            if (rowId != NULL) {
                *rowId = statementHandle->getLastInsertedRowID();
            }
            
            
            return error.isOK();
        }
        
        WCDB::RecyclableStatement DB::GetUpdateStatement(const std::string &table, const std::list<const std::string> &columns, const WCDB::Expr *where) {
            std::list<const std::pair<const Column, const Expr>> columnList;
            for (std::list<const std::string>::const_iterator it = columns.begin(); it != columns.end(); ++it) {
                
                columnList.push_back({WCDB::Column(*it), Expr::BindParameter});
            }
            
            Error error;
            WCDB::StatementUpdate _statement;
            _statement.update(table);
            _statement.set(columnList);
            if (where) {
                _statement.where(*where);
            }
            WCDB::RecyclableStatement statementHandle = _database->prepare(_statement, error);
            return statementHandle;
        }
        
        int DB::ExecuteUpdate(WCDB::RecyclableStatement &statementHandle) {
            statementHandle->step();
            
            int changes = statementHandle->getChanges();
            return changes;
        }
        void DB::Bind(WCDB::RecyclableStatement &statementHandle, float value, int index) {
            statementHandle->bind<ColumnType::Float>(value, index);
        }
        void DB::Bind(WCDB::RecyclableStatement &statementHandle, int value, int index) {
            statementHandle->bind<ColumnType::Integer32>(value, index);
        }
        void DB::Bind(WCDB::RecyclableStatement &statementHandle, int64_t value, int index) {
            statementHandle->bind<ColumnType::Integer64>(value, index);
        }
        void DB::Bind(WCDB::RecyclableStatement &statementHandle, const std::string &value, int index) {
            statementHandle->bind<ColumnType::Text>(value.c_str(), index);
        }
        void DB::Bind(WCDB::RecyclableStatement &statementHandle, const void *value, int size, int index) {
            statementHandle->bind<ColumnType::BLOB>(value, size, index);
        }
        
        float DB::getFloatValue(const WCDB::RecyclableStatement &statementHandle, int index) {
            return statementHandle->getValue<ColumnType::Float>(index);
        }
        
        int DB::getIntValue(const WCDB::RecyclableStatement &statementHandle, int index) {
            return statementHandle->getValue<ColumnType::Integer32>(index);
        }

        int64_t DB::getBigIntValue(const WCDB::RecyclableStatement &statementHandle, int index) {
            return statementHandle->getValue<ColumnType::Integer64>(index);
        }

        std::string DB::getStringValue(const WCDB::RecyclableStatement &statementHandle, int index) {
            return statementHandle->getValue<ColumnType::Text>(index);
        }

        const void* DB::getBlobValue(const WCDB::RecyclableStatement &statementHandle, int index, int &size) {
            return statementHandle->getValue<ColumnType::BLOB>(index, size);
        }

        void DB::Upgrade() {
            WCDB::Error error;
            if(!_database->isTableExists(VERSION_TABLE_NAME, error)) {
                CreateDBVersion1();
            }

            
            WCDB::RecyclableStatement statementHandle = GetSelectStatement(VERSION_TABLE_NAME, {VERSION_COLUMN_VERSION}, error);
            if (statementHandle->step()) {
                int version = getIntValue(statementHandle, 0);
                if (version < 2) {
                    version++;
                }
            }
        }
        
//        TMessage() : conversationType(0) {}
//        int conversationType;
//        std::string target;
//        std::string from;
//        TMessageContent content;
//        long messageId;
//        int direction;
//        MessageStatus status;
//        int64_t messageUid;
//        int64_t timestamp;

        
//        int type;
//        std::string searchableContent;
//        std::string pushContent;
//        unsigned char *data;
//        size_t dataLen;
        
        
        bool DB::CreateDBVersion1() {
            WCDB::Error error;
            
            //create message table
            std::list<const WCDB::ColumnDef> messageDefList = {
                WCDB::ColumnDef(Column("_id"), ColumnType::Integer32).makePrimary(OrderTerm::NotSet, true),
                WCDB::ColumnDef(Column("_conv_type"), ColumnType::Integer32).makeNotNull(),
                WCDB::ColumnDef(Column("_conv_target"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_conv_line"), ColumnType::Integer32).makeNotNull(),
                WCDB::ColumnDef(Column("_from"), ColumnType::Text).makeNotNull(),
                
                WCDB::ColumnDef(Column("_cont_type"), ColumnType::Integer32).makeNotNull(),
                WCDB::ColumnDef(Column("_cont_searchable"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_push"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_data"), ColumnType::BLOB).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_local"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_media_type"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_remote_media_url"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_cont_local_media_path"), ColumnType::Text).makeDefault(NULL),
                
                WCDB::ColumnDef(Column("_direction"), ColumnType::Integer32).makeDefault(0),
                WCDB::ColumnDef(Column("_status"), ColumnType::Integer32).makeDefault(0),
                WCDB::ColumnDef(Column("_uid"), ColumnType::Integer64).makeDefault(0),
                WCDB::ColumnDef(Column("_timestamp"), ColumnType::Integer64).makeDefault(0)
            };
            _database->exec(WCDB::StatementCreateTable().create("message", messageDefList, true),
                            error);

            
            //create user table
            std::list<const WCDB::ColumnDef> userDefList = {
                WCDB::ColumnDef(Column("_id"), ColumnType::Integer32).makePrimary(OrderTerm::NotSet, true),
                WCDB::ColumnDef(Column("_uid"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_name"), ColumnType::Text),
                WCDB::ColumnDef(Column("_display_name"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_portrait"), ColumnType::Text),
                WCDB::ColumnDef(Column("_mobile"), ColumnType::Text),
                WCDB::ColumnDef(Column("_email"), ColumnType::Text),
                WCDB::ColumnDef(Column("_address"), ColumnType::Text),
                WCDB::ColumnDef(Column("_company"), ColumnType::Text),
                WCDB::ColumnDef(Column("_social"), ColumnType::Text),
                WCDB::ColumnDef(Column("_extra"), ColumnType::Text),
                WCDB::ColumnDef(Column("_update_dt"), ColumnType::Integer64).makeDefault(0)
            };
            _database->exec(WCDB::StatementCreateTable().create("user", userDefList, true),
                            error);
            
            
            //create group table
            std::list<const WCDB::ColumnDef> groupDefList = {
                WCDB::ColumnDef(Column("_id"), ColumnType::Integer32).makePrimary(OrderTerm::NotSet, true),
                WCDB::ColumnDef(Column("_uid"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_line"), ColumnType::Integer32),
                WCDB::ColumnDef(Column("_name"), ColumnType::Text),
                WCDB::ColumnDef(Column("_portrait"), ColumnType::Text),
                WCDB::ColumnDef(Column("_owner"), ColumnType::Text),
                WCDB::ColumnDef(Column("_type"), ColumnType::Integer32),
                WCDB::ColumnDef(Column("_extra"), ColumnType::Text),
                WCDB::ColumnDef(Column("_update_dt"), ColumnType::Integer64).makeDefault(0)
            };
            _database->exec(WCDB::StatementCreateTable().create("group", groupDefList, true),
                            error);
            
            
            //create group member table
            std::list<const WCDB::ColumnDef> groupMemberDefList = {
                WCDB::ColumnDef(Column("_id"), ColumnType::Integer32).makePrimary(OrderTerm::NotSet, true),
                WCDB::ColumnDef(Column("_gid"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_line"), ColumnType::Integer32),
                WCDB::ColumnDef(Column("_mid"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_type"), ColumnType::Text),
                WCDB::ColumnDef(Column("_update_dt"), ColumnType::Integer64).makeDefault(0)
            };
            _database->exec(WCDB::StatementCreateTable().create("groupMember", groupMemberDefList, true),
                            error);

            
            //create timeline table
            std::list<const WCDB::ColumnDef> timelineDefList = {
                WCDB::ColumnDef(Column("_head"), ColumnType::Integer64).makeDefault(0),
            };
            _database->exec(WCDB::StatementCreateTable().create("timeline", timelineDefList, true),
                            error);
            //set timeline to 0;
            WCDB::RecyclableStatement statementHandleTimeline = GetInsertStatement("timeline", {"_head"});
            Bind(statementHandleTimeline, 0, 1);
            ExecuteInsert(statementHandleTimeline);

            //create conversation table
            std::list<const WCDB::ColumnDef> convDefList = {
                WCDB::ColumnDef(Column("_conv_type"), ColumnType::Integer32).makeNotNull(),
                WCDB::ColumnDef(Column("_conv_target"), ColumnType::Text).makeNotNull(),
                WCDB::ColumnDef(Column("_conv_line"), ColumnType::Integer32).makeNotNull(),
                WCDB::ColumnDef(Column("_draft"), ColumnType::Text).makeDefault(NULL),
                WCDB::ColumnDef(Column("_istop"), ColumnType::Integer32).makeDefault(0),
                WCDB::ColumnDef(Column("_timestamp"), ColumnType::Integer64).makeDefault(0)
            };
            _database->exec(WCDB::StatementCreateTable().create("conversation", convDefList, true),
                            error);
            
            //create conversation index table
            std::list<const WCDB::ColumnIndex> convIndexList = {
                WCDB::ColumnIndex(Column("_conv_type"),OrderTerm::NotSet),
                WCDB::ColumnIndex(Column("_conv_target"),OrderTerm::NotSet),
                WCDB::ColumnIndex(Column("_conv_line"),OrderTerm::NotSet)
            };
            _database->exec(WCDB::StatementCreateIndex()
                        .create("conv_index", true, true)
                        .on("conversation", convIndexList),
                        error);
            
            
            
            //create version table
            WCDB::ColumnDef columnDef(Column(VERSION_COLUMN_VERSION), ColumnType::Integer32);
            columnDef.makePrimary(OrderTerm::NotSet, false, Conflict::Replace);
            
            std::list<const WCDB::ColumnDef> defList = {columnDef};
            _database->exec(WCDB::StatementCreateTable().create(VERSION_TABLE_NAME, defList, true),
                            error);
            
            //and set version to 1
            WCDB::RecyclableStatement statementHandle = GetInsertStatement(VERSION_TABLE_NAME, {VERSION_COLUMN_VERSION});
            Bind(statementHandle, 1, 1);
            ExecuteInsert(statementHandle);
            return true;
        }

    }
}
