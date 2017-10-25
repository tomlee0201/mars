//
//  ContactListViewController.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/7.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactSelectDelegate <NSObject>
- (void)didSelectContact:(NSArray<NSString *> *)contacts;
@end

@interface ContactListViewController : UIViewController
@property (nonatomic, assign)BOOL selectContact;
@property (nonatomic, assign)BOOL multiSelect;
@property (nonatomic, weak)id<ContactSelectDelegate> delegate;
@end
