//
//  GroupTableViewCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/13.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "SDWebImage.h"

@interface GroupTableViewCell()
@property (strong, nonatomic) UIImageView *portrait;
@property (strong, nonatomic) UILabel *name;

@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)portrait {
    if (!_portrait) {
        _portrait = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
        [self.contentView addSubview:_portrait];
    }
    return _portrait;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(48, 8, [UIScreen mainScreen].bounds.size.width - 56, 24)];
        [self.contentView addSubview:_name];
    }
    return _name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGroupInfo:(GroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    if (groupInfo.name.length == 0) {
        self.name.text = [NSString stringWithFormat:@"Group<%@>", groupInfo.target];
    } else {
        self.name.text = groupInfo.name;
    }
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:groupInfo.portrait] placeholderImage:[UIImage imageNamed:@"GroupChat"]];
}
@end
