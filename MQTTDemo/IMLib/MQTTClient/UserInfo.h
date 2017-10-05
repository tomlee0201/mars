//
//  UserInfo.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *displayName;
@property (nonatomic, strong)NSString *portrait;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *company;
@property (nonatomic, strong)NSString *social;
@property (nonatomic, strong)NSString *extra;
@property (nonatomic, assign)long long updateDt;
@end
