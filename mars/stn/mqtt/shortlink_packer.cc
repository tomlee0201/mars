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
 * shortlink_packer.cc
 *
 *  Created on: 2016-03-15
 *      Author: yanguoyue
 */

#include "mars/stn/proto/shortlink_packer.h"
#include "mars/comm/http.h"
#include "mars/app/app.h"
#include <sstream>

using namespace http;
namespace mars { namespace stn {

static const std::string UploadBoundary = "--727f6ee7446cbf7263";
    std::map<std::string, std::string> stringToMap(std::string &str)
    {
        std::map<std::string, std::string> out;
        while (!str.empty()) {
            long Keybegin = str.find("{\"");
            long keyend = str.find("\":\"");
            long valueend = str.find("\"}");
            
            if(Keybegin == -1 || keyend == -1 || valueend == -1)
                break;
            
            std::string key = str.substr(Keybegin + 2, keyend - Keybegin - 2);
            std::string value = str.substr(keyend + 3, valueend - keyend - 3);
            str = str.substr(valueend+2);
            out[key] = value;
        }
        return out;
    }
    
shortlink_tracker* (*shortlink_tracker::Create)()
=  []() { return new shortlink_tracker; };

void (*shortlink_pack)(const std::string& _url, const std::map<std::string, std::string>& _headers, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _out_buff, shortlink_tracker* _tracker)
= [](const std::string& _url, const std::map<std::string, std::string>& _headers, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _out_buff, shortlink_tracker* _tracker) {

	Builder req_builder(kRequest);
    
    std::string strMap((const char*)_extension.Ptr(), _extension.Length());
    std::map<std::string, std::string> parsedMap = stringToMap(strMap);
    std::string method = parsedMap["method"];
    
    if(method == "POST") {
        req_builder.Request().Method(RequestLine::kPost);
    } else if (method == "GET") {
        req_builder.Request().Method(RequestLine::kGet);
    } else if (method == "PUT") {
        req_builder.Request().Method(RequestLine::kPut);
    } else if (method == "DELETE") {
        req_builder.Request().Method(RequestLine::kDelete);
    } else {
        req_builder.Request().Method(RequestLine::kGet);
    }
    
	req_builder.Request().Version(kVersion_1_1);

	req_builder.Fields().HeaderFiled(HeaderFields::MakeAcceptAll());
	req_builder.Fields().HeaderFiled(HeaderFields::KStringUserAgent, HeaderFields::KStringMicroMessenger);
	req_builder.Fields().HeaderFiled(HeaderFields::MakeCacheControlNoCache());
	req_builder.Fields().HeaderFiled(HeaderFields::MakeConnectionClose());
    
    for(std::map<std::string, std::string>::iterator it = parsedMap.begin(); it != parsedMap.end(); ++it) {
        if(it->first != "method") {
            req_builder.Fields().HeaderFiled(it->first.c_str(), it->second.c_str());
        }
    }
	

	for (std::map<std::string, std::string>::const_iterator iter = _headers.begin(); iter != _headers.end(); ++iter) {
		req_builder.Fields().HeaderFiled(iter->first.c_str(), iter->second.c_str());
	}

	req_builder.Request().Url(_url);
	req_builder.HeaderToBuffer(_out_buff);
    
     
    _out_buff.Write(_body.Ptr(), _body.Length());
};

}}

