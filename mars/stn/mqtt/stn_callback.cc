// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

/** * created on : 2012-11-28 * author : yerungui, caoshaokun
 */
#include "stn_callback.h"

#include "mars/comm/autobuffer.h"
#include "mars/comm/xlogger/xlogger.h"
#include "mars/stn/stn.h"
#include "net_core.h"

#include "libemqtt.h"

namespace mars {
    namespace stn {
      
      void setConnectionStatusCallback(ConnectionStatusCallback *callback) {
        StnCallBack::Instance()->setConnectionStatusCallback(callback);
      }
      
      void setReceivePublishCallback(ReceivePublishCallback *callback) {
        StnCallBack::Instance()->setReceivePublishCallback(callback);
      }
      
      ConnectionStatus getConnectionStatus() {
        return StnCallBack::Instance()->getConnectionStatus();
      }
      
StnCallBack* StnCallBack::instance_ = NULL;
        
StnCallBack* StnCallBack::Instance() {
    if(instance_ == NULL) {
        instance_ = new StnCallBack();
    }
    
    return instance_;
}
        
void StnCallBack::Release() {
    delete instance_;
    instance_ = NULL;
}

      void StnCallBack::setConnectionStatusCallback(ConnectionStatusCallback *callback) {
        m_connectionStatusCB = callback;
      }
      void StnCallBack::setReceivePublishCallback(ReceivePublishCallback *callback) {
        m_receivePublishCB = callback;
      }
      
      void StnCallBack::updateConnectionStatus(ConnectionStatus newStatus) {
        m_connectionStatus = newStatus;
        if(m_connectionStatusCB) {
          m_connectionStatusCB->onConnectionStatusChanged(m_connectionStatus);
        }
      }
      
bool StnCallBack::MakesureAuthed() {
    return m_connectionStatus == kConnectionStatusConnected;
}


void StnCallBack::TrafficData(ssize_t _send, ssize_t _recv) {
    xdebug2(TSF"send:%_, recv:%_", _send, _recv);
}
        
std::vector<std::string> StnCallBack::OnNewDns(const std::string& _host) {
    std::vector<std::string> vector;
    //vector.push_back("118.89.24.72");
    return vector;
}

void StnCallBack::OnPush(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
  if(m_receivePublishCB) {
    std::string topic = (char *)(_body.Ptr());
    m_receivePublishCB->onReceivePublish(topic, (const unsigned char *)_extend.Ptr(), _extend.Length());
  }
}

bool StnCallBack::Req2Buf(uint32_t _taskid, void* const _user_context, AutoBuffer& _outbuffer, AutoBuffer& _extend, int& _error_code, const int _channel_select) {
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
    const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
    _extend.AllocWrite(publishTask->body.length());
    _extend.Write(publishTask->body.c_str(), publishTask->body.length());
    
    _outbuffer.AllocWrite(publishTask->topic.length());
    _outbuffer.Write(publishTask->topic.c_str(), publishTask->topic.length());
  }  else if (mqttTask->type == MQTT_MSG_DISCONNECT) {
    
  } else if (mqttTask->type == MQTT_MSG_SUBSCRIBE){
    const MQTTSubscribeTask *subscribeTask = (const MQTTSubscribeTask *)_user_context;
    _outbuffer.AllocWrite(subscribeTask->topic.length());
    _outbuffer.Write(subscribeTask->topic.c_str(), subscribeTask->topic.length());
  } else if (mqttTask->type == MQTT_MSG_UNSUBSCRIBE){
    const MQTTUnsubscribeTask *unsubscribeTask = (const MQTTUnsubscribeTask *)_user_context;
    _outbuffer.AllocWrite(unsubscribeTask->topic.length());
    _outbuffer.Write(unsubscribeTask->topic.c_str(), unsubscribeTask->topic.length());
  }
  return true;
}

int StnCallBack::Buf2Resp(uint32_t _taskid, void* const _user_context, const AutoBuffer& _inbuffer, const AutoBuffer& _extend, int& _error_code, const int _channel_select) {
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
    const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
    if (_error_code == 0)
      publishTask->m_callback->onSuccess();
    else
      publishTask->m_callback->onFalure(_error_code);
  }  else if (mqttTask->type == MQTT_MSG_DISCONNECT) {
    //const MQTTDisconnectTask *disconnectTask = (const MQTTDisconnectTask *)_user_context;
    //disconnect task no response
  } else if (mqttTask->type == MQTT_MSG_SUBSCRIBE){
    const MQTTSubscribeTask *subscribeTask = (const MQTTSubscribeTask *)_user_context;
    if (_error_code == 0)
      subscribeTask->m_callback->onSuccess();
    else
      subscribeTask->m_callback->onFalure(_error_code);
  } else if (mqttTask->type == MQTT_MSG_UNSUBSCRIBE){
    const MQTTUnsubscribeTask *unsubscribeTask = (const MQTTUnsubscribeTask *)_user_context;
    if (_error_code == 0)
      unsubscribeTask->m_callback->onSuccess();
    else
      unsubscribeTask->m_callback->onFalure(_error_code);
  } else {
    
  }
    int handle_type = mars::stn::kTaskFailHandleNormal;
  
