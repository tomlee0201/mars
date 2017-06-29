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
      
      MQTTDisconnectTask::MQTTDisconnectTask() : MQTTTask(MQTT_MSG_DISCONNECT) {
        
      }
     
      void login(std::string &userName, std::string &passwd) {
        mqtt_init_auth(userName.c_str(), passwd.c_str());
        MakesureLonglinkConnected();
      }
    }
}
