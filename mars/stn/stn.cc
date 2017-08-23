// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

//
//  stn.cpp
//  stn
//
//  Created by yanguoyue on 16/3/3.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#include "mars/stn/stn.h"

#include "mars/comm/thread/atomic_oper.h"
#include "mars/stn/mqtt/libemqtt.h"
#include "mars/stn/stn_logic.h"
#include "mars/baseevent/base_logic.h"
#include <WCDB/core_base.hpp>
#include <WCDB/database.hpp>
#include <WCDB/statement_create_table.hpp>
#include "mars/app/app.h"

namespace mars{
    namespace stn{
      
      
static uint32_t gs_taskid = 10;
Task::Task():Task(atomic_inc32(&gs_taskid)) {}
        
Task::Task(uint32_t _taskid) {
    
    taskid = _taskid;
    cmdid = 0;
    channel_id = 0;
    channel_select = 0;
    
    send_only = false;
    need_authed = false;
    limit_flow = true;
    limit_frequency = true;
    
    channel_strategy = kChannelNormalStrategy;
    network_status_sensitive = false;
    priority = kTaskPriorityNormal;
    
    retry_count = -1;
    server_process_cost = -1;
    total_timetout = -1;
    user_context = NULL;

}

MQTTTask::MQTTTask(MQTT_MSG_TYPE type) : Task(), type(type) {
  user_context = this;
  channel_select = ChannelType_LongConn;
}
      
      MQTTPublishTask::MQTTPublishTask(MQTTPublishCallback *callback) : MQTTTask(MQTT_MSG_PUBLISH) , m_callback(callback) {
        cmdid = MQTT_SEND_OUT_CMDID;
      }
      
        MQTTPublishTask::~MQTTPublishTask() {delete [] body; body = NULL, length = 0;}
        
      MQTTSubscribeTask::MQTTSubscribeTask(MQTTGeneralCallback *callback) : MQTTTask(MQTT_MSG_SUBSCRIBE) , m_callback(callback) {
        cmdid = MQTT_SUBSCRIBE_CMDID;
      }
      
      MQTTUnsubscribeTask::MQTTUnsubscribeTask(MQTTGeneralCallback *callback) : MQTTTask(MQTT_MSG_UNSUBSCRIBE) , m_callback(callback) {
        cmdid = MQTT_UNSUBSCRIBE_CMDID;
      }
      
      MQTTPubAckTask::MQTTPubAckTask(uint16_t messageId) : MQTTTask(MQTT_MSG_PUBACK) {
        cmdid = MQTT_PUBACK_CMDID;
        taskid = messageId;
        send_only = true;
      }

      
      MQTTDisconnectTask::MQTTDisconnectTask() : MQTTTask(MQTT_MSG_DISCONNECT) {
        cmdid = MQTT_DISCONNECT_CMDID;
      }
     
        WCDB::Database *gDatabase = NULL;
        
      void login(std::string &userName, std::string &passwd) {
          std::string dbPath = app::GetAppFilePath() + "/" + "im.db";
          gDatabase = new WCDB::Database(dbPath.c_str());
          
          std::function<void(void)> callback = nullptr;
          
              callback = []() {
          
                  WCDB::Error unixError;
                  bool result = gDatabase->removeFiles(unixError);
                  

              };
          
          gDatabase->close(callback);

        
//      {
//          WCDB::ColumnDef localIDColumnDef(WCDB::Column("localID"), WCDB::ColumnType::Integer32);
//          localIDColumnDef.makePrimary(WCDB::OrderTerm::ASC);
//          WCDB::ColumnDef contentColumnDef(WCDB::Column("content"), WCDB::ColumnType::Text);
//          WCDB::ColumnDefList columnDefList = {localIDColumnDef, contentColumnDef};
//          WCDB::StatementCreateTable statementCreate = WCDB::StatementCreateTable().create("message", columnDefList);
//          WCTStatement *statementExplain = [database prepare:WCDB::StatementExplain().explain(statementCreate)];
//          if (statementExplain && [statementExplain step]) {
//              for (int i = 0; i < [statementExplain getCount]; ++i) {
//                  NSString *columnName = [statementExplain getNameAtIndex:i];
//                  WCTValue *value = [statementExplain getValueAtIndex:i];
//                  NSLog(@"%@:%@", columnName, value);
//              }
//          }
//      }
        
          WCDB::Column column1("testintc1");
          WCDB::ColumnDef columnDef1(column1, WCDB::ColumnType::Integer32);
          columnDef1.makePrimary();
          
          WCDB::Column column2("testtextc2");
          WCDB::ColumnDef columnDef2(column2, WCDB::ColumnType::Text);
          

          std::string tableName = "testtable";
          std::list<const WCDB::ColumnDef> defList = {columnDef1, columnDef2};
          
          WCDB::Error innerError;
          
          gDatabase->exec(WCDB::StatementCreateTable().create(tableName, defList, true),
                      innerError);

          
        mqtt_init_auth(userName.c_str(), passwd.c_str());
        MakesureLonglinkConnected();
        mars::baseevent::OnForeground(true);
      }
    }
}
