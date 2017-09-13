//
//  MessageCell.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MessageCell.h"
#import "Utilities.h"

#define Portrait_Size 48
#define Name_Label_Height  18
#define Name_Client_Padding  6
#define Portrait_Padding_Left 4
#define Portrait_Padding_Right 4
#define Portrait_Padding_Buttom 4

#define Client_Arad_Buttom_Padding 8

#define Client_Bubble_Top_Padding  6
#define Client_Bubble_Bottom_Padding  4

#define Bubble_Padding_Arraw 15
#define Bubble_Padding_Another_Side 5

@interface MessageCell ()
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong)UIImageView *failureView;
@property (nonatomic, strong)UIImageView *maskView;
@end

@implementation MessageCell
+ (CGFloat)clientAreaWidth {
  return [MessageCell bubbleWidth] - Bubble_Padding_Arraw - Bubble_Padding_Another_Side;
}

+ (CGFloat)bubbleWidth {
    return ([UIScreen mainScreen].bounds.size.width - Portrait_Size - Portrait_Padding_Left - Portrait_Padding_Right) * 0.7;
}

+ (CGSize)sizeForCell:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
  CGFloat height = [super hightForTimeLabel:msgModel];
  CGFloat portraitSize = Portrait_Size;
  CGFloat nameLabelHeight = Name_Label_Height + Name_Client_Padding;
  CGFloat clientAreaWidth = [self clientAreaWidth];
  
  CGSize clientArea = [self sizeForClientArea:msgModel withViewWidth:clientAreaWidth];
  CGFloat nameAndClientHeight = clientArea.height;
  if (msgModel.showNameLabel) {
    nameAndClientHeight += nameLabelHeight;
  }
    
    nameAndClientHeight += Client_Bubble_Top_Padding;
    nameAndClientHeight += Client_Bubble_Bottom_Padding;
    
  if (portraitSize + Portrait_Padding_Buttom > nameAndClientHeight) {
    height += portraitSize + Portrait_Padding_Buttom;
  } else {
    height += nameAndClientHeight;
  }
  height += Client_Arad_Buttom_Padding;   //buttom padding
  return CGSizeMake(width, height);
}

+ (CGSize)sizeForClientArea:(MessageModel *)msgModel withViewWidth:(CGFloat)width {
  return CGSizeZero;
}

- (void)updateStatus {
    if (self.model.message.direction == MessageDirection_Send) {
        if (self.model.message.status == Message_Status_Sending) {
            CGRect frame = self.bubbleView.frame;
            frame.origin.x -= 24;
            frame.origin.y = frame.origin.y + frame.size.height - 24;
            frame.size.width = 20;
            frame.size.height = 20;
            self.activityIndicatorView.hidden = NO;
            self.activityIndicatorView.frame = frame;
            [self.activityIndicatorView startAnimating];
        } else {
            [_activityIndicatorView stopAnimating];
            _activityIndicatorView.hidden = YES;
        }
        
        if (self.model.message.status == Message_Status_Send_Failure) {
            CGRect frame = self.bubbleView.frame;
            frame.origin.x -= 24;
            frame.origin.y = frame.origin.y + frame.size.height - 24;
            frame.size.width = 20;
            frame.size.height = 20;
            self.failureView.frame = frame;
            self.failureView.hidden = NO;
        } else {
            _failureView.hidden = YES;
        }
    } else {
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.hidden = YES;
        _failureView.hidden = YES;
    }
}
-(void)onStatusChanged:(NSNotification *)notification {
    MessageStatus newStatus = (MessageStatus)[[notification.userInfo objectForKey:@"status"] integerValue];
    self.model.message.status = newStatus;
    [self updateStatus];
}

