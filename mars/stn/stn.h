// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.


/*
 ============================================================================
 Name       : stn.h
 Author     : yerungui
 Created on : 2012-7-18
 ============================================================================
 */

#ifndef NETWORK_SRC_NET_COMM_H_
#define NETWORK_SRC_NET_COMM_H_

#include <stdint.h>

#include <string>
#include <vector>
#include <list>

#include "mars/comm/autobuffer.h"

namespace mars{
    namespace stn{

#define NOOP_CMDID 6
#define SIGNALKEEP_CMDID 243
#define PUSH_DATA_TASKID 0
#define MQTT_CONNECT_CMDID 10
#define MQTT_SEND_OUT_CMDID 11
#define MQTT_DISCONNECT_CMDID 12
#define MQTT_SUBSCRIBE_CMDID 13
#define MQTT_UNSUBSCRIBE_CMDID 14
#define MQTT_PUBACK_CMDID 15

        
#define UPLOAD_SEND_OUT_CMDID 20
        
      typedef enum : int32_t {
        ChannelType_ShortConn = 1,
        ChannelType_LongConn = 2,
        ChannelType_All = 3
      } ChannelType;
      
      typedef enum : int {
        MQTT_MSG_CONNECT = 1<<4,
        MQTT_MSG_CONNACK = 2<<4,
        MQTT_MSG_PUBLISH = 3<<4,
        MQTT_MSG_PUBACK = 4<<4,
        MQTT_MSG_PUBREC = 5<<4,
        MQTT_MSG_PUBREL = 6<<4,
        MQTT_MSG_PUBCOMP = 7<<4,
        MQTT_MSG_SUBSCRIBE = 8<<4,
        MQTT_MSG_SUBACK = 9<<4,
        MQTT_MSG_UNSUBSCRIBE = 10<<4,
        MQTT_MSG_UNSUBACK = 11<<4,
        MQTT_MSG_PINGREQ = 12<<4,
        MQTT_MSG_PINGRESP = 13<<4,
        MQTT_MSG_DISCONNECT = 14<<4
      } MQTT_MSG_TYPE;
      
      
struct TaskProfile;
struct DnsProfile;
        class TGroupInfo {
        public:
            TGroupInfo() : extraData(NULL), type(0), extraLen(NULL){}
            std::string target;
            std::string name;
            std::string portrait;
            std::string owner;
            int type;
            unsigned char *extraData;
            size_t extraLen;
            virtual ~TGroupInfo(){if(extraData != NULL) {delete [] extraData; extraData = NULL; extraLen = 0;}}
        };
        
        class TMessageContent {
        public:
            TMessageContent() : data(NULL), type(0), dataLen(NULL){}
            TMessageContent(const TMessageContent &c) : type(c.type), dataLen(c.dataLen), searchableContent(c.searchableContent), pushContent(c.pushContent) {
                if(dataLen > 0) {
                    data = new unsigned char[dataLen];
                    memcpy(data, c.data, dataLen);
                } else {
                    data = NULL;
                }
            }
            TMessageContent operator=(const TMessageContent &c) {
                type = c.type;
                searchableContent = c.searchableContent;
                pushContent = c.pushContent;
                dataLen = c.dataLen;
                if(dataLen > 0) {
                    data = new unsigned char[dataLen];
                    memcpy(data, c.data, dataLen);
                } else {
                    data = NULL;
                }
                return *this;
            }
            int type;
            std::string searchableContent;
            std::string pushContent;
            unsigned char *data;
            size_t dataLen;
            virtual ~TMessageContent(){
                if(data != NULL) {
                    delete [] data;
                    data = NULL;
                    dataLen = 0;
                }
            }
        };
        
        typedef enum {
            Message_Status_Sending,
            Message_Status_Sent,
            Message_Status_Send_Failure,
            Message_Status_Unread,
            Message_Status_Readed,
            Message_Status_Listened,
            Message_Status_Downloaded,
        } MessageStatus;
        
        class TMessage {
        public:
            TMessage() : conversationType(0) {}
            
            int conversationType;
            