    return handle_type;
}

int StnCallBack::OnTaskEnd(uint32_t _taskid, void* const _user_context, int _error_type, int _error_code) {
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
  const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
    if (_error_code > 0) {
      publishTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_SUBSCRIBE){
    const MQTTSubscribeTask *subscribeTask = (const MQTTSubscribeTask *)_user_context;
    if (_error_code > 0) {
      subscribeTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_UNSUBSCRIBE){
    const MQTTUnsubscribeTask *unsubscribeTask = (const MQTTUnsubscribeTask *)_user_context;
    if (_error_code > 0) {
      unsubscribeTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_PUBACK){
    //const MQTTPubAckTask *ackTask = (const MQTTPubAckTask *)_user_context;
    if (_error_code > 0) {
        //ack failure
    }
    
  } else {
    
  }
  delete mqttTask;
  return 0;

}


      
void StnCallBack::ReportConnectStatus(int _status, int longlink_status) {
    
    switch (longlink_status) {
        case mars::stn::kServerFailed:
        case mars::stn::kServerDown:
        case mars::stn::kGateWayFailed:
            updateConnectionStatus(kConnectionStatusUnconnected);
            break;
        case mars::stn::kConnecting:
            updateConnectionStatus(kConnectionStatusConnectiong);
            break;
        case mars::stn::kConnected:
            updateConnectionStatus(kConnectionStatusConnectiong);
            break;
        case mars::stn::kNetworkUnkown:
            updateConnectionStatus(kConnectionStatusUnconnected);
            return;
        default:
            return;
    }
    
}

// synccheck：长链成功后由网络组件触发
// 需要组件组包，发送一个req过去，网络成功会有resp，但没有taskend，处理事务时要注意网络时序
// 不需组件组包，使用长链做一个sync，不用重试
int  StnCallBack::GetLonglinkIdentifyCheckBuffer(AutoBuffer& _identify_buffer, AutoBuffer& _buffer_hash, int32_t& _cmdid) {
    _cmdid = MQTT_CONNECT_CMDID;
    return IdentifyMode::kCheckNow;
}

bool StnCallBack::OnLonglinkIdentifyResponse(const AutoBuffer& _response_buffer, const AutoBuffer& _identify_buffer_hash) {
  unsigned char * _packed = ( unsigned char *)_response_buffer.Ptr();
  
    /*
     CONNECTION_ACCEPTED((byte) 0x00),
     CONNECTION_REFUSED_UNACCEPTABLE_PROTOCOL_VERSION((byte) 0X01),
     CONNECTION_REFUSED_IDENTIFIER_REJECTED((byte) 0x02),
     CONNECTION_REFUSED_SERVER_UNAVAILABLE((byte) 0x03),
     CONNECTION_REFUSED_BAD_USER_NAME_OR_PASSWORD((byte) 0x04),
     CONNECTION_REFUSED_NOT_AUTHORIZED((byte) 0x05);
     */
    
  if (*(_packed + 1) == 0) {
    updateConnectionStatus(kConnectionStatusConnected);
  } else {
    updateConnectionStatus(kConnectionStatusRejected);
    return false;
  }
    return true;
}
//
void StnCallBack::RequestSync() {

}
        
        
    }
}