- (void)setModel:(MessageModel *)model {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged:) name:@"kMessageStatusChanged" object:
    @(model.message.messageId)];
  [super setModel:model];
    
    if (model.message.conversation == Single_Type) {
        self.portraitView.image = [UIImage imageNamed:@"PersonalChat"];
    } else {
        self.portraitView.image = [UIImage imageNamed:@"GroupChat"];
    }
    
  if (model.message.direction == MessageDirection_Send) {
    CGFloat top = [MessageCellBase hightForTimeLabel:model];
    CGRect frame = self.frame;
    self.portraitView.frame = CGRectMake(frame.size.width - Portrait_Size - Portrait_Padding_Right, top, Portrait_Size, Portrait_Size);
    if (model.showNameLabel) {
      self.nameLabel.frame = CGRectMake(frame.size.width - Portrait_Size - Portrait_Padding_Right -Portrait_Padding_Left - 200, top, 200, Name_Label_Height);
      self.nameLabel.hidden = NO;
      self.nameLabel.textAlignment = NSTextAlignmentRight;
      self.nameLabel.text = model.message.fromUser;
    } else {
      self.nameLabel.hidden = YES;
    }
      
    CGSize size = [self.class sizeForClientArea:model withViewWidth:[MessageCell clientAreaWidth]];
      self.bubbleView.image = [UIImage imageNamed:@"sent_msg_background"];
      self.bubbleView.frame = CGRectMake(frame.size.width - Portrait_Size - Portrait_Padding_Right -Portrait_Padding_Left - size.width - Bubble_Padding_Arraw - Bubble_Padding_Another_Side, top + Name_Client_Padding, size.width + Bubble_Padding_Arraw + Bubble_Padding_Another_Side, size.height + Client_Bubble_Top_Padding + Client_Bubble_Bottom_Padding);
    self.contentArea.frame = CGRectMake(Bubble_Padding_Another_Side, Client_Bubble_Top_Padding, size.width, size.height);
      
      UIImage *image = self.bubbleView.image;
      self.bubbleView.image = [self.bubbleView.image
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,image.size.height * 0.2, image.size.width * 0.8)];
  } else {
    CGFloat top = [MessageCellBase hightForTimeLabel:model];
    self.portraitView.frame = CGRectMake(Portrait_Padding_Left, top, Portrait_Size, Portrait_Size);
    if (model.showNameLabel) {
      self.nameLabel.frame = CGRectMake(Portrait_Padding_Left + Portrait_Size + Portrait_Padding_Right, top, 200, Name_Label_Height);
      self.nameLabel.hidden = NO;
      self.nameLabel.textAlignment = NSTextAlignmentLeft;
      self.nameLabel.text = model.message.fromUser;
    } else {
      self.nameLabel.hidden = YES;
    }
      
    CGSize size = [self.class sizeForClientArea:model withViewWidth:[MessageCell clientAreaWidth]];
      self.bubbleView.image = [UIImage imageNamed:@"received_msg_background"];
      self.bubbleView.frame = CGRectMake(Portrait_Padding_Left + Portrait_Size + Portrait_Padding_Right, top + Name_Label_Height + Name_Client_Padding, size.width + Bubble_Padding_Arraw + Bubble_Padding_Another_Side, size.height + Client_Bubble_Top_Padding + Client_Bubble_Bottom_Padding);
    self.contentArea.frame = CGRectMake(Bubble_Padding_Arraw, Client_Bubble_Top_Padding, size.width, size.height);
      
      UIImage *image = self.bubbleView.image;
      self.bubbleView.image = [self.bubbleView.image
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                                      image.size.height * 0.2, image.size.width * 0.2)];
      
  }
    [self setMaskImage:self.bubbleView.image];
    [self updateStatus];
}

- (void)setMaskImage:(UIImage *)maskImage{
    if (_maskView == nil) {
        _maskView = [[UIImageView alloc] initWithImage:maskImage];
        
        _maskView.frame = self.bubbleView.bounds;
        self.bubbleView.layer.mask = _maskView.layer;
        self.bubbleView.layer.masksToBounds = YES;
    } else {
        _maskView.image = maskImage;
        _maskView.frame = self.bubbleView.bounds;
    }
}

- (UIImageView *)portraitView {
  if (!_portraitView) {
    _portraitView = [[UIImageView alloc] init];
    _portraitView.clipsToBounds = YES;
    _portraitView.layer.cornerRadius = 3.f;
    [_portraitView setImage:[UIImage imageNamed:@"PersonalChat"]];
    [self.contentView addSubview:_portraitView];
  }
  return _portraitView;
}

- (UILabel *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
  }
  return _nameLabel;
}

- (UIView *)contentArea {
  if (!_contentArea) {
    _contentArea = [[UIView alloc] init];
    [self.bubbleView addSubview:_contentArea];
  }
  return _contentArea;
}
- (UIImageView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc] init];
        [self.contentView addSubview:_bubbleView];
        [_bubbleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)]];
        [_bubbleView setUserInteractionEnabled:YES];
    }
    return _bubbleView;
}
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}
- (UIImageView *)failureView {
    if (!_failureView) {
        _failureView = [[UIImageView alloc] init];
        _failureView.image = [UIImage imageNamed:@"failure"];
        [self.contentView addSubview:_failureView];
    }
    return _failureView;
}
@end
