//
//  DB.cpp
//  stn
//
//  Created by Tao Li on 2017/8/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#include "DB.hpp"

#include "mars/app/app.h"

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

        DB::DB() {
            
        }
        
        DB::~DB() {
            
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
            if (statementHandle->step()) {
                return statementHandle;
            }
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
        
        bool DB::ExecuteInsert(WCDB::RecyclableStatement statementHandle) {
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
            return statementHandle->getValue<ColumnType::Integer32>(index);
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
            int version = getIntValue(statementHandle, 0);
            if (version < 2) {
                version++;
            }
        }
        
        bool DB::CreateDBVersion1() {
            WCDB::Error error;
            
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
