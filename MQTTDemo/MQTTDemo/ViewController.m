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
#import "Message.pbobjc.h"
#import "Conversation.pbobjc.h"
#import "Messagecontent.pbobjc.h"
#import "IMService.h"

@interface ViewController () <ConnectionStatusDelegate, ReceiveMessageDelegate>
@property (weak, nonatomic) IBOutlet UITextField *targetIdField;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UITextView *eventArea;
@end

@implementation ViewController
- (void)onConnectionStatusChanged:(ConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *title;
        if (status == kConnectionStatusLogout) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
        } else if (status != kConnectionStatusConnectiong) {
            UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, 0, 80, 44)];
            switch (status) {
                case kConnectionStatusLogout:
                    navLabel.text = @"未登录";
                    break;
                case kConnectionStatusUnconnected:
                    navLabel.text = @"未连接";
                    break;
                case kConnectionStatusConnected:
                    navLabel.text = @"已连接";
                    break;
                    
                default:
                    break;
            }
            
            navLabel.textColor = [UIColor blueColor];
            navLabel.font = [UIFont systemFontOfSize:18];
            navLabel.textAlignment = NSTextAlignmentCenter;
            title = navLabel;
        } else {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width/2, self.navigationController.navigationBar.bounds.size.height/2);
            [indicatorView startAnimating];
            title = indicatorView;
        }
        self.navigationItem.titleView = title;
    });
}

- (void)onReceiveMessage:(NSArray<Message *> *)messages hasMore:(BOOL)hasMore {
  for (Message *message in messages) {
    [self appendEvent:[NSString stringWithFormat:@"Receive Message from %@ and Message(%@)",message.fromUser, message]];
  }
}

- (void)appendEvent:(NSString *)event {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.eventArea.text = [NSString stringWithFormat:@"%@\n%@",event, self.eventArea.text];
        }];
    });
}

- (IBAction)logout:(id)sender {
  [[NetworkService sharedInstance] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkService sharedInstance].connectionStatusDelegate = self;
    [NetworkService sharedInstance].receiveMessageDelegate = self;
    [self onConnectionStatusChanged:[NetworkService sharedInstance].currentConnectionStatus];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
}

- (void)resetKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onSendButton:(id)sender {
    //NSData *data = [self.pushContentField.text dataUsingEncoding:NSUTF8StringEncoding];
  
  MessageContent *notifyContent = [[MessageContent alloc] init];
  notifyContent.type = ContentType_Text;
  notifyContent.searchableContent = @"hello group";
  
  [[IMService sharedIMService] createGroup:@"2" name:@"2" portrait:@"3" members:@[@"testuser", @"111"] notifyContent:notifyContent success:^(NSString *groupId) {
    
  } error:^(int error_code) {
    
  }];
  
    Message *msg = [Message message];
    msg.conversation.type = ConversationType_Private;
    msg.conversation.target = self.targetIdField.text;
    msg.content.type = ContentType_Text;
    msg.content.searchableContent = self.contentField.text;
    msg.content.data_p = [@"hello extra" dataUsingEncoding:NSUTF8StringEncoding];
  
    __weak typeof(self) weakSelf = self;
    [[IMService sharedIMService] send:msg success:^(long messageId, long timestamp) {
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
