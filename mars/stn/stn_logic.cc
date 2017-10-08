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
//  stn_logic.cc
//  network
//
//  Created by yanguoyue on 16/2/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#include "mars/stn/stn_logic.h"
#include <sys/time.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <iterator>
#include <fstream>

#include "mars/log/appender.h"

#include "mars/baseevent/baseprjevent.h"
#include "mars/baseevent/active_logic.h"
#include "mars/baseevent/baseevent.h"
#include "mars/comm/xlogger/xlogger.h"
#include "mars/comm/messagequeue/message_queue.h"
#include "mars/comm/singleton.h"
#include "mars/comm/bootrun.h"
#include "mars/comm/platform_comm.h"
#include "mars/comm/compiler_util.h"
#include "mars/stn/mqtt/stn_callback.h"
#include "mars/stn/mqtt/MessageDB.hpp"

#include "stn/src/net_core.h"//一定要放这里，Mac os 编译
#include "stn/src/net_source.h"
#include "stn/src/signalling_keeper.h"
#include "mars/stn/mqtt/Proto/group.pb.h"
#include "mars/stn/mqtt/Proto/conversation.pb.h"
#include "mars/stn/mqtt/Proto/message.pb.h"
#include "mars/stn/mqtt/Proto/message_content.pb.h"
#include "mars/stn/mqtt/Proto/create_group_request.pb.h"
#include "mars/stn/mqtt/Proto/add_group_member_request.pb.h"
#include "mars/stn/mqtt/Proto/remove_group_member_request.pb.h"
#include "mars/stn/mqtt/Proto/quit_group_request.pb.h"

#include "mars/stn/mqtt/Proto/dismiss_group_request.pb.h"
#include "mars/stn/mqtt/Proto/modify_group_info_request.pb.h"
#include "mars/stn/mqtt/Proto/id_buf.pb.h"
#include "mars/stn/mqtt/Proto/id_list_buf.pb.h"
#include "mars/stn/mqtt/Proto/pull_group_info_result.pb.h"
#include "mars/stn/mqtt/Proto/pull_group_member_result.pb.h"
#include "mars/stn/mqtt/Proto/get_upload_token_result.pb.h"
#include "mars/stn/mqtt/Proto/transfer_group_request.pb.h"
#include "mars/stn/mqtt/Proto/pull_user_response.pb.h"
#include "mars/stn/mqtt/Proto/pull_user_request.pb.h"
#include "mars/stn/mqtt/Proto/modify_my_info_request.pb.h"
#include "stn/src/proxy_test.h"

#include "mars/stn/mqtt/rapidjson/document.h"
#include "mars/stn/mqtt/rapidjson/writer.h"
#include "mars/stn/mqtt/rapidjson/stringbuffer.h"
#include <iostream>

