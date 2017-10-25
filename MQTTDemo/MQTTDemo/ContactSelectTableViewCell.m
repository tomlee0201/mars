//
//  ContactSelectTableViewCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/25.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ContactSelectTableViewCell.h"
#import "IMService.h"
#import "SDWebImage.h"

@interface ContactSelectTableViewCell()
@property(nonatomic, strong)UIImageView *checkImageView;
@end

@implementation ContactSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 44, 4, 40, 40)];
        [self.contentView addSubview:_checkImageView];
    }
    return _checkImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (self.multiSelect) {
        if (checked) {
            self.checkImageView.image = [UIImage imageNamed:@"multi_selected"];
        } else {
            self.checkImageView.image = [UIImage imageNamed:@"multi_unselected"];
        }
    } else {
        if (checked) {
            self.checkImageView.image = [UIImage imageNamed:@"single_selected"];
        } else {
            self.checkImageView.image = [UIImage imageNamed:@"single_unselected"];
        }
    }
}
- (void)setMultiSelect:(BOOL)multiSelect {
    _multiSelect = multiSelect;
}

- (void)setFriendUid:(NSString *)friendUid {
    _friendUid = friendUid;
    UserInfo *friendInfo = [[IMService sharedIMService] getUserInfo:friendUid refresh:NO];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:friendInfo.portrait]];
    self.textLabel.text = friendInfo.displayName;
}
@end
