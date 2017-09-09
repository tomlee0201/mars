//
//  MessageViewController.h
//  MQTTDemo
//
//  Created by Tom Lee on 2017/8/31.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *extendedBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (nonatomic, strong)Conversation *conversation;
@end
