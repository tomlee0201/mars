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
 * longlink_packer.cc
 *
 *  Created on: 2012-7-18
 *      Author: yerungui, caoshaokun
 */

#include "longlink_packer.h"

#include <arpa/inet.h>

#ifdef __APPLE__
#include "mars/xlog/xlogger.h"
#else
#include "mars/comm/xlogger/xlogger.h"
#endif
#include "mars/comm/autobuffer.h"
#include "mars/stn/stn.h"
#include "libemqtt.h"

static uint32_t sg_client_version = 0;


/*

MQTT_MSG_CONNECT       -->    MQTT_CONNECT_CMDID
MQTT_MSG_CONNACK       <--    MQTT_CONNECT_CMDID
MQTT_MSG_PUBLISH       -->    MQTT_SEND_OUT_CMDID
MQTT_MSG_PUBLISH       <--    PUSH_DATA_TASKID
MQTT_MSG_PUBACK        -->    MQTT_SEND_OUT_CMDID
MQTT_MSG_PUBACK        <--    PUSH_DATA_TASKID
MQTT_MSG_PINGREQ       -->    NOOP_CMDID
MQTT_MSG_PINGRESP      <--    NOOP_CMDID
MQTT_MSG_DISCONNECT    -->    MQTT_DISCONNECT_CMDID
 
 MQTT_MSG_PUBREC        5<<4
 MQTT_MSG_PUBREL        6<<4
 MQTT_MSG_PUBCOMP       7<<4
 MQTT_MSG_SUBSCRIBE     8<<4
 MQTT_MSG_SUBACK        9<<4
 MQTT_MSG_UNSUBSCRIBE  10<<4
 MQTT_MSG_UNSUBACK     11<<4
 
 */


