//
//  DB.hpp
//  stn
//
//  Created by Tao Li on 2017/8/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef DB_hpp
#define DB_hpp

#include <stdio.h>
#include "mars/app/app.h"
#include "mars/app/app_logic.h"
#include <WCDB/core_base.hpp>
#include <WCDB/database.hpp>
#include <WCDB/statement_create_table.hpp>
#include <WCDB/declare.hpp>
#include <WCDB/expr.hpp>
#include <WCDB/order.hpp>
#include <WCDB/column_type.hpp>

namespace WCDB {
class Database;
}
namespace mars {
    namespace stn {
        
        extern const std::string VERSION_TABLE_NAME;
        extern const std::string VERSION_COLUMN_VERSION;
        
        extern const std::string MESSAGE_TABLE_NAME;
        extern const std::string USER_TABLE_NAME;
        extern const std::string GROUP_TABLE_NAME;
        extern const std::string GROUP_MEMBER_TABLE_NAME;
        extern const std::string TIMELINE_TABLE_NAME;
        extern const std::string CONVERSATION_TABLE_NAME;
        
        extern const std::string FRIEND_TABLE_NAME;
        extern const std::string FRIEND_REQUEST_TABLE_NAME;
        
        
        
        class DB {
            
        private:
            DB();
            ~DB();
            
        public:
            static DB* Instance();
            void Open();
            void Upgrade();
          bool isOpened();
            WCDB::RecyclableStatement GetSelectStatement(const std::string &tableName, const std::list<const std::string> &columns, WCDB::Error &error, const WCDB::Expr *where = NULL, const std::list<const WCDB::Order> *orderBy = NULL, int limit = 0, int offset = 0);
            WCDB::RecyclableStatement GetInsertStatement(const std::string &table, const std::list<const std::string> &columns, bool replace = false);
            bool ExecuteInsert(WCDB::RecyclableStatement statementHandle, long *rowId = NULL);
            
            WCDB::RecyclableStatement GetDeleteStatement(const std::string &table, const WCDB::Expr *where = NULL);
            int ExecuteDelete(WCDB::RecyclableStatement &statementHandle);
            
            
            WCDB::RecyclableStatement GetUpdateStatement(const std::string &table, const std::list<const std::string> &columns, const WCDB::Expr *where = NULL);
            int ExecuteUpdate(WCDB::RecyclableStatement &statementHandle);
            
            
            
            void Bind(WCDB::RecyclableStatement &statementHandle, float value, int index);
            void Bind(WCDB::RecyclableStatement &statementHandle, int value, int index);
            void Bind(WCDB::RecyclableStatement &statementHandle, int64_t value, int index);
            void Bind(WCDB::RecyclableStatement &statementHandle, const std::string &value, int index);
            void Bind(WCDB::RecyclableStatement &statementHandle, const void *value, int size, int index);
            
            
            float getFloatValue(const WCDB::RecyclableStatement &statementHandle, int index);
            int getIntValue(const WCDB::RecyclableStatement &statementHandle, int index);
            int64_t getBigIntValue(const WCDB::RecyclableStatement &statementHandle, int index);
            std::string getStringValue(const WCDB::RecyclableStatement &statementHandle, int index);
            const void* getBlobValue(const WCDB::RecyclableStatement &statementHandle, int index, int &size);

        private:
            static DB* instance_;
            WCDB::Database *_database;
            bool CreateDBVersion1();
            bool opened;
        };
        
    }
}

#endif /* DB_hpp */
