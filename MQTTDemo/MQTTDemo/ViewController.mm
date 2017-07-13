//
//  ViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/6/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ViewController.h"
#import <mars/stn/stn.h>
#import <mars/stn/stn_logic.h>
#import "PublishCallback.h"
#import "NetworkService.h"

@interface ViewController () <ConnectionStatusDelegate>
@property (weak, nonatomic) IBOutlet UITextField *publishTopicField;
@property (weak, nonatomic) IBOutlet UITextField *pushContentField;
@property (weak, nonatomic) IBOutlet UITextField *subscribeTopicField;
@property (weak, nonatomic) IBOutlet UITextView *mqttEventArea;

@end

@implementation ViewController
- (void)onConnectionStatusChanged:(ConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *title;
        if (status != kConnectionStatusConnectiong) {
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

- (IBAction)logout:(id)sender {
  [[NetworkService sharedInstance] logout];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkService sharedInstance].connectionStatusDelegate = self;
    [[NetworkService sharedInstance] login:self.userName password:self.password];
}

- (IBAction)onPublishButton:(id)sender {
  mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new PublishCallback());
  publishTask->topic = [self.publishTopicField.text cStringUsingEncoding:NSUTF8StringEncoding];
  publishTask->body = [self.pushContentField.text cStringUsingEncoding:NSUTF8StringEncoding];
  mars::stn::StartTask(*publishTask);
}
- (IBAction)onSubscribeButton:(id)sender {
  mars::stn::MQTTSubscribeTask *subscribeTask = new mars::stn::MQTTSubscribeTask(new PublishCallback());
  subscribeTask->topic = [self.subscribeTopicField.text cStringUsingEncoding:NSUTF8StringEncoding];
  mars::stn::StartTask(*subscribeTask);
}
- (IBAction)onUnsubscribeButton:(id)sender {
  mars::stn::MQTTUnsubscribeTask *unsubscribeTask = new mars::stn::MQTTUnsubscribeTask(new PublishCallback());
  unsubscribeTask->topic = [self.subscribeTopicField.text cStringUsingEncoding:NSUTF8StringEncoding];
  mars::stn::StartTask(*unsubscribeTask);
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
