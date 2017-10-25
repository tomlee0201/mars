//
//  FriendRequestTableViewCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/23.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "FriendRequestTableViewCell.h"
#import "SDWebImage.h"
#import "IMService.h"
#import "UserInfo.h"


@interface FriendRequestTableViewCell()
@property (nonatomic, strong)UIImageView *portraitView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *reasonLabel;
@property (nonatomic, strong)UIButton *acceptBtn;
@end

@implementation FriendRequestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubViews];
}

- (void)initSubViews {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 48, 48)];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 4, self.contentView.bounds.size.width - 128, 21)];
    self.reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 29, self.contentView.bounds.size.width - 128, 15)];
    self.reasonLabel.font = [UIFont systemFontOfSize:15];
    self.reasonLabel.textColor = [UIColor grayColor];
    
    self.acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width - 68, 12, 64, 32)];
    [self.acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self.acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.portraitView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.reasonLabel];
    [self.contentView addSubview:self.acceptBtn];
    
    [self.acceptBtn addTarget:self action:@selector(onAddBtn:) forControlEvents:UIControlEventTouchDown];
}

- (void)onAddBtn:(id)sender {
    [self.delegate onAcceptBtn:self.friendRequest.target];
}

- (void)setFriendRequest:(FriendRequest *)friendRequest {
    _friendRequest = friendRequest;
    UserInfo *userInfo = [[IMService sharedIMService] getUserInfo:friendRequest.target refresh:NO];
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.portrait]];
    self.nameLabel.text = userInfo.displayName;
    self.reasonLabel.text = friendRequest.reason;
    
    if (friendRequest.status == 0) {
        [self.acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
        [self.acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.acceptBtn setEnabled:YES];
    } else if (friendRequest.status == 1) {
        [self.acceptBtn setTitle:@"已同意" forState:UIControlStateNormal];
        [self.acceptBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.acceptBtn setEnabled:NO];
    } else if (friendRequest.status == 2) {
        [self.acceptBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [self.acceptBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.acceptBtn setEnabled:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