namespace mars {
namespace stn {

static Callback* sg_callback = StnCallBack::Instance();
static const std::string kLibName = "stn";

const std::string sendMessageTopic = "MS";
    
const std::string createGroupTopic = "GC";
const std::string addGroupMemberTopic = "GAM";
const std::string kickoffGroupMemberTopic = "GKM";
const std::string quitGroupTopic = "GQ";
const std::string dismissGroupTopic = "GD";
const std::string modifyGroupInfoTopic = "GMI";
const std::string getGroupInfoTopic = "GPGI";
const std::string getUserInfoTopic = "UPUI";
const std::string getGroupMemberTopic = "GPGM";
const std::string getMyGroupsTopic = "GMG";
const std::string transferGroupTopic = "GTG";
    
const std::string getQiniuUploadTokenTopic = "GQNUT";

const std::string modifyMyInfoTopic = "MMI";
    
#define STN_WEAK_CALL(func) \
    boost::shared_ptr<NetCore> stn_ptr = NetCore::Singleton::Instance_Weak().lock();\
    if (!stn_ptr) {\
        xwarn2(TSF"stn uncreate");\
        return;\
    }\
    stn_ptr->func

#define STN_WEAK_CALL_RETURN(func, ret) \
	boost::shared_ptr<NetCore> stn_ptr = NetCore::Singleton::Instance_Weak().lock();\
    if (stn_ptr) \
    {\
    	ret = stn_ptr->func;\
    }

static void onCreate() {
#if !UWP && !defined(WIN32)
    signal(SIGPIPE, SIG_IGN);
#endif

    xinfo2(TSF"stn oncreate");
    ActiveLogic::Singleton::Instance();
    NetCore::Singleton::Instance();

}

static void onDestroy() {
    xinfo2(TSF"stn onDestroy");

    NetCore::Singleton::Release();
    SINGLETON_RELEASE_ALL();
    
    // others use activelogic may crash after activelogic release. eg: LongLinkConnectMonitor
    // ActiveLogic::Singleton::Release();
}

static void onSingalCrash(int _sig) {
    appender_close();
}

static void onExceptionCrash() {
    appender_close();
}

static void onNetworkChange() {

    STN_WEAK_CALL(OnNetworkChange());
}
    
static void OnNetworkDataChange(const char* _tag, ssize_t _send, ssize_t _recv) {
    
    if (NULL == _tag || strnlen(_tag, 1024) == 0) {
        xassert2(false);
        return;
    }
    
    if (NULL != XLOGGER_TAG && 0 == strcmp(_tag, XLOGGER_TAG)) {
        TrafficData(_send, _recv);
    }
}


static void __initbind_baseprjevent() {

#ifdef ANDROID
	mars::baseevent::addLoadModule(kLibName);
#endif
    GetSignalOnCreate().connect(&onCreate);
    GetSignalOnDestroy().connect(&onDestroy);   //low priority signal func
    GetSignalOnSingalCrash().connect(&onSingalCrash);
    GetSignalOnExceptionCrash().connect(&onExceptionCrash);
    GetSignalOnNetworkChange().connect(5, &onNetworkChange);    //define group 5

    
#ifndef XLOGGER_TAG
#error "not define XLOGGER_TAG"
#endif
    
    GetSignalOnNetworkDataChange().connect(&OnNetworkDataChange);
}

BOOT_RUN_STARTUP(__initbind_baseprjevent);
    
void SetCallback(Callback* const callback) {
	sg_callback = callback;
}

void (*StartTask)(const Task& _task)
= [](const Task& _task) {
    STN_WEAK_CALL(StartTask(_task));
};

void (*StopTask)(uint32_t _taskid)
= [](uint32_t _taskid) {
    STN_WEAK_CALL(StopTask(_taskid));
};

bool (*HasTask)(uint32_t _taskid)
= [](uint32_t _taskid) {
	bool has_task = false;
	STN_WEAK_CALL_RETURN(HasTask(_taskid), has_task);
	return has_task;
};

void (*RedoTasks)()
= []() {
   STN_WEAK_CALL(RedoTasks());
};

void (*ClearTasks)()
= []() {
   STN_WEAK_CALL(ClearTasks());
};

void (*Reset)()
= []() {
	xinfo2(TSF "stn reset");
	NetCore::Singleton::Release();
	NetCore::Singleton::Instance();
};

void (*MakesureLonglinkConnected)()
= []() {
    xinfo2(TSF "make sure longlink connect");
   STN_WEAK_CALL(MakeSureLongLinkConnect());
};

bool (*LongLinkIsConnected)()
= []() {
    bool connected = false;
    STN_WEAK_CALL_RETURN(LongLinkIsConnected(), connected);
    return connected;
};
    
bool (*ProxyIsAvailable)(const mars::comm::ProxyInfo& _proxy_info, const std::string& _test_host, const std::vector<std::string>& _hardcode_ips)
= [](const mars::comm::ProxyInfo& _proxy_info, const std::string& _test_host, const std::vector<std::string>& _hardcode_ips){
    
    return ProxyTest::Singleton::Instance()->ProxyIsAvailable(_proxy_info, _test_host, _hardcode_ips);
};

//void SetLonglinkSvrAddr(const std::string& host, const std::vector<uint16_t> ports)
// {
//	SetLonglinkSvrAddr(host, ports, "");
//};


void (*SetLonglinkSvrAddr)(const std::string& host, const std::vector<uint16_t> ports, const std::string& debugip)
= [](const std::string& host, const std::vector<uint16_t> ports, const std::string& debugip) {
	std::vector<std::string> hosts;
	if (!host.empty()) {
		hosts.push_back(host);
	}
	NetSource::SetLongLink(hosts, ports, debugip);
};

//void SetShortlinkSvrAddr(const uint16_t port)
//{
//	NetSource::SetShortlink(port, "");
//};
    
void (*SetShortlinkSvrAddr)(const uint16_t port, const std::string& debugip)
= [](const uint16_t port, const std::string& debugip) {
	NetSource::SetShortlink(port, debugip);
};

void (*SetDebugIP)(const std::string& host, const std::string& ip)
= [](const std::string& host, const std::string& ip) {
	NetSource::SetDebugIP(host, ip);
};
    
void (*SetBackupIPs)(const std::string& host, const std::vector<std::string>& iplist)
= [](const std::string& host, const std::vector<std::string>& iplist) {
	NetSource::SetBackupIPs(host, iplist);
};

void (*SetSignallingStrategy)(long _period, long _keepTime)
= [](long _period, long _keepTime) {
    SignallingKeeper::SetStrategy((unsigned int)_period, (unsigned int)_keepTime);
};

void (*KeepSignalling)()
= []() {
#ifdef USE_LONG_LINK
    STN_WEAK_CALL(KeepSignal());
#endif
};

void (*StopSignalling)()
= []() {
#ifdef USE_LONG_LINK
    STN_WEAK_CALL(StopSignal());
#endif
};

uint32_t (*getNoopTaskID)()
= []() {
	return Task::kNoopTaskID;
};

void network_export_symbols_0(){}

#ifndef ANDROID
	//callback functions
bool (*MakesureAuthed)()
= []() {
	xassert2(sg_callback != NULL);
	return sg_callback->MakesureAuthed();
};

// 流量统计 
void (*TrafficData)(ssize_t _send, ssize_t _recv)
= [](ssize_t _send, ssize_t _recv) {
    xassert2(sg_callback != NULL);
    return sg_callback->TrafficData(_send, _recv);
};

//底层询问上层该host对应的ip列表 
std::vector<std::string> (*OnNewDns)(const std::string& host)
= [](const std::string& host) {
	xassert2(sg_callback != NULL);
	return sg_callback->OnNewDns(host);
};

//网络层收到push消息回调 
void (*OnPush)(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend)
= [](uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
	xassert2(sg_callback != NULL);
	sg_callback->OnPush(_channel_id, _cmdid, _taskid, _body, _extend);
};
//底层获取task要发送的数据 
bool (*Req2Buf)(uint32_t taskid,  void* const user_context, AutoBuffer& outbuffer, AutoBuffer& extend, int& error_code, const int channel_select)
= [](uint32_t taskid,  void* const user_context, AutoBuffer& outbuffer, AutoBuffer& extend, int& error_code, const int channel_select) {
	xassert2(sg_callback != NULL);
	return sg_callback->Req2Buf(taskid, user_context, outbuffer, extend, error_code, channel_select);
};
//底层回包返回给上层解析 
int (*Buf2Resp)(uint32_t taskid, void* const user_context, const AutoBuffer& inbuffer, const AutoBuffer& extend, int& error_code, const int channel_select)
= [](uint32_t taskid, void* const user_context, const AutoBuffer& inbuffer, const AutoBuffer& extend, int& error_code, const int channel_select) {
	xassert2(sg_callback != NULL);
	return sg_callback->Buf2Resp(taskid, user_context, inbuffer, extend, error_code, channel_select);
};
//任务执行结束 
int  (*OnTaskEnd)(uint32_t taskid, void* const user_context, int error_type, int error_code)
= [](uint32_t taskid, void* const user_context, int error_type, int error_code) {
	xassert2(sg_callback != NULL);
	return sg_callback->OnTaskEnd(taskid, user_context, error_type, error_code);
 };

//上报网络连接状态 
void (*ReportConnectStatus)(int status, int longlink_status)
= [](int status, int longlink_status) {
	xassert2(sg_callback != NULL);
	sg_callback->ReportConnectStatus(status, longlink_status);
};
    
void (*OnLongLinkNetworkError)(ErrCmdType _err_type, int _err_code, const std::string& _ip, uint16_t _port)
= [](ErrCmdType _err_type, int _err_code, const std::string& _ip, uint16_t _port) {

};
    
void (*OnShortLinkNetworkError)(ErrCmdType _err_type, int _err_code, const std::string& _ip, const std::string& _host, uint16_t _port)
= [](ErrCmdType _err_type, int _err_code, const std::string& _ip, const std::string& _host, uint16_t _port) {

};

//长连信令校验 ECHECK_NOW = 0, ECHECK_NEVER = 1, ECHECK_NEXT = 2
int  (*GetLonglinkIdentifyCheckBuffer)(AutoBuffer& identify_buffer, AutoBuffer& buffer_hash, int32_t& cmdid)
= [](AutoBuffer& identify_buffer, AutoBuffer& buffer_hash, int32_t& cmdid) {
	xassert2(sg_callback != NULL);
	return sg_callback->GetLonglinkIdentifyCheckBuffer(identify_buffer, buffer_hash, cmdid);
};
//长连信令校验回包
bool (*OnLonglinkIdentifyResponse)(const AutoBuffer& response_buffer, const AutoBuffer& identify_buffer_hash)
= [](const AutoBuffer& response_buffer, const AutoBuffer& identify_buffer_hash) {
	xassert2(sg_callback != NULL);
	return sg_callback->OnLonglinkIdentifyResponse(response_buffer, identify_buffer_hash);
};

void (*RequestSync)() 
= []() {
	xassert2(sg_callback != NULL);
	sg_callback->RequestSync();
};

void (*RequestNetCheckShortLinkHosts)(std::vector<std::string>& _hostlist)
= [](std::vector<std::string>& _hostlist) {
};

void (*ReportTaskProfile)(const TaskProfile& _task_profile)
= [](const TaskProfile& _task_profile) {
};

void (*ReportTaskLimited)(int _check_type, const Task& _task, unsigned int& _param)
= [](int _check_type, const Task& _task, unsigned int& _param) {
};

void (*ReportDnsProfile)(const DnsProfile& _dns_profile)
= [](const DnsProfile& _dns_profile) {
};
  
