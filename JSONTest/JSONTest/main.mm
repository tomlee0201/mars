//
//  main.m
//  JSONTest
//
//  Created by Tao Li on 2017/10/8.
//  Copyright © 2017年 TomLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include <string>

using namespace std;
using namespace rapidjson;

#define ERROR_RETURN return -1

int main(int argc, const char * argv[]) {
    testJson();
    return 0;
}

int testJson() {
    string key = "{                        \
    \"code\": 0,             \
    \"msg\": \"success\",       \
    \"result\": {                   \
    \"keyword\": \"张\",            \
    \"page\": 0,                      \
    \"users\": [                        \
    {                             \
    \"userId\": \"user1\",           \
    \"name\": \"zhangsan\",              \
    \"displayName\": \"张三\",               \
    \"portrait\": \"http:7xqgbn.com1.z0.glb.clouddn.com/user1-1507346359_8727\",    \
    \"mobile\": \"10086\",                        \
    \"email\": \"zhangsan@example.com\",                  \
    \"address\": \"南国中路38号\",                         \
    \"company\": \"纵横世界大发展股份有限公司\",               \
    \"extra\": \"{\\\"title\\\":\\\"老总\\\"}\"                  \
    }                                                     \
    ]                                                 \
    }                                                           \
    }";
    
    
    Document d;
    d.Parse(key.c_str());
    
    if(d.HasParseError()) {
        ERROR_RETURN;
    }
    
    Value& s = d["code"];
    
    int code = s.GetInt();
    if(code != 0) {
        ERROR_RETURN;
    } else {
        s = d["result"];
        if(s.IsObject()) {
            s = s["users"];
            if (!s.IsArray()) {
                ERROR_RETURN;
            } else {
                for (int i = 0; i < s.Size(); i++) {
                    Value& user = s[i];
                    if(user.IsObject()) {
                        if (user.HasMember("userId") && user["userId"].IsString()) {
                            std::string userId = user["userId"].GetString();
                        }
                        
                        if (user.HasMember("name") && user["name"].IsString()) {
                            std::string name = user["name"].GetString();
                        }
                        
                        if (user.HasMember("displayName") && user["displayName"].IsString()) {
                            std::string displayName = user["displayName"].GetString();
                        }
                        
                        if (user.HasMember("portrait") && user["portrait"].IsString()) {
                            std::string portrait = user["portrait"].GetString();
                        }
                        
                        if (user.HasMember("mobile") && user["mobile"].IsString()) {
                            std::string mobile = user["mobile"].GetString();
                        }
                        
                        if (user.HasMember("email") && user["email"].IsString()) {
                            std::string email = user["email"].GetString();
                        }
                        
                        if (user.HasMember("address") && user["address"].IsString()) {
                            std::string address = user["address"].GetString();
                        }
                        
                        if (user.HasMember("company") && user["company"].IsString()) {
                            std::string company = user["company"].GetString();
                        }
                        
                        if (user.HasMember("extra") && user["extra"].IsString()) {
                            std::string extra = user["extra"].GetString();
                        }
                    }
                }
            }
        } else {
            ERROR_RETURN;
        }
    }

}
