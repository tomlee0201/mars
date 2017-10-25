//
//  FriendRequestTableViewCell.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/23.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendRequest.h"


@protocol FriendRequestTableViewCellDelegate <NSObject>
- (void)onAcceptBtn:(NSString *)targetUserId;
@end


@interface FriendRequestTableViewCell : UITableViewCell
@property (nonatomic, strong)FriendRequest *friendRequest;
@property (nonatomic, weak)id<FriendRequestTableViewCellDelegate> delegate;
@end