  class GeneralOperationPublishCallback : public MQTTPublishCallback {
    public:
    GeneralOperationPublishCallback(GeneralOperationCallback *cb) : MQTTPublishCallback(), callback(cb) {}
    GeneralOperationCallback *callback;
    void onSuccess(const unsigned char* data, size_t len) {
      callback->onSuccess();
      delete this;
    };
    void onFalure(int errorCode) {
      callback->onFalure(errorCode);
      delete this;
    };
    virtual ~GeneralOperationPublishCallback() {
      
    }
  };
  
  
    class MessagePublishCallback : public MQTTPublishCallback {
    public:
        MessagePublishCallback(long messageId, SendMessageCallback *cb) : MQTTPublishCallback(), callback(cb), mId(messageId) {}
        long mId;
        SendMessageCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            long long messageUId = 0;
            long long timestamp = 0;
            if (len == 16) {
                const unsigned char* p = data;
                for (int i = 0; i < 8; i++) {
                    messageUId = (messageUId << 8) + *(p + i);
                    timestamp = (timestamp << 8) + *(p + 8 + i);
                }
                MessageDB::Instance()->updateMessageStatus(mId, Message_Status_Sent);
                callback->onSuccess(messageUId, timestamp);
            } else {
                MessageDB::Instance()->updateMessageStatus(mId, Message_Status_Send_Failure);
                callback->onFalure(-1);
            }

