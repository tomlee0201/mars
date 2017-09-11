//
//  ViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/6/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NetworkService.h"
#import "PublishTask.h"
#import "SubscribeTask.h"
#import "UnsubscribeTask.h"
#import "Message.h"
#import "Conversation.h"
#import "IMService.h"
#import "TextMessageContent.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *targetIdField;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UITextView *eventArea;
@end

@implementation ViewController

- (void)appendEvent:(NSString *)event {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.eventArea.text = [NSString stringWithFormat:@"%@\n%@",event, self.eventArea.text];
        }];
    });
}

- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedPwd"];
  [[NetworkService sharedInstance] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
}

- (void)resetKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onSendButton:(id)sender {
  
    Conversation *conversation = [Conversation conversationWithType:Single_Type target:self.targetIdField.text line:0];
    MessageContent *content = [TextMessageContent contentWith:self.contentField.text];
    __weak typeof(self) weakSelf = self;
    [[IMService sharedIMService] send:conversation content:content success:^(long messageId, long timestamp) {
      [weakSelf appendEvent:[NSString stringWithFormat:@"Send message success, ret messageId:%ld, timestamp:%ld", messageId, timestamp]];
    } error:^(int error_code) {
      [weakSelf appendEvent:[NSString stringWithFormat:@"Send message failure with errorCode %d", error_code]];
    }];
  
    [self resetKeyboard:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
