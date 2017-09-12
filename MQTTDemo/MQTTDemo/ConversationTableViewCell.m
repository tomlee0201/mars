//
//  ConversationTableViewCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "Utilities.h"

@implementation ConversationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setInfo:(ConversationInfo *)info {
    _info = info;
    if (info.unreadCount == 0) {
        self.bubbleView.hidden = YES;
    } else {
        self.bubbleView.hidden = NO;
        [self.bubbleView setBubbleTipNumber:info.unreadCount];
        self.bubbleView.isShowNotificationNumber = YES;
    }
    
    self.targetView.text = info.conversation.target;
    self.digestView.text = info.lastMessage.content.digest;
    self.potraitView.layer.cornerRadius = 3.f;
    
    self.timeView.text = [Utilities formatTimeLabel:info.timestamp];
}

- (BubbleTipView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[BubbleTipView alloc] initWithParentView:self.contentView];
        _bubbleView.hidden = YES;
    }
    return _bubbleView;
}
@end
