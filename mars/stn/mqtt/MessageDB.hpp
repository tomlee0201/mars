//
//  MessageDB.hpp
//  stn
//
//  Created by Tao Li on 2017/8/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef MessageDB_hpp
#define MessageDB_hpp


#include <stdio.h>
#include "mars/app/app.h"
#include "mars/app/app_logic.h"
#include "mars/stn/stn.h"
namespace mars {
    namespace stn {
        class MessageDB {
            
        private:
            MessageDB();
            ~MessageDB();
            
        public:
            static MessageDB* Instance();
            long InsertMessage(TMessage &msg);
            bool UpdateMessageTimeline(int64_t timeline);
            int64_t GetMessageTimeline();
        private:
            static MessageDB* instance_;
        };
        
    }
}


#endif /* MessageDB_hpp */
