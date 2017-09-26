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
#include "mars/stn/mqtt/DB.hpp"
#include "mars/stn/mqtt/MessageDB.hpp"
#include "mars/stn/mqtt/stn_callback.h"
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
        
        UploadTask::UploadTask(const std::string &data, const std::string &token, int mediaType, UPloadCallback *callback) : Task(), mData(data), mToken(token), mMediaType(mediaType), mCallback(callback) {
            user_context = this;
            channel_select = ChannelType_ShortConn;
            cmdid = UPLOAD_SEND_OUT_CMDID;
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
        
      void login(std::string &userName, std::string &passwd) {
          DB::Instance()->Open();
          DB::Instance()->Upgrade();
          MessageDB::Instance()->FailSendingMessages();
          StnCallBack::Instance()->onDBOpened();
        mqtt_init_auth(userName.c_str(), passwd.c_str());
        MakesureLonglinkConnected();
        mars::baseevent::OnForeground(true);
      }
        
        std::list<TGroupInfo> getGroupInfoEx(const std::list<std::string> &groupIdList) {
            std::list<TGroupInfo> result;
            for (std::list<std::string>::const_iterator it = groupIdList.begin(); it != groupIdList.end(); ++it) {
                TGroupInfo info = MessageDB::Instance()->GetGroupInfo(*it, 0);
                if (!info.target.empty()) {
                    result.push_back(info);
                }
            }
            return result;
        };
        
        class RefreshUserInfoCallback : public GetUserInfoCallback {
        
        public:
            RefreshUserInfoCallback() {};
            void onSuccess(const std::list<const TUserInfo> &userInfoList) {
                
                for (std::list<const TUserInfo>::const_iterator it = userInfoList.begin(); it != userInfoList.end(); ++it) {
                    MessageDB::Instance()->InsertUserInfoOrReplace(*it);
                }
                delete this;
            }
            void onFalure(int errorCode) {
                delete this;
            }
            
            virtual ~RefreshUserInfoCallback() {}
        };
        
        
        std::list<TUserInfo> getUserInfoEx(const std::list<std::string> &userIdList) {
            std::list<TUserInfo> result;
            std::list<std::pair<std::string, int64_t>> userReqList;
            for (std::list<std::string>::const_iterator it = userIdList.begin(); it != userIdList.end(); ++it) {
                TUserInfo info = MessageDB::Instance()->getUserInfo(*it);
                if (!info.uid.empty()) {
                    result.push_back(info);
                    userReqList.push_back(std::pair<std::string, int64_t>(info.uid, info.updateDt));
                } else {
                    userReqList.push_back(std::pair<std::string, int64_t>(*it, 0));
                }
            }
            getUserInfo(userReqList, new RefreshUserInfoCallback());
            return result;
        };

    }
}