            delete this;
        };
        void onFalure(int errorCode) {
            MessageDB::Instance()->updateMessageStatus(mId, Message_Status_Send_Failure);
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~MessagePublishCallback() {
            
        }
    };
    
    void publishTask(const ::google::protobuf::Message &message, MQTTPublishCallback *callback, const std::string &topic) {
        std::string output;
        message.SerializeToString(&output);
        mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(callback);
        publishTask->topic = topic;
        publishTask->length = output.length();
        publishTask->body = new unsigned char[publishTask->length];
        memcpy(publishTask->body, output.c_str(), publishTask->length);
        mars::stn::StartTask(*publishTask);
    }
    
    void fillMessageContent(TMessage &tmsg, MessageContent *content) {
        content->set_type((::mars::stn::ContentType)tmsg.content.type);
        content->set_searchable_content(tmsg.content.searchableContent);
        content->set_push_content(tmsg.content.pushContent);
        content->set_content(tmsg.content.content);
        content->set_data(tmsg.content.binaryContent.c_str(), tmsg.content.binaryContent.length());
        content->set_mediatype(tmsg.content.mediaType);
        content->set_remotemediaurl(tmsg.content.remoteMediaUrl);
    }
    
    void fillConversation(TMessage &tmsg, Conversation *conversation) {
        conversation->set_type((ConversationType)tmsg.conversationType);
        conversation->set_target(tmsg.target);
        conversation->set_line(tmsg.line);
    }

    
    void sendSavedMsg(long messageId, TMessage tmsg, SendMessageCallback *callback) {
        Message message;
        
        fillConversation(tmsg, message.mutable_conversation());
        message.set_from_user(app::GetUserName());
        fillMessageContent(tmsg, message.mutable_content());
        
        publishTask(message, new MessagePublishCallback(messageId, callback), sendMessageTopic);
    }
    
    class UploadQiniuCallback : public GeneralStringCallback {
        TMessage mMsg;
        UpdateMediaCallback *mCallback;
        std::string mDomain;
        long mMid;
    public:
        UploadQiniuCallback(UpdateMediaCallback *callback, std::string domain) : mCallback(callback), mDomain(domain) {
            
        }
        void onSuccess(std::string key) {
            std::string fileUrl = mDomain + "/" + key;
          mCallback->onSuccess(fileUrl);
            delete this;
        }
        void onFalure(int errorCode) {
          mCallback->onFalure(errorCode);
            delete this;
        }
        virtual ~UploadQiniuCallback() {
            
        }
    };
    class GetUploadTokenCallback : public MQTTPublishCallback {
    public:
        GetUploadTokenCallback(UpdateMediaCallback *cb, const std::string md) : MQTTPublishCallback(), callback(cb), mediaData(md) {}
        TMessage msg;
        std::string mediaData;
        UpdateMediaCallback *callback;
        long mMid;
        void onSuccess(const unsigned char* data, size_t len) {
            GetUploadTokenResult result;
            if(result.ParseFromArray((const void*)data, (int)len)) {
                UploadTask *uploadTask = new UploadTask(mediaData, result.token(), msg.content.mediaType, new UploadQiniuCallback(callback, result.domain()));
                uploadTask->cgi = "/fs";//*/result.server();
                std::string server = result.server();
                uploadTask->shortlink_host_list.push_back(server);
                StartTask(*uploadTask);
            } else {
              callback->onFalure(-1);
            }
            
            
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~GetUploadTokenCallback() {
            
        }
    };

