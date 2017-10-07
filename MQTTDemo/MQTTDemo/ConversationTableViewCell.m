//
//  ConversationTableViewCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "Utilities.h"
#import "IMService.h"
#import "SDWebImage.h"
#import "NetworkService.h"


@implementation ConversationTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
  
- (void)onUserInfoUpdated:(NSNotification *)notification {
  UserInfo *userInfo = notification.userInfo[@"userInfo"];
  if (self.info.conversation.type == Single_Type && [self.info.conversation.target isEqualToString:userInfo.userId]) {
    [self updateUserInfo:userInfo];
  }
}

- (void)onGroupInfoUpdated:(NSNotification *)notification {
  GroupInfo *groupInfo = notification.userInfo[@"groupInfo"];
    if (self.info.conversation.type == Group_Type && [self.info.conversation.target isEqualToString:groupInfo.target]) {
      [self updateGroupInfo:groupInfo];
    }
}
  
- (void)updateUserInfo:(UserInfo *)userInfo {
  [self.potraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.portrait] placeholderImage: [UIImage imageNamed:@"PersonalChat"]];
  
  if(userInfo.displayName.length > 0) {
    self.targetView.text = userInfo.displayName;
  } else {
    self.targetView.text = [NSString stringWithFormat:@"user<%@>", self.info.conversation.target];
  }
}
  
- (void)updateGroupInfo:(GroupInfo *)groupInfo {
  [self.potraitView sd_setImageWithURL:[NSURL URLWithString:groupInfo.portrait] placeholderImage:[UIImage imageNamed:@"GroupChat"]];
  
  if(groupInfo.name.length > 0) {
    self.targetView.text = groupInfo.name;
  } else {
    self.targetView.text = [NSString stringWithFormat:@"group<%@>", self.info.conversation.target];
  }
}
  
- (void)setInfo:(ConversationInfo *)info {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
    _info = info;
    if (info.unreadCount == 0) {
        self.bubbleView.hidden = YES;
    } else {
        self.bubbleView.hidden = NO;
        [self.bubbleView setBubbleTipNumber:info.unreadCount];
        self.bubbleView.isShowNotificationNumber = YES;
    }
  
    if(info.conversation.type == Single_Type) {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoUpdated:) name:kUserInfoUpdated object:info.conversation.target];
      
      
        UserInfo *userInfo = [[IMService sharedIMService] getUserInfo:info.conversation.target refresh:NO];
      if(userInfo.userId.length == 0) {
        userInfo = [[UserInfo alloc] init];
        userInfo.userId = info.conversation.target;
      }
      [self updateUserInfo:userInfo];
    } else if (info.conversation.type == Group_Type) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGroupInfoUpdated:) name:kGroupInfoUpdated object:info.conversation.target];
      
        GroupInfo *groupInfo = [[IMService sharedIMService] getGroupInfo:info.conversation.target refresh:NO];
      if(groupInfo.target.length == 0) {
        groupInfo = [[GroupInfo alloc] init];
        groupInfo.target = info.conversation.target;
      }
      [self updateGroupInfo:groupInfo];
    } else {
        self.targetView.text = [NSString stringWithFormat:@"chatroom<%@>", info.conversation.target];
    }
    
    self.digestView.text = info.lastMessage.content.digest;
    self.potraitView.layer.cornerRadius = 3.f;
    
    self.timeView.text = [Utilities formatTimeLabel:info.timestamp];
    
    if (info.isTop) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (BubbleTipView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[BubbleTipView alloc] initWithParentView:self.contentView];
        _bubbleView.hidden = YES;
    }
    return _bubbleView;
}
  
-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
