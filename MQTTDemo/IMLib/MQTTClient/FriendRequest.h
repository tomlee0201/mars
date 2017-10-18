//
//  FriendRequest.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/17.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendRequest : NSObject
@property(nonatomic, assign)int direction;

@property(nonatomic, strong)NSString *target;
@property(nonatomic, strong)NSString *reason;
@property(nonatomic, assign)int status;
@property(nonatomic, assign)int readStatus;
@property(nonatomic, assign)int64_t timestamp;
@end
