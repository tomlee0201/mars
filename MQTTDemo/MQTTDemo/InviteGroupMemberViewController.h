//
//  InviteGroupMemberViewController.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/18.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteGroupMemberViewController : UIViewController
@property (nonatomic, strong)NSString *groupId;
@property (nonatomic, copy)void (^inviteMember)(NSString *groupId, NSArray<NSString *> *memberIds);
@end