            std::string target;
            std::string from;
            TMessageContent content;
            long messageId;
            int direction;
            MessageStatus status;
            int64_t messageUid;
            int64_t timestamp;
            virtual ~TMessage(){}
        };
        
        class TConversation {
        public:
            TConversation() : conversationType(0) {}
            int conversationType;
            std::string target;
            TMessage lastMessage;
            int64_t timestamp;
            std::string draft;
            int unreadCount;
            bool isTop;
            virtual ~TConversation(){}
        };
        
      class MQTTGeneralCallback {
      public:
        virtual void onSuccess() = 0;
        virtual void onFalure(int errorCode) = 0;
      };
      
      class MQTTPublishCallback {
      public:
        virtual void onSuccess(const unsigned char* data, size_t len) = 0;
        virtual void onFalure(int errorCode) = 0;
      };
      
    class SendMessageCallback {
    public:
        virtual void onPrepared(long messageId) = 0;
        virtual void onSuccess(long messageUid, long long timestamp) = 0;
        virtual void onFalure(int errorCode) = 0;
    };

    class CreateGroupCallback {
    public:
        virtual void onSuccess(std::string groupId) = 0;
        virtual void onFalure(int errorCode) = 0;
    };
        
    class GeneralGroupOperationCallback {
    public:
        virtual void onSuccess() = 0;
        virtual void onFalure(int errorCode) = 0;
    };
    class GetGroupInfoCallback {
    public:
        virtual void onSuccess(std::list<TGroupInfo> groupInfoList) = 0;
        virtual void onFalure(int errorCode) = 0;
    };
    class GetGroupMembersCallback {
    public:
        virtual void onSuccess(std::list<std::string> groupMemberList) = 0;
        virtual void onFalure(int errorCode) = 0;
    };



class Task {
public:
    //channel type
    static const int kChannelShort = 0x1;
    static const int kChannelLong = 0x2;
    static const int kChannelBoth = 0x3;
    
    static const int kChannelNormalStrategy = 0;
    static const int kChannelFastStrategy = 1;
    static const int kChannelDisasterRecoveryStategy = 2;
    
    static const int kTaskPriorityHighest = 0;
    static const int kTaskPriority0 = 0;
    static const int kTaskPriority1 = 1;
    static const int kTaskPriority2 = 2;
    static const int kTaskPriority3 = 3;
    static const int kTaskPriorityNormal = 3;
    static const int kTaskPriority4 = 4;
    static const int kTaskPriority5 = 5;
    static const int kTaskPriorityLowest = 5;
    
    static const uint32_t kInvalidTaskID = 0;
    static const uint32_t kNoopTaskID = 0xFFFFFFFF;
    static const uint32_t kLongLinkIdentifyCheckerTaskID = 0xFFFFFFFE;
    static const uint32_t kSignallingKeeperTaskID = 0xFFFFFFFD;
    static const uint32_t kDisconnectTaskId = 0xFFFFFFFC;
    
    
    Task();
    Task(uint32_t _taskid);

    //require
    uint32_t       taskid;
    uint32_t       cmdid;
    uint64_t       channel_id;
    int32_t        channel_select;
    std::string    cgi;    // user

    //optional
    bool    send_only;  // user
    bool    need_authed;  // user
    bool    limit_flow;  // user
    bool    limit_frequency;  // user
    
    bool        network_status_sensitive;  // user
    int32_t     channel_strategy;
    int32_t     priority;  // user
    
    int32_t     retry_count;  // user
    int32_t     server_process_cost;  // user
    int32_t     total_timetout;  // user ms
    
    void*       user_context;  // user
    std::string report_arg;  // user for cgi report
    
    std::vector<std::string> shortlink_host_list;
    virtual ~Task() {}
};
        class UploadTask : public Task {
        public:
            UploadTask(const std::string &data);
        public:
            std::string mData;
            virtual ~UploadTask() {}
        };

      class MQTTTask : public Task {
      protected:
        MQTTTask(MQTT_MSG_TYPE type);
      public:
        const MQTT_MSG_TYPE type;
        std::string topic;
        virtual ~MQTTTask() {}
      };
      
