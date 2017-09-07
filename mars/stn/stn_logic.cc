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
const std::string getGroupMemberTopic = "GPGM";
    
const std::string getQiniuUploadTokenTopic = "GQNUT";

    
#define STN_WEAK_CALL(func) \
    boost::shared_ptr<NetCore> stn_ptr = NetCore::Singleton::Instance_Weak().lock();\
    if (!stn_ptr) {\
        xwarn2(TSF"stn uncreate");\
        return;\
    }\
    stn_ptr->func

#define STN_WEAK_CALL_RETURN(func, ret) \
    \
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
    ActiveLogic::Singleton::Release();
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
    GetSignalOnNetworkChange().connect(&onNetworkChange);
    
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
    
    class UploadQiniuCallback : public UPloadCallback {
        TMessage mMsg;
        SendMessageCallback *mCallback;
        std::string mDomain;
        long mMid;
    public:
        UploadQiniuCallback(TMessage tmsg, SendMessageCallback *callback, std::string domain, long messageId) : mMsg(tmsg), mCallback(callback), mDomain(domain), mMid(messageId) {
            
        }
        void onSuccess(std::string key) {
            std::string fileUrl = mDomain + "/" + key;
            MessageDB::Instance()->updateMessageRemoteMediaUrl(mMid, fileUrl);
            mCallback->onMediaUploaded(key);
            sendSavedMsg(mMid, mMsg, mCallback);
            delete this;
        }
        void onFalure(int errorCode) {
            delete this;
        }
        virtual ~UploadQiniuCallback() {
            
        }
    };
    class GetUploadTokenCallback : public MQTTPublishCallback {
    public:
        GetUploadTokenCallback(SendMessageCallback *cb, const TMessage &tmsg, const std::string md, long messageId) : MQTTPublishCallback(), callback(cb), msg(tmsg), mediaData(md), mMid(messageId) {}
        TMessage msg;
        std::string mediaData;
        SendMessageCallback *callback;
        long mMid;
        void onSuccess(const unsigned char* data, size_t len) {
            GetUploadTokenResult result;
            if(result.ParseFromArray((const void*)data, (int)len)) {
                UploadTask *uploadTask = new UploadTask(mediaData, result.token(), new UploadQiniuCallback(msg, callback, result.domain(), mMid));
                uploadTask->cgi = result.server();
                uploadTask->shortlink_host_list.push_back("up.qbox.me"); 
                StartTask(*uploadTask);
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


 
    
// conversation.type, [conversation.target UTF8String], payload.contentType, [payload.searchableContent UTF8String], [payload.pushContent UTF8String], [payload.content UTF8String], [payload.localContent UTF8String], (const unsigned char *)payload.binaryContent.bytes, payload.binaryContent.length, new IMSendMessageCallback(message, successBlock, errorBlock), mediaPayload.mediaType, [mediaPayload.remoteMediaUrl UTF8String], [mediaPayload.localMediaPath UTF8String]
    
int (*sendMessage)(TMessage &tmsg, SendMessageCallback *callback)
= [](TMessage &tmsg, SendMessageCallback *callback) {
  
  long id = MessageDB::Instance()->InsertMessage(tmsg);
  MessageDB::Instance()->updateConversationTimestamp(tmsg.conversationType, tmsg.target, tmsg.line, tmsg.timestamp);
  callback->onPrepared(id);
  
  

    
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
        
        mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new GetUploadTokenCallback(callback, tmsg, md, id));
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
                    callback->onSuccess(0);
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
   
void (*createGroup)(const std::string &groupId, const std::string &groupName, const std::string &groupPortrait, const std::list<std::string> &groupMembers, TMessage &tmsg, CreateGroupCallback *callback)
= [](const std::string &groupId, const std::string &groupName, const std::string &groupPortrait, const std::list<std::string> &groupMembers, TMessage &tmsg, CreateGroupCallback *callback) {
    CreateGroupRequest request;
    request.mutable_group()->mutable_group_info()->set_target_id(groupId);
    request.mutable_group()->mutable_group_info()->set_portrait(groupPortrait);
    request.mutable_group()->mutable_group_info()->set_name(groupName);
    request.mutable_group()->mutable_members()->Reserve((int)groupMembers.size());
    
    for (std::list<std::string>::const_iterator it = groupMembers.begin(); it != groupMembers.end(); it++) {
        request.mutable_group()->mutable_members()->AddAllocated(new std::string(*it));
    }
    
    fillMessageContent(tmsg, request.mutable_notify_content());
    
    publishTask(request, new CreateGroupPublishCallback(callback), createGroupTopic);
};
    
    class GeneralGroupOperationPublishCallback : public MQTTPublishCallback {
    public:
        GeneralGroupOperationPublishCallback(GeneralGroupOperationCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GeneralGroupOperationCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            int errorCode = 0;
            if (len == 4) {
                const unsigned char* p = data;
                for (int i = 0; i < 4; i++) {
                    errorCode = (errorCode << 8) + *(p + i);
                }
                if (errorCode == 0) {
                    callback->onSuccess();
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
        virtual ~GeneralGroupOperationPublishCallback() {
            
        }
    };
    
void (*addMembers)(const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback)
= [](const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback) {
    AddGroupMemberRequest request;
    request.set_group_id(groupId);
    request.mutable_added_member()->Reserve((int)members.size());
    
    for (std::list<std::string>::const_iterator it = members.begin(); it != members.end(); it++) {
        request.mutable_added_member()->AddAllocated(new std::string(*it));
    }
    
    request.mutable_notify_content()->set_type((ContentType)notifyContentType);
    request.mutable_notify_content()->set_searchable_content(notifySearchableContent);
    request.mutable_notify_content()->set_push_content(notifyPushContent);
    request.mutable_notify_content()->set_data((void *)notifyData, notifyDataLen);
    
    publishTask(request, new GeneralGroupOperationPublishCallback(callback), addGroupMemberTopic);
};

void (*kickoffMembers)(const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback)
= [](const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback) {
    RemoveGroupMemberRequest request;
    request.set_group_id(groupId);
    request.mutable_removed_member()->Reserve((int)members.size());
    
    for (std::list<std::string>::const_iterator it = members.begin(); it != members.end(); it++) {
        request.mutable_removed_member()->AddAllocated(new std::string(*it));
    }
    
    request.mutable_notify_content()->set_type((ContentType)notifyContentType);
    request.mutable_notify_content()->set_searchable_content(notifySearchableContent);
    request.mutable_notify_content()->set_push_content(notifyPushContent);
    request.mutable_notify_content()->set_data((void *)notifyData, notifyDataLen);
    
    publishTask(request, new GeneralGroupOperationPublishCallback(callback), kickoffGroupMemberTopic);
};

void (*quitGroup)(const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback)
= [](const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback) {
    QuitGroupRequest request;
    request.set_group_id(groupId);
    
    request.mutable_notify_content()->set_type((ContentType)notifyContentType);
    request.mutable_notify_content()->set_searchable_content(notifySearchableContent);
    request.mutable_notify_content()->set_push_content(notifyPushContent);
    request.mutable_notify_content()->set_data((void *)notifyData, notifyDataLen);
    
    publishTask(request, new GeneralGroupOperationPublishCallback(callback), quitGroupTopic);
};

void (*dismissGroup)(const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback)
= [](const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback) {
    DismissGroupRequest request;
    request.set_group_id(groupId);
    
    request.mutable_notify_content()->set_type((ContentType)notifyContentType);
    request.mutable_notify_content()->set_searchable_content(notifySearchableContent);
    request.mutable_notify_content()->set_push_content(notifyPushContent);
    request.mutable_notify_content()->set_data((void *)notifyData, notifyDataLen);
    
    publishTask(request, new GeneralGroupOperationPublishCallback(callback), dismissGroupTopic);

};
    class GetGroupInfoPublishCallback : public MQTTPublishCallback {
    public:
        GetGroupInfoPublishCallback(GetGroupInfoCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetGroupInfoCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            PullGroupInfoResult result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<TGroupInfo> retList;
                
                for (::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >::const_iterator it = result.info().begin(); it != result.info().end(); it++) {
                    const ::mars::stn::GroupInfo &info = *it;
                    TGroupInfo tInfo;
                    tInfo.target = info.target_id();
                    tInfo.name = info.name();
                    tInfo.portrait = info.portrait();
                    tInfo.owner = info.owner();
                    tInfo.extraData = new unsigned char[info.extra().length()];
                    memcpy(tInfo.extraData, info.extra().c_str(), info.extra().length());
                    tInfo.extraLen = info.extra().length();
                    retList.push_back(tInfo);
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
        virtual ~GetGroupInfoPublishCallback() {
            
        }
    };

void (*getGroupInfo)(const std::list<std::string> &groupIdList, GetGroupInfoCallback *callback)
= [](const std::list<std::string> &groupIdList, GetGroupInfoCallback *callback) {
    IDListBuf listBuf;
    listBuf.mutable_id()->Reserve((int)groupIdList.size());
    for (std::list<std::string>::const_iterator it = groupIdList.begin(); it != groupIdList.end(); it++) {
        listBuf.mutable_id()->AddAllocated(new std::string(*it));
    }
    
    publishTask(listBuf, new GetGroupInfoPublishCallback(callback), getGroupInfoTopic);
};

void (*modifyGroupInfo)(const std::string &groupId, const TGroupInfo &groupInfo, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback)
= [](const std::string &groupId, const TGroupInfo &groupInfo, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback) {
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
    if (groupInfo.extraData != NULL) {
        request.mutable_group_info()->set_extra(groupInfo.extraData, groupInfo.extraLen);
    }
    
    request.mutable_notify_content()->set_type((ContentType)notifyContentType);
    request.mutable_notify_content()->set_searchable_content(notifySearchableContent);
    request.mutable_notify_content()->set_push_content(notifyPushContent);
    request.mutable_notify_content()->set_data((void *)notifyData, notifyDataLen);
    
    publishTask(request, new GeneralGroupOperationPublishCallback(callback), modifyGroupInfoTopic);
};
    class GetGroupMembersPublishCallback : public MQTTPublishCallback {
    public:
        GetGroupMembersPublishCallback(GetGroupMembersCallback *cb) : MQTTPublishCallback(), callback(cb) {}
        GetGroupMembersCallback *callback;
        void onSuccess(const unsigned char* data, size_t len) {
            
            PullGroupMemberResult result;
            if(result.ParsePartialFromArray(data, (int)len)) {
                std::list<std::string> retList;
                
                for (::google::protobuf::RepeatedPtrField< ::std::string>::const_iterator it = result.member().begin(); it != result.member().end(); it++) {
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
        virtual ~GetGroupMembersPublishCallback() {
            
        }
    };
void (*getGroupMembers)(const std::string &groupId, GetGroupMembersCallback *callback)
= [](const std::string &groupId, GetGroupMembersCallback *callback) {
    IDBuf idBuf;
    idBuf.set_id(groupId);
    
    publishTask(idBuf, new GetGroupMembersPublishCallback(callback), getGroupMemberTopic);
};
    
    
#endif

}
}
