//
//  GroupInfo.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/16.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //member can add quit change group name and portrait, owner can do all the operations
    GroupType_Normal = 0,
    //every member can add quit change group name and portrait, no one can kickoff others
    GroupType_Free = 1,
    //member can only quit, owner can do all the operations
    GroupType_Restricted = 2,
} GroupType;

@interface GroupInfo : NSObject
@property (nonatomic, assign)GroupType type;
@property (nonatomic, strong)NSString *target;
@property (nonatomic, assign)int line;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *portrait;
@property (nonatomic, strong)NSString *owner;
@property (nonatomic, strong)NSData *extra;
@end
