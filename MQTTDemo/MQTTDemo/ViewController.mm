//
//  ViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/6/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "PublishTask.h"
#import "SubscribeTask.h"
#import "UnsubscribeTask.h"

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
            [self.navigationController popViewControllerAnimated:YES];
        } else if (status != kConnectionStatusConnectiong) {
            UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
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
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self appendEvent:[NSString stringWithFormat:@"Receive Topic(%@) Message(%@)",topic, message]];
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
    [[NetworkService sharedInstance] login:self.userName password:self.password];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
}
- (void)resetKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onPublishButton:(id)sender {
    PublishTask *publishTask = [[PublishTask alloc] initWithTopic:self.publishTopicField.text message:self.pushContentField.text];
    [publishTask send:^{
        
    } error:^(int error_code) {
        
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
