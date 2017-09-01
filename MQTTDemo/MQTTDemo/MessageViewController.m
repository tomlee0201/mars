//
//  MessageViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/8/31.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "MessageViewController.h"
#import "NetworkService.h"

@interface MessageViewController () <UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *messageList;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.inputTextField.delegate = self;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  self.inputTextField.returnKeyType = UIReturnKeySend;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onResetKeyboard:)];
  [self.collectionView addGestureRecognizer:tap];
  self.messageList = [[[NetworkService sharedInstance] getMessages:self.conversation from:0 count:20] mutableCopy];
}

- (void)onResetKeyboard:(id)sender {
  [self.inputTextField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardRect = [value CGRectValue];
  int height = keyboardRect.size.height;
  CGRect frame = self.view.frame;

  frame.origin.y = -height;
  self.view.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardRect = [value CGRectValue];
  int height = keyboardRect.size.height;
  CGRect frame = self.view.frame;
  frame.origin.y += height;
  self.view.frame = frame;
  if (frame.origin.y < 0) {
    frame.origin.y = -height;
    self.view.frame = frame;
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.tabBarController.tabBar.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self onResetKeyboard:textField];
  return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