      class MQTTPublishTask : public MQTTTask {
      public:
        MQTTPublishTask(MQTTPublishCallback *callback);
        unsigned char* body;
        size_t length;
        MQTTPublishCallback *m_callback;
        virtual ~MQTTPublishTask() ;
      };
      
      class MQTTSubscribeTask : public MQTTTask {
      public:
        MQTTSubscribeTask(MQTTGeneralCallback *callback);
        MQTTGeneralCallback *m_callback;
        virtual ~MQTTSubscribeTask() {}
      };
      
      class MQTTUnsubscribeTask : public MQTTTask {
      public:
        MQTTUnsubscribeTask(MQTTGeneralCallback *callback);
        MQTTGeneralCallback *m_callback;
        virtual ~MQTTUnsubscribeTask() {}
      };
      
      class MQTTPubAckTask : public MQTTTask {
      public:
        MQTTPubAckTask(uint16_t messageId);
        virtual ~MQTTPubAckTask() {}
      };
      
      class MQTTDisconnectTask : public MQTTTask {
      public:
        MQTTDisconnectTask();
        virtual ~MQTTDisconnectTask() {}
      };
      
      enum ConnectionStatus {
        kConnectionStatusRejected = -3,
        kConnectionStatusLogout = -2,
        kConnectionStatusUnconnected = -1,
        kConnectionStatusConnectiong = 0,
        kConnectionStatusConnected = 1
      };
      
      
      
      class ConnectionStatusCallback {
      public:
        virtual void onConnectionStatusChanged(ConnectionStatus connectionStatus) = 0;
      };
      
      class ReceiveMessageCallback {
      public:
        virtual void onReceiveMessage(const std::list<TMessage> &messageList, bool hasMore) = 0;
      };
      
        
enum TaskFailHandleType {
	kTaskFailHandleNormal = 0,
	kTaskFailHandleNoError = 0,
    
	kTaskFailHandleDefault = -1,
	kTaskFailHandleRetryAllTasks = -12,
	kTaskFailHandleSessionTimeout = -13,
    
	kTaskFailHandleTaskEnd = -14,
	kTaskFailHandleTaskTimeout = -15,
};
        
//error type
enum ErrCmdType {
	kEctOK = 0,
	kEctFalse = 1,
	kEctDial = 2,
	kEctDns = 3,
	kEctSocket = 4,
	kEctHttp = 5,
	kEctNetMsgXP = 6,
	kEctEnDecode = 7,
	kEctServer = 8,
	kEctLocal = 9,
    kEctCanceld = 10,
};

//error code
enum {
	kEctLocalTaskTimeout = -1,
    kEctLocalTaskRetry = -2,
	kEctLocalStartTaskFail = -3,
	kEctLocalAntiAvalanche = -4,
	kEctLocalChannelSelect = -5,
	kEctLocalNoNet = -6,
    kEctLocalCancel = -7,
    kEctLocalClear = -8,
    kEctLocalReset = -9,
	kEctLocalTaskParam = -12,
	kEctLocalCgiFrequcencyLimit = -13,
	kEctLocalChannelID = -14,
    
};

// -600 ~ -500
enum {
    kEctLongFirstPkgTimeout = -500,
    kEctLongPkgPkgTimeout = -501,
    kEctLongReadWriteTimeout = -502,
    kEctLongTaskTimeout = -503,
};

// -600 ~ -500
enum {
    kEctHttpFirstPkgTimeout = -500,
    kEctHttpPkgPkgTimeout = -501,
    kEctHttpReadWriteTimeout = -502,
    kEctHttpTaskTimeout = -503,
};

// -20000 ~ -10000
enum {
    kEctSocketNetworkChange = -10086,
    kEctSocketMakeSocketPrepared = -10087,
    kEctSocketWritenWithNonBlock = -10088,
    kEctSocketReadOnce = -10089,
    kEctSocketShutdown = -10090,
    kEctSocketRecvErr = -10091,
    kEctSocketSendErr = -10092,

    kEctHttpSplitHttpHeadAndBody = -10194,
    kEctHttpParseStatusLine = -10195,

    kEctNetMsgXPHandleBufferErr = -10504,

