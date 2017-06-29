//
//  PublishCallback.hpp
//  MQTTDemo
//
//  Created by Tao Li on 2017/6/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#ifndef PublishCallback_hpp
#define PublishCallback_hpp

#import <UIKit/UIKit.h>
#import <mars/stn/stn.h>

@protocol PublishDelegate  <NSObject>

@end

class PublishCallback : public mars::stn::MQTTPublishCallback {
public:
  virtual void onSuccess() {
    delete this;
  }
  virtual void onFalure(int errorCode) {
    delete this;
  }
};
#endif /* PublishCallback_hpp */
