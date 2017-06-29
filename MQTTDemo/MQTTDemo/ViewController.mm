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


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *publishTopicField;
@property (weak, nonatomic) IBOutlet UITextField *pushContentField;
@property (weak, nonatomic) IBOutlet UITextField *subscribeTopicField;
@property (weak, nonatomic) IBOutlet UITextView *mqttEventArea;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
}
- (IBAction)onPublishButton:(id)sender {
  mars::stn::MQTTPublishTask *publishTask = new mars::stn::MQTTPublishTask(new PublishCallback());
  publishTask->topic = [self.publishTopicField.text cStringUsingEncoding:kCFStringEncodingUTF8];
  publishTask->body = [self.pushContentField.text cStringUsingEncoding:kCFStringEncodingUTF8];
  mars::stn::StartTask(*publishTask);
}
- (IBAction)onSubscribeButton:(id)sender {
  mars::stn::MQTTSubscribeTask *subscribeTask = new mars::stn::MQTTSubscribeTask(new PublishCallback());
  subscribeTask->topic = [self.subscribeTopicField.text cStringUsingEncoding:kCFStringEncodingUTF8];
  mars::stn::StartTask(*subscribeTask);
}
- (IBAction)onUnsubscribeButton:(id)sender {
  mars::stn::MQTTUnsubscribeTask *unsubscribeTask = new mars::stn::MQTTUnsubscribeTask(new PublishCallback());
  unsubscribeTask->topic = [self.subscribeTopicField.text cStringUsingEncoding:kCFStringEncodingUTF8];
  mars::stn::StartTask(*unsubscribeTask);
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