  class UploadMediaForSendCallback : public UpdateMediaCallback {
  public:
    TMessage mMsg;
    SendMessageCallback *mCallback;
    long mMid;
    
    UploadMediaForSendCallback(SendMessageCallback *cb, const TMessage &tmsg, long messageId) : mMsg(tmsg), mCallback(cb), mMid(messageId) {}
    
    void onSuccess(const std::string &remoteUrl) {
      MessageDB::Instance()->updateMessageRemoteMediaUrl(mMid, remoteUrl);
      mMsg.content.remoteMediaUrl = remoteUrl;
      mCallback->onMediaUploaded(remoteUrl);
      sendSavedMsg(mMid, mMsg, mCallback);
      delete this;
    }
    
    void onFalure(int errorCode) {
      mCallback->onFalure(errorCode);
      delete this;
    }
    ~UploadMediaForSendCallback() {}
  };
  
int (*sendMessage)(TMessage &tmsg, SendMessageCallback *callback)
= [](TMessage &tmsg, SendMessageCallback *callback) {
    tmsg.timestamp = time(NULL)*1000;
  long id = MessageDB::Instance()->InsertMessage(tmsg);
  MessageDB::Instance()->updateConversationTimestamp(tmsg.conversationType, tmsg.target, tmsg.line, tmsg.timestamp);
  callback->onPrepared(id, tmsg.timestamp);
  
    if(!tmsg.content.localMediaPath.empty() && tmsg.content.mediaType > 0) {
        
        char * buffer;
        long size;
        std::ifstream file (tmsg.content.localMediaPath.c_str(), std::ios::in|std::ios::binary|std::ios::ate);
        size = file.tellg();
        file.seekg (0, std::ios::beg);
        buffer = new char [size];
        file.read (buffer, size);
        file.close();
        
        std::string md(buffer, size);
        
        delete [] buffer;
        
        mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new GetUploadTokenCallback(new UploadMediaForSendCallback(callback, tmsg, id), md));
        publishTask->topic = getQiniuUploadTokenTopic;
        publishTask->length = sizeof(int);
        publishTask->body = new unsigned char[publishTask->length];
        memcpy(publishTask->body, &tmsg.content.mediaType, publishTask->length);
        mars::stn::StartTask(*publishTask);
    } else {
        sendSavedMsg(id, tmsg, callback);
    }
    return 0;
};
  
  int uploadGeneralMedia(std::string mediaData, int mediaType, UpdateMediaCallback *callback) {
    mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new GetUploadTokenCallback(callback, mediaData));
    publishTask->topic = getQiniuUploadTokenTopic;
    publishTask->length = sizeof(int);
    publishTask->body = new unsigned char[publishTask->length];
    memcpy(publishTask->body, &mediaType, publishTask->length);
    mars::stn::StartTask(*publishTask);
    return 0;
  }
  
  int modifyMyInfo(const std::list<std::pair<int, std::string>> &infos, GeneralOperationCallback *callback) {
    ModifyMyInfoRequest request;
    for (std::list<std::pair<int, std::string>>::const_iterator it = infos.begin(); it != infos.end(); it++) {
      InfoEntry *entry = request.add_entry();
      entry->set_type(it->first);
      entry->set_value(it->second);
    }
    
    publishTask(request, new GeneralOperationPublishCallback(callback), modifyMyInfoTopic);
    return 0;
  }
    class CreateGroupPublishCallback : public MQTTPublishCallback {
    public:
        CreateGroupPublishCallback(CreateGroupCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        CreateGroupCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            int errorCode = 0;
            if (len == 4) {
                const unsigned char* p = data;
                for (int i = 0; i < 4; i++) {
                    errorCode = (errorCode << 8) + *(p + i);
                }
                if (errorCode == 0) {
                    callback->onSuccess("");
                } else {
                    callback->onFalure(errorCode);
                }
            } else {
                callback->onFalure(-1);
            }
            
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~CreateGroupPublishCallback() {
            
        }
    };
    
    using namespace rapidjson;

