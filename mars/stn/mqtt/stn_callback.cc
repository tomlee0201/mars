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
#include "mars/stn/mqtt/Proto/notify_message.pb.h"
#include "mars/stn/mqtt/Proto/pull_message_request.pb.h"
#include "mars/stn/mqtt/Proto/pull_message_result.pb.h"
#include "mars/stn/mqtt/MessageDB.hpp"

namespace mars {
    namespace stn {
      
//        extern const std::string sendMessageTopic;
        const std::string pullMessageTopic = "MP";
        const std::string notifyMessageTopic = "MN";
        
//        extern const std::string createGroupTopic;
//        extern const std::string addGroupMemberTopic;
//        extern const std::string kickoffGroupMemberTopic;
//        extern const std::string quitGroupTopic;
//        extern const std::string dismissGroupTopic;
//        extern const std::string modifyGroupInfoTopic;
//        extern const std::string getGroupInfoTopic;
//        extern const std::string getGroupMemberTopic;
//
        
      void setConnectionStatusCallback(ConnectionStatusCallback *callback) {
        StnCallBack::Instance()->setConnectionStatusCallback(callback);
      }
      
      void setReceiveMessageCallback(ReceiveMessageCallback *callback) {
        StnCallBack::Instance()->setReceiveMessageCallback(callback);
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
      void StnCallBack::setReceiveMessageCallback(ReceiveMessageCallback *callback) {
        m_receiveMessageCB = callback;
      }
      
        void StnCallBack::setGetUserInfoCallback(GetUserInfoCallback *callback) {
            m_getUserInfoCB = callback;
        }
        void StnCallBack::setGetGroupInfoCallback(GetGroupInfoCallback *callback) {
            m_getGroupInfoCB = callback;
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
        
void StnCallBack::onPullSuccess(std::list<TMessage> messageList, int64_t current, int64_t head) {
    isPulling = false;
    currentHead = current;
    MessageDB::Instance()->UpdateMessageTimeline(current);
    PullMessage(head);
    
    //save messages
    if(m_receiveMessageCB) {
        m_receiveMessageCB->onReceiveMessage(messageList, head > current);
    }
}
void StnCallBack::onPullFailure(int errorCode) {
    isPulling = false;
}
        
        class PullingMessagePublishCallback : public MQTTPublishCallback {
        public:
            PullingMessageCallback *cb;
            PullingMessagePublishCallback(PullingMessageCallback *callback) : MQTTPublishCallback(), cb(callback) {}
            
            void onSuccess(const unsigned char* data, size_t len) {
                std::list<TMessage> messageList;
                PullMessageResult result;
                std::string curUser = app::GetUserName();
                if (result.ParseFromArray((const void *)data, (int)len)) {
                    for (::google::protobuf::RepeatedPtrField< ::mars::stn::Message >::const_iterator it = result.message().begin(); it != result.message().end(); it++) {
                        const ::mars::stn::Message &pmsg = *it;
                        TMessage tmsg;
                        tmsg.conversationType = (int)pmsg.conversation().type();
                        tmsg.line = (int)pmsg.conversation().line();
                        
                        tmsg.from = pmsg.from_user();
                        if (tmsg.from == curUser) {
                            tmsg.target = pmsg.conversation().target();
                            tmsg.direction = 0;
                            tmsg.status = Message_Status_Sent;
                        } else {
                          if(tmsg.conversationType == 0) {
                            tmsg.target = pmsg.from_user();
                          } else {
                            tmsg.target = pmsg.conversation().target();
                          }
                            tmsg.direction = 1;
                            tmsg.status = Message_Status_Unread;
                        }
                        
                        tmsg.messageUid = pmsg.message_id();
                        tmsg.messageId = 0;
                        tmsg.timestamp = pmsg.server_timestamp();
                        tmsg.content.type = pmsg.content().type();
                        tmsg.content.searchableContent = pmsg.content().searchable_content();
                        tmsg.content.pushContent = pmsg.content().push_content();
                        tmsg.content.content = pmsg.content().content();
                        tmsg.content.binaryContent = std::string(pmsg.content().data().c_str(), pmsg.content().data().length());
                        tmsg.content.mediaType = pmsg.content().mediatype();
                        tmsg.content.remoteMediaUrl = pmsg.content().remotemediaurl();
                        
                        
                        
                        long id = MessageDB::Instance()->InsertMessage(tmsg);
                        tmsg.messageId = id;
                        
                        messageList.push_back(tmsg);
                        
                        MessageDB::Instance()->updateConversationTimestamp(tmsg.conversationType, tmsg.target, tmsg.line, tmsg.timestamp);
                    }

                    cb->onPullSuccess(messageList, result.current(), result.head());
                } else {
                    cb->onPullFailure(-1);
                }
                delete this;
            };
            void onFalure(int errorCode) {
                cb->onPullFailure(errorCode);
                delete this;
            };
            virtual ~PullingMessagePublishCallback() {
                
            }
        };
        
void StnCallBack::PullMessage(int64_t head) {
//    static long long currentMessageId = 0;
//    if (currentMessageId >= messageId) {
//        return;
//    }
//    PullMessageRequest *request = [[PullMessageRequest alloc] init];
//    request.id_p = currentMessageId;
//    request.type = PullType_PullNormal;
//    
//    NSData *data = request.data;
//    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:pullMessageTopic message:data];
//    
//    __weak typeof(self)weakSelf = self;
//    [publishTask send:^(NSData *data){
//     if (data) {
//     PullMessageResult *result = [PullMessageResult parseFromData:data error:nil];
//     if (result) {
//     currentMessageId = result.current;
//     [weakSelf pullMsg:result.head];
//     [weakSelf.receiveMessageDelegate onReceiveMessage:result.messageArray hasMore:currentMessageId < result.head];
//     }
//     }
//     } error:^(int error_code) {
//     
//     }];
    
    if (isPulling || currentHead >= head) {
        return;
    }
    isPulling = true;
    PullMessageRequest request;
    request.set_id(currentHead);
    request.set_type((PullType)0);
    
    std::string output;
    request.SerializeToString(&output);
    mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new PullingMessagePublishCallback(this));
    publishTask->topic = pullMessageTopic;
    publishTask->length = output.length();
    publishTask->body = new unsigned char[publishTask->length];
    memcpy(publishTask->body, output.c_str(), publishTask->length);
    mars::stn::StartTask(*publishTask);
}
        
void StnCallBack::OnPush(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
    std::string topic = (char *)(_body.Ptr());
    if (topic.compare(notifyMessageTopic) == 0) {
        NotifyMessage notifyMessage;
        if (notifyMessage.ParsePartialFromArray(_extend.Ptr(), (int)_extend.Length())) {
            PullMessage(notifyMessage.head());
        }
    }
}

bool StnCallBack::Req2Buf(uint32_t _taskid, void* const _user_context, AutoBuffer& _outbuffer, AutoBuffer& _extend, int& _error_code, const int _channel_select) {
    Task *task = (Task *)_user_context;
    if(task->cmdid == UPLOAD_SEND_OUT_CMDID) {
        UploadTask *uploadTask = (UploadTask *)_user_context;
        _outbuffer.AllocWrite(uploadTask->mData.length());
        _outbuffer.Write(uploadTask->mData.c_str(), uploadTask->mData.length());
        
        _extend.AllocWrite(uploadTask->mToken.length() + 1);
        _extend.Write(&(uploadTask->mMediaType), 1);
        _extend.Write(uploadTask->mToken.c_str(), uploadTask->mToken.length());
        return true;
    }
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
    const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
    _extend.AllocWrite(publishTask->length);
    _extend.Write(publishTask->body, publishTask->length);
    
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
    
    Task *task = (Task *)_user_context;
    if(task->cmdid == UPLOAD_SEND_OUT_CMDID) {
        UploadTask *uploadTask = (UploadTask *)_user_context;

        std::string result((char *)_inbuffer.Ptr(), _inbuffer.Length());
        long index = result.find("\"key\":\"");
        if (index > 0 && index < LONG_MAX) {
            std::string rest = result.substr(index + 7);
            index = rest.find("\"");
            if (index > 0 && index < LONG_MAX) {
                std::string key = rest.substr(0, index);
                if (!key.empty()) {
                    uploadTask->mCallback->onSuccess(key);
                    return mars::stn::kTaskFailHandleNormal;
                }
            }
        }
        uploadTask->mCallback->onFalure(-1);

        return mars::stn::kTaskFailHandleNormal;
    }
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
    const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
      if (_error_code == 0) {
          if (_inbuffer.Length() < 1) {
              publishTask->m_callback->onFalure(-1);
          } else {
              unsigned char *p = (unsigned char *)_inbuffer.Ptr();
              if (*p == 0) {
                  publishTask->m_callback->onSuccess((const unsigned char *)(_inbuffer.Ptr()) + 1, _inbuffer.Length()-1);
              } else {
                    publishTask->m_callback->onFalure(*p);
              }
          }
      }
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
    Task *task = (Task *)_user_context;
    if(task->cmdid == UPLOAD_SEND_OUT_CMDID) {
        UploadTask *uploadTask = (UploadTask *)_user_context;
        delete uploadTask;
        return 0;
    }
  const MQTTTask *mqttTask = (const MQTTTask *)_user_context;
  if (mqttTask->type == MQTT_MSG_PUBLISH) {
  const MQTTPublishTask *publishTask = (const MQTTPublishTask *)_user_context;
    if (_error_code != 0) {
      publishTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_SUBSCRIBE){
    const MQTTSubscribeTask *subscribeTask = (const MQTTSubscribeTask *)_user_context;
    if (_error_code != 0) {
      subscribeTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_UNSUBSCRIBE){
    const MQTTUnsubscribeTask *unsubscribeTask = (const MQTTUnsubscribeTask *)_user_context;
    if (_error_code != 0) {
      unsubscribeTask->m_callback->onFalure(_error_code);
    }
  } else if (mqttTask->type == MQTT_MSG_PUBACK){
    //const MQTTPubAckTask *ackTask = (const MQTTPubAckTask *)_user_context;
    if (_error_code != 0) {
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
//        case mars::stn::kConnected:
//            updateConnectionStatus(kConnectionStatusConnectiong);
//            break;
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
    PullMessage(0x7FFFFFFFFFFFFFFF);
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
        void StnCallBack::onDBOpened() {
            currentHead = MessageDB::Instance()->GetMessageTimeline();
        }
        
        
    }
}