    kEctDnsMakeSocketPrepared = -10606,
};


enum IdentifyMode {
    kCheckNow = 0,
    kCheckNext,
    kCheckNever
};
        
enum IPSourceType {
    kIPSourceNULL = 0,
    kIPSourceDebug,
    kIPSourceDNS,
    kIPSourceNewDns,
    kIPSourceProxy,
    kIPSourceBackup,
};

const char* const IPSourceTypeString[] = {
    "NullIP",
    "DebugIP",
    "DNSIP",
    "NewDNSIP",
    "ProxyIP",
    "BackupIP",
};

struct IPPortItem {
    std::string		str_ip;
    uint16_t 		port;
    IPSourceType 	source_type;
    std::string 	str_host;
};
      
extern void login(std::string &userName, std::string &passwd);
extern bool (*MakesureAuthed)();

//流量统计
extern void (*TrafficData)(ssize_t _send, ssize_t _recv);
        
//底层询问上层该host对应的ip列表
extern std::vector<std::string> (*OnNewDns)(const std::string& host);
//网络层收到push消息回调
extern void (*OnPush)(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend);
//底层获取task要发送的数据
extern bool (*Req2Buf)(uint32_t taskid, void* const user_context, AutoBuffer& outbuffer, AutoBuffer& extend, int& error_code, const int channel_select);
//底层回包返回给上层解析
extern int (*Buf2Resp)(uint32_t taskid, void* const user_context, const AutoBuffer& inbuffer, const AutoBuffer& extend, int& error_code, const int channel_select);
//任务执行结束
extern int  (*OnTaskEnd)(uint32_t taskid, void* const user_context, int error_type, int error_code);

//上报网络连接状态
extern void (*ReportConnectStatus)(int status, int longlink_status);
//长连信令校验 ECHECK_NOW = 0, ECHECK_NEVER = 1, ECHECK_NEXT = 2
extern int  (*GetLonglinkIdentifyCheckBuffer)(AutoBuffer& identify_buffer, AutoBuffer& buffer_hash, int32_t& cmdid);
//长连信令校验回包
extern bool (*OnLonglinkIdentifyResponse)(const AutoBuffer& response_buffer, const AutoBuffer& identify_buffer_hash);

extern void (*RequestSync)();


//底层询问上层http网络检查的域名列表
extern void (*RequestNetCheckShortLinkHosts)(std::vector<std::string>& _hostlist);
//底层向上层上报cgi执行结果
extern void (*ReportTaskProfile)(const TaskProfile& _task_profile);
//底层通知上层cgi命中限制
extern void (*ReportTaskLimited)(int _check_type, const Task& _task, unsigned int& _param);
//底层上报域名dns结果
extern void (*ReportDnsProfile)(const DnsProfile& _dns_profile);

      extern void setConnectionStatusCallback(ConnectionStatusCallback *callback);
      extern void setReceiveMessageCallback(ReceiveMessageCallback *callback);
      extern ConnectionStatus getConnectionStatus();
        
extern int (*sendMessage)(int conversationType, const std::string &target, int contentType, const std::string &searchableContent, const std::string &pushContent, const unsigned char *data, size_t dataLen, SendMessageCallback *callback, const unsigned char *mediaData, size_t mediaDataLen);
        
extern void (*createGroup)(const std::string &groupId, const std::string &groupName, const std::string &groupPortrait, const std::list<std::string> &groupMembers, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, CreateGroupCallback *callback);
        
extern void (*addMembers)(const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback);

extern void (*kickoffMembers)(const std::string &groupId, const std::list<std::string> &members, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback);
     
extern void (*quitGroup)(const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback);

extern void (*dismissGroup)(const std::string &groupId, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback);
  
extern void (*getGroupInfo)(const std::list<std::string> &groupIdList, GetGroupInfoCallback *callback);

extern void (*modifyGroupInfo)(const std::string &groupId, const TGroupInfo &groupInfo, int notifyContentType, const std::string &notifySearchableContent, const std::string &notifyPushContent, const unsigned char *notifyData, size_t notifyDataLen, GeneralGroupOperationCallback *callback);
        
extern void (*getGroupMembers)(const std::string &groupId, GetGroupMembersCallback *callback);

}}
#endif // NETWORK_SRC_NET_COMM_H_