    int parseSearchUserResult(const std::string &json, std::list<TUserInfo> &userInfos) {
        const std::string &key = json;
//        "{                        \
//                \"code\": 0,             \
//                \"msg\": \"success\",       \
//                \"result\": {                   \
//                    \"keyword\": \"张\",            \
//                    \"page\": 0,                      \
//                    \"users\": [                        \
//                        {                             \
//                            \"userId\": \"user1\",           \
//                            \"name\": \"zhangsan\",              \
//                            \"displayName\": \"张三\",               \
//                            \"portrait\": \"http:7xqgbn.com1.z0.glb.clouddn.com/user1-1507346359_8727\",    \
//                            \"mobile\": \"10086\",                        \
//                            \"email\": \"zhangsan@example.com\",                  \
//                            \"address\": \"南国中路38号\",                         \
//                            \"company\": \"纵横世界大发展股份有限公司\",               \
//                            \"extra\": \"{\\\"title\\\":\\\"老总\\\"}\"                  \
//                        }                                                     \
//                    ]                                                 \
//                }                                                           \
//            }";
        
        
        Document d;
        d.Parse(key.c_str());
        
        if(d.HasParseError()) {
            return -1; //json paser error
        }
        
        Value& s = d["code"];
        
        int code = s.GetInt();
        if(code != 0) {
            return code;
        } else {
            s = d["result"];
            if(s.IsObject()) {
                s = s["users"];
                if (!s.IsArray()) {
                    return -1;
                } else {
                    for (int i = 0; i < s.Size(); i++) {
                        Value& user = s[i];
                        if(user.IsObject()) {
                            TUserInfo userInfo;
                            
                            if (user.HasMember("userId") && user["userId"].IsString()) {
                                std::string userId = user["userId"].GetString();
                                userInfo.uid = userId;
                            }
                            
                            if (user.HasMember("name") && user["name"].IsString()) {
                                std::string name = user["name"].GetString();
                                userInfo.name = name;
                            }
                            
                            if (user.HasMember("displayName") && user["displayName"].IsString()) {
                                std::string displayName = user["displayName"].GetString();
                                userInfo.displayName = displayName;
                            }
                            
                            if (user.HasMember("portrait") && user["portrait"].IsString()) {
                                std::string portrait = user["portrait"].GetString();
                                userInfo.portrait = portrait;
                            }
                            
                            if (user.HasMember("mobile") && user["mobile"].IsString()) {
                                std::string mobile = user["mobile"].GetString();
                                userInfo.mobile = mobile;
                            }
                            
                            if (user.HasMember("email") && user["email"].IsString()) {
                                std::string email = user["email"].GetString();
                                userInfo.email = email;
                            }
                            
                            if (user.HasMember("address") && user["address"].IsString()) {
                                std::string address = user["address"].GetString();
                                userInfo.address = address;
                            }
                            
                            if (user.HasMember("company") && user["company"].IsString()) {
                                std::string company = user["company"].GetString();
                                userInfo.company = company;
                            }
                            
                            if (user.HasMember("extra") && user["extra"].IsString()) {
                                std::string extra = user["extra"].GetString();
                                userInfo.extra = extra;
                            }
                            userInfos.push_back(userInfo);
                        }
                    }
                }
            } else {
                return -1;;
            }
        }
        return 0;
    }
    class TSearchUserCallback : public GeneralStringCallback {
    private:
        SearchUserCallback *mCallback;
    public:
        TSearchUserCallback(SearchUserCallback *callback) : mCallback(callback) {}
        void onSuccess(std::string key) {
            std::list<TUserInfo> userInfos;
            int code = parseSearchUserResult(key, userInfos);
            if (code == 0) {
                mCallback->onSuccess(userInfos, "", 0);
            } else {
                mCallback->onFalure(code);
            }
            
            delete this;
        }
        
        void onFalure(int errorCode) {
            mCallback->onFalure(errorCode);
            delete this;
        }
        
