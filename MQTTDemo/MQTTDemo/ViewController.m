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

@interface ViewController () <ConnectionStatusDelegate, ReceivePublishDelegate>
@property (weak, nonatomic) IBOutlet UITextField *publishTopicField;
@property (weak, nonatomic) IBOutlet UITextField *pushContentField;
@property (weak, nonatomic) IBOutlet UITextField *subscribeTopicField;
@property (weak, nonatomic) IBOutlet UITextView *mqttEventArea;

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

- (void)onReceivePublish:(NSString *)topic message:(NSData *)data {
//    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    Message *msg = [Message parseFromData:data error:&error];
    if (error == nil) {
        
    }
    
    [self appendEvent:[NSString stringWithFormat:@"Receive Topic(%@) Message(%@)",topic, msg.content.searchableContent]];
}

- (void)appendEvent:(NSString *)event {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.mqttEventArea.text = [NSString stringWithFormat:@"%@\n%@",event, self.mqttEventArea.text];
        }];
    });
}

- (IBAction)logout:(id)sender {
  [[NetworkService sharedInstance] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkService sharedInstance].connectionStatusDelegate = self;
    [NetworkService sharedInstance].receivePublishDelegate = self;
    [self onConnectionStatusChanged:[NetworkService sharedInstance].currentConnectionStatus];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
}
- (void)resetKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onPublishButton:(id)sender {
    //NSData *data = [self.pushContentField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    Message *msg = [Message message];
    msg.conversation.type = ConversationType_Private;
    msg.conversation.target = @"testuser";
    msg.content.type = ContentType_Text;
    msg.content.searchableContent = @"hello IM";
    msg.content.data_p = [@"hello extra" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [msg data];
    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:self.publishTopicField.text message:data];
    

    
    
    __weak typeof(self) weakSelf = self;
    NSString *topic = publishTask.topic;
    NSString *message = self.pushContentField.text;
    [publishTask send:^{
        [weakSelf appendEvent:[NSString stringWithFormat:@"Publish topic(%@) message(%@) success", topic, message]];
    } error:^(int error_code) {
        [weakSelf appendEvent:[NSString stringWithFormat:@"Publish topic(%@) message(%@) failure with error code(%d)", topic, message, error_code]];
    }];
    [self resetKeyboard:nil];
}
- (IBAction)onSubscribeButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    SubscribeTask *subscribeTask = [[SubscribeTask alloc] initWithTopic:self.subscribeTopicField.text];
    NSString *topic = subscribeTask.topic;
    [subscribeTask send:^{
        [weakSelf appendEvent:[NSString stringWithFormat:@"Subcribe topic(%@) success", topic]];
    } error:^(int error_code) {
        [weakSelf appendEvent:[NSString stringWithFormat:@"Subcribe topic(%@) failure with error code(%d)", topic, error_code]];
    }];
    [self resetKeyboard:nil];
}
- (IBAction)onUnsubscribeButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    UnsubscribeTask *unsubscribeTask = [[UnsubscribeTask alloc] initWithTopic:self.subscribeTopicField.text];
    NSString *topic = unsubscribeTask.topic;
    [unsubscribeTask send:^{
        [weakSelf appendEvent:[NSString stringWithFormat:@"Unsubcribe topic(%@) success", topic]];
    } error:^(int error_code) {
        [weakSelf appendEvent:[NSString stringWithFormat:@"Unsubcribe topic(%@) failure with error code(%d)", topic, error_code]];
    }];
    [self resetKeyboard:nil];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
