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

#include "shortlink_packer.h"
#include "mars/comm/http.h"
#include "mars/app/app.h"
#include <sstream>

using namespace http;
namespace mars { namespace stn {

static const std::string UploadBoundary = "--727f6ee7446cbf7263";
    
shortlink_tracker* (*shortlink_tracker::Create)()
=  []() { return new shortlink_tracker; };

void (*shortlink_pack)(const std::string& _url, const std::map<std::string, std::string>& _headers, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _out_buff, shortlink_tracker* _tracker)
= [](const std::string& _url, const std::map<std::string, std::string>& _headers, const AutoBuffer& _body, const AutoBuffer& _extension, AutoBuffer& _out_buff, shortlink_tracker* _tracker) {

	Builder req_builder(kRequest);
	req_builder.Request().Method(RequestLine::kPost);
	req_builder.Request().Version(kVersion_1_1);

	req_builder.Fields().HeaderFiled(HeaderFields::MakeAcceptAll());
	req_builder.Fields().HeaderFiled(HeaderFields::KStringUserAgent, HeaderFields::KStringMicroMessenger);
	req_builder.Fields().HeaderFiled(HeaderFields::MakeCacheControlNoCache());
	req_builder.Fields().HeaderFiled(std::make_pair("Content-Type", "multipart/form-data; boundary="+UploadBoundary));
	req_builder.Fields().HeaderFiled(HeaderFields::MakeConnectionClose());

    unsigned char mediaType = *((const unsigned char  *)_extension.Ptr());
    
    std::string uploadToken((const char *)_extension.Ptr() + 1, _extension.Length()-1);
    std::string fileName;
    std::stringstream ss;
    ss << mars::app::GetUserName();
    ss << "-";
    ss << time(NULL);
    ss << "_";
    ss << rand()%10000;
    ss >> fileName;
    
    std::string mimeType;
    if (mediaType == 3) {
        mimeType = "image_jpeg";
    } else if(mediaType == 2) {
        mimeType = "audio_amr";
    }
    
    std::string firstBody = "--" + UploadBoundary + "\r\nContent-Disposition: form-data; name=\"token\"\r\n\r\n"
    + uploadToken + "\r\n--" + UploadBoundary + "\r\nContent-Disposition: form-data; name=\"key\"\r\n\r\n" + fileName + "\r\n--"
    + UploadBoundary + "\r\nContent-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\nContent-Type: " + mimeType + "\r\n\r\n";
    
    std::string lastBody =  "\r\n--" + UploadBoundary + "--";
    
    char len_str[32] = {0};
	snprintf(len_str, sizeof(len_str), "%u", (unsigned int)(_body.Length() + firstBody.length() + lastBody.length()));
	req_builder.Fields().HeaderFiled(HeaderFields::KStringContentLength, len_str);

	for (std::map<std::string, std::string>::const_iterator iter = _headers.begin(); iter != _headers.end(); ++iter) {
		req_builder.Fields().HeaderFiled(iter->first.c_str(), iter->second.c_str());
	}

	req_builder.Request().Url(_url);
	req_builder.HeaderToBuffer(_out_buff);
    
     
    _out_buff.Write(firstBody.c_str(), firstBody.length());
	_out_buff.Write(_body.Ptr(), _body.Length());
    _out_buff.Write(lastBody.c_str(), lastBody.length());
};

}}