        ~TSearchUserCallback() {
            
        }
    };
    
    
void searchUser(const std::string &keyword, bool puzzy, int page, SearchUserCallback *callback) {
    std::string cgi = "/api/search?keyword=" + keyword;
    if (puzzy) {
        cgi += "&fuzzy=true";
    }
    if (page>0) {
        cgi += "&page=";
        cgi += page;
    }
    
    HTTPTask *httpTask = new HTTPTask("GET", cgi,  new TSearchUserCallback(callback));
    
    StartTask(*httpTask);
    
    return;
}
    
void (*createGroup)(const std::string &groupId, const std::string &groupName, const std::string &groupPortrait, const std::list<std::string> &groupMembers, const std::list<int> &notifyLines, TMessage &tmsg, CreateGroupCallback *callback)
= [](const std::string &groupId, const std::string &groupName, const std::string &groupPortrait, const std::list<std::string> &groupMembers, const std::list<int> &notifyLines, TMessage &tmsg, CreateGroupCallback *callback) {
    CreateGroupRequest request;
    request.mutable_group()->mutable_group_info()->set_target_id(groupId);
    request.mutable_group()->mutable_group_info()->set_portrait(groupPortrait);
    request.mutable_group()->mutable_group_info()->set_name(groupName);
    request.mutable_group()->mutable_members()->Reserve((int)groupMembers.size());
    
    for (std::list<std::string>::const_iterator it = groupMembers.begin(); it != groupMembers.end(); it++) {
        GroupMember *gm = request.mutable_group()->mutable_members()->Add();
        gm->set_member_id(*it);
        gm->set_type(0);
    }
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new CreateGroupPublishCallback(callback), createGroupTopic);
};
    

void (*addMembers)(const std::string &groupId, const std::list<std::string> &members, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
= [](const std::string &groupId, const std::list<std::string> &members, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
    AddGroupMemberRequest request;
    request.set_group_id(groupId);
    request.mutable_added_member()->Reserve((int)members.size());
    
    for (std::list<std::string>::const_iterator it = members.begin(); it != members.end(); it++) {
        GroupMember *gm = request.mutable_added_member()->Add();
        gm->set_member_id(*it);
        gm->set_type(0);
    }
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new GeneralOperationPublishCallback(callback), addGroupMemberTopic);
};

void (*kickoffMembers)(const std::string &groupId, const std::list<std::string> &members, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
= [](const std::string &groupId, const std::list<std::string> &members, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
    RemoveGroupMemberRequest request;
    request.set_group_id(groupId);
    request.mutable_removed_member()->Reserve((int)members.size());
    
    for (std::list<std::string>::const_iterator it = members.begin(); it != members.end(); it++) {
        request.mutable_removed_member()->AddAllocated(new std::string(*it));
    }
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new GeneralOperationPublishCallback(callback), kickoffGroupMemberTopic);
};

void (*quitGroup)(const std::string &groupId, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
= [](const std::string &groupId, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
    QuitGroupRequest request;
    request.set_group_id(groupId);
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new GeneralOperationPublishCallback(callback), quitGroupTopic);
};

void (*dismissGroup)(const std::string &groupId, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
= [](const std::string &groupId, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
    DismissGroupRequest request;
    request.set_group_id(groupId);
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new GeneralOperationPublishCallback(callback), dismissGroupTopic);

};
    class GetGroupInfoPublishCallback : public MQTTPublishCallback {
    public:
        GetGroupInfoPublishCallback(GetGroupInfoCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetGroupInfoCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            PullGroupInfoResult result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<const TGroupInfo> retList;
                
                for (::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >::const_iterator it = result.info().begin(); it != result.info().end(); it++) {
                    const ::mars::stn::GroupInfo &info = *it;
                    TGroupInfo tInfo;
                    tInfo.target = info.target_id();
                    tInfo.name = info.name();
                    tInfo.portrait = info.portrait();
                    tInfo.owner = info.owner();
                    tInfo.type = info.type();
                    tInfo.extra = info.extra();
                    tInfo.updateDt = info.update_dt();
                    retList.push_back(*const_cast<const TGroupInfo*>(&tInfo));
                }
                callback->onSuccess(*const_cast<const std::list<const mars::stn::TGroupInfo>*>(&retList));
            } else {
                callback->onFalure(-1);
            }
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~GetGroupInfoPublishCallback() {
            
        }
    };

void (*getGroupInfo)(const std::list<std::pair<std::string, int64_t>> &groupIdList, GetGroupInfoCallback *callback)
= [](const std::list<std::pair<std::string, int64_t>> &groupIdList, GetGroupInfoCallback *callback) {
    IDListBuf listBuf;
    listBuf.mutable_id()->Reserve((int)groupIdList.size());
    for (std::list<std::pair<std::string, int64_t>>::const_iterator it = groupIdList.begin(); it != groupIdList.end(); it++) {
        listBuf.mutable_id()->AddAllocated(new std::string((*it).first));
    }
    
    publishTask(listBuf, new GetGroupInfoPublishCallback(callback), getGroupInfoTopic);
};

void (*modifyGroupInfo)(const std::string &groupId, const TGroupInfo &groupInfo, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
= [](const std::string &groupId, const TGroupInfo &groupInfo, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
    ModifyGroupInfoRequest request;
    request.mutable_group_info()->set_target_id(groupId);
    
    if (!groupInfo.name.empty())
        request.mutable_group_info()->set_name(groupInfo.name);
    if (!groupInfo.portrait.empty())
        request.mutable_group_info()->set_portrait(groupInfo.portrait);
    if (!groupInfo.owner.empty())
        request.mutable_group_info()->set_owner(groupInfo.owner);
    if (groupInfo.type >= 0)
        request.mutable_group_info()->set_type((GroupType)groupInfo.type);
    if (!groupInfo.extra.empty()) {
        request.mutable_group_info()->set_extra(groupInfo.extra);
    }
    
    for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
        request.mutable_to_line()->Add(*it);
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new GeneralOperationPublishCallback(callback), modifyGroupInfoTopic);
};
    class GetGroupMembersPublishCallback : public MQTTPublishCallback {
    public:
        GetGroupMembersPublishCallback(GetGroupMembersCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetGroupMembersCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            PullGroupMemberResult result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<std::string> retList;
                
                for (::google::protobuf::RepeatedPtrField<GroupMember>::const_iterator it = result.member().begin(); it != result.member().end(); it++) {
                    const GroupMember member = *it;
                    retList.push_back(member.member_id());
                }
                callback->onSuccess(retList);
            } else {
                callback->onFalure(-1);
            }
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~GetGroupMembersPublishCallback() {
            
        }
    };
void (*getGroupMembers)(const std::string &groupId, GetGroupMembersCallback *callback)
= [](const std::string &groupId, GetGroupMembersCallback *callback) {
    IDBuf idBuf;
    idBuf.set_id(groupId);
    
    publishTask(idBuf, new GetGroupMembersPublishCallback(callback), getGroupMemberTopic);
};
    class GetMyGroupsPublishCallback : public MQTTPublishCallback {
    public:
        GetMyGroupsPublishCallback(GetMyGroupsCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetMyGroupsCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            IDListBuf result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<std::string> retList;
                
                for (::google::protobuf::RepeatedPtrField< ::std::string>::const_iterator it = result.id().begin(); it != result.id().end(); it++) {
                    const std::string &memberId = *it;
                    retList.push_back(memberId);
                }
                callback->onSuccess(retList);
            } else {
                callback->onFalure(-1);
            }
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~GetMyGroupsPublishCallback() {
            
        }
    };

void (*getMyGroups)(GetMyGroupsCallback *callback)
= [](GetMyGroupsCallback *callback) {
    IDBuf idBuf;
    idBuf.set_id("");
    publishTask(idBuf, new GetMyGroupsPublishCallback(callback), getMyGroupsTopic);
};
    