namespace mars {
namespace stn {
longlink_tracker* (*longlink_tracker::Create)()
= []() {
    return new longlink_tracker;
};
    
void SetClientVersion(uint32_t _client_version)  {
    sg_client_version = _client_version;
}



  
  
static int __unpack_test(const void* _packed, size_t _packed_len, uint32_t& _cmdid, uint32_t& _seq, size_t& _package_len, size_t& _body_len) {
  if (_packed_len < 2) {
    return LONGLINK_UNPACK_CONTINUE;
  }
  const unsigned char *data = ( unsigned char *)_packed;
  int packLen = *(data + 1);
  if (packLen + 2 < _packed_len) {
    return LONGLINK_UNPACK_CONTINUE;
  }

  _package_len = packLen + 2;
  _body_len = _packed_len;
  
      if (_package_len > 1024*1024) { return LONGLINK_UNPACK_FALSE; }
      if (_package_len > _packed_len) { return LONGLINK_UNPACK_CONTINUE; }
  

  switch (MQTTParseMessageType(( unsigned char *)_packed)) {
    case MQTT_MSG_CONNACK:
      _cmdid = MQTT_CONNECT_CMDID;
      _seq = Task::kLongLinkIdentifyCheckerTaskID;
      _body_len = _packed_len - 3;
      break;
      
    case MQTT_MSG_PUBLISH:
      _cmdid = PUSH_DATA_TASKID;
      _seq = 0;
      _body_len = _packed_len - 3;
      break;
    case MQTT_MSG_PUBACK:
      _cmdid = MQTT_SEND_OUT_CMDID;
      _seq = mqtt_parse_msg_id((const uint8_t*)_packed);
      _body_len = _packed_len - 3;
      break;
      
    case MQTT_MSG_PUBREC:
    case MQTT_MSG_PUBREL:
    case MQTT_MSG_PUBCOMP:
    case MQTT_MSG_SUBACK:
    case MQTT_MSG_UNSUBACK:
      //no available
      break;

    case MQTT_MSG_PINGRESP:
      _cmdid = NOOP_CMDID;
      _seq = Task::kNoopTaskID;
      break;
      
    case MQTT_MSG_SUBSCRIBE:
    case MQTT_MSG_UNSUBSCRIBE:
    case MQTT_MSG_PINGREQ:
    case MQTT_MSG_CONNECT:
    case MQTT_MSG_DISCONNECT:
      //can not receive
      break;
      
    default:
      break;
  }
  
  return LONGLINK_UNPACK_OK;
}

void (*longlink_pack)(uint32_t _cmdid, uint32_t _seq, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _packed, longlink_tracker* _tracker)
= [](uint32_t _cmdid, uint32_t _seq, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _packed, longlink_tracker* _tracker) {
  switch(_cmdid) {
    case NOOP_CMDID:
      mqtt_ping(_packed);
      break;
    case SIGNALKEEP_CMDID:
      break;
    case PUSH_DATA_TASKID:
      break;
    case MQTT_CONNECT_CMDID:
      mqtt_connect(_packed);
      break;
    case MQTT_SEND_OUT_CMDID:

      mqtt_publish_with_qos((char *)_extension.Ptr(), (char *)_body.Ptr(), 1, 1, _seq, _packed);
      break;
    case MQTT_DISCONNECT_CMDID:
      break;
  }
  _packed.Seek(0, AutoBuffer::ESeekStart);
};


int (*longlink_unpack)(const AutoBuffer& _packed, uint32_t& _cmdid, uint32_t& _seq, size_t& _package_len, AutoBuffer& _body, AutoBuffer& _extension, longlink_tracker* _tracker)
= [](const AutoBuffer& _packed, uint32_t& _cmdid, uint32_t& _seq, size_t& _package_len, AutoBuffer& _body, AutoBuffer& _extension, longlink_tracker* _tracker) {
   size_t body_len = 0;
   int ret = __unpack_test(_packed.Ptr(), _packed.Length(), _cmdid,  _seq, _package_len, body_len);
    
    if (LONGLINK_UNPACK_OK != ret) return ret;
    
    _body.Write(AutoBuffer::ESeekCur, _packed.Ptr(_package_len-body_len), body_len);
    
    return ret;
};


uint32_t (*longlink_noop_cmdid)()
= []() -> uint32_t {
    return NOOP_CMDID;
};

bool  (*longlink_noop_isresp)(uint32_t _taskid, uint32_t _cmdid, uint32_t _recv_seq, const AutoBuffer& _body, const AutoBuffer& _extend)
= [](uint32_t _taskid, uint32_t _cmdid, uint32_t _recv_seq, const AutoBuffer& _body, const AutoBuffer& _extend) {
    return Task::kNoopTaskID == _taskid && NOOP_CMDID == _cmdid;
};

uint32_t (*signal_keep_cmdid)()
= []() -> uint32_t {
    return SIGNALKEEP_CMDID;
};

void (*longlink_noop_req_body)(AutoBuffer& _body, AutoBuffer& _extend)
= [](AutoBuffer& _body, AutoBuffer& _extend) {
    
};
    
void (*longlink_noop_resp_body)(const AutoBuffer& _body, const AutoBuffer& _extend)
= [](const AutoBuffer& _body, const AutoBuffer& _extend) {
    
};

uint32_t (*longlink_noop_interval)()
= []() -> uint32_t {
	return 0;
};

bool (*longlink_complexconnect_need_verify)()
= []() {
    return false;
};

bool (*longlink_ispush)(uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend)
= [](uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
    return PUSH_DATA_TASKID == _taskid;
};
    
bool (*longlink_identify_isresp)(uint32_t _sent_seq, uint32_t _cmdid, uint32_t _recv_seq, const AutoBuffer& _body, const AutoBuffer& _extend)
= [](uint32_t _sent_seq, uint32_t _cmdid, uint32_t _recv_seq, const AutoBuffer& _body, const AutoBuffer& _extend) {
    return _sent_seq == _recv_seq && PUSH_DATA_TASKID != _sent_seq;
};

}
}