    void (*transferGroup)(const std::string &groupId, const std::string &newOwner, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback)
    = [](const std::string &groupId, const std::string &newOwner, const std::list<int> &notifyLines, TMessage &tmsg, GeneralOperationCallback *callback) {
        TransferGroupRequest request;
        request.set_group_id(groupId);
        request.set_new_owner(newOwner);
        
        for(std::list<int>::const_iterator it = notifyLines.begin(); it != notifyLines.end(); it++) {
            request.mutable_to_line()->Add(*it);
        }
        
        
        fillMessageContent(tmsg, request.mutable_notify_content());
        
        publishTask(request, new GeneralOperationPublishCallback(callback), transferGroupTopic);
    };
    
    class GetUserInfoPublishCallback : public MQTTPublishCallback {
    public:
        GetUserInfoPublishCallback(GetUserInfoCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetUserInfoCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            PullUserResult result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<const TUserInfo> retList;
                
                for (::google::protobuf::RepeatedPtrField<const ::mars::stn::UserResult>::iterator it = result.result().begin(); it != result.result().end(); it++) {
                    const ::mars::stn::UserResult &userResult = *it;
                    
                    
                    const ::mars::stn::User &info = userResult.user();
                    
                    if (userResult.code() == 0) {
                        TUserInfo tInfo;
                        
                        tInfo.uid = info.uid();
                        tInfo.name = info.name();
                        tInfo.displayName = info.display_name();
                        tInfo.portrait = info.portrait();
                        tInfo.mobile = info.mobile();
                        tInfo.email = info.email();
                        tInfo.address = info.address();
                        tInfo.company = info.company();
                        
                        tInfo.extra = info.extra();
                        tInfo.updateDt = info.update_dt();
                        
                        retList.push_back(tInfo);
                    }
                    
                }
                callback->onSuccess(retList);
            } else {
                callback->onFalure(-1);
            }
            delete this;
        };
        void onFalure(int errorCode) {
            callback->onFalure(errorCode);
            delete this;
        };
        virtual ~GetUserInfoPublishCallback() {
            
        }
    };
    
    
    void (*getUserInfo)(const std::list<std::pair<std::string, int64_t>> &userReqList, GetUserInfoCallback *callback)
    =[](const std::list<std::pair<std::string, int64_t>> &userReqList, GetUserInfoCallback *callback) {
        PullUserRequest request;
        
        for (std::list<std::pair<std::string, int64_t>>::const_iterator it = userReqList.begin(); it != userReqList.end(); it++) {
            ::mars::stn::UserRequest* item = request.mutable_request()->Add();
            item->set_uid((*it).first);
            item->set_update_dt((*it).second);
        }
        
        publishTask(request, new GetUserInfoPublishCallback(callback), getUserInfoTopic);
    };
#endif

}
}
