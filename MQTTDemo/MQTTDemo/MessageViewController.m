//
//  MessageViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/8/31.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "MessageViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "NetworkService.h"
#import "TextMessageContent.h"
#import "ImageMessageContent.h"
#import "ImagePreviewViewController.h"

#import "VoiceRecordView.h"

#import "TextCell.h"
#import "ImageCell.h"
#import "VoiceCell.h"

#import "IMService.h"

#import "SoundMessageContent.h"

#define IOS_SYSTEM_VERSION_LESS_THAN(v)                                     \
([[[UIDevice currentDevice] systemVersion]                                   \
compare:v                                                               \
options:NSNumericSearch] == NSOrderedAscending)


#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]


@interface MessageViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MessageCellDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong)NSMutableArray<MessageModel *> *modelList;
@property (nonatomic, strong)NSMutableDictionary<NSNumber *, Class> *cellContentDict;
@property (nonatomic, assign)BOOL isVoiceInput;

@property(nonatomic) AVAudioPlayer *player;
@property(nonatomic) NSTimer *playTimer;

@property(nonatomic) AVAudioRecorder *recorder;
@property(nonatomic) NSTimer *recordingTimer;
@property(nonatomic) NSTimer *updateMeterTimer;
@property(nonatomic, assign) int seconds;
@property(nonatomic) BOOL recordCanceled;

@property(nonatomic, assign)long playingMessageId;

@property (nonatomic, strong)VoiceRecordView *recordView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.inputTextField.delegate = self;
    self.cellContentDict = [[NSMutableDictionary alloc] init];
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
  NSArray *messageList = [[[IMService sharedIMService] getMessages:self.conversation from:0 count:10] mutableCopy];
  self.modelList = [[NSMutableArray alloc] init];
  Message *lastMsg = nil;
  BOOL showTime = YES;
  for (Message *message in messageList) {
    if (message.serverTime - lastMsg.serverTime > 60 * 1000) {
      showTime = YES;
    } else {
      showTime = NO;
    }
    lastMsg = message;
    [self.modelList addObject:[MessageModel modelOf:message showName:message.direction == MessageDirection_Receive showTime:showTime]];
  }
  [self initializedSubViews];
  [self.collectionView reloadData];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMessages:) name:@"kReceiveMessages" object:nil];
    
    self.title = self.conversation.target;
    
    [self.extendedBtn addTarget:self action:@selector(onExtendedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchBtn addTarget:self action:@selector(onSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
   // self.isVoiceInput = NO;
    
    [self.voiceBtn addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtn addTarget:self action:@selector(onTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.voiceBtn addTarget:self action:@selector(onTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.voiceBtn addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceBtn addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.voiceBtn addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchCancel];
}

- (void)onTouchDown:(id)sender {
    if ([self canRecord]) {
        _recordView = [[VoiceRecordView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 70, self.view.bounds.size.height/2 - 70, 140, 140)];
        _recordView.center = self.view.center;
        [self.view addSubview:_recordView];
        [self.view bringSubviewToFront:_recordView];
        
        [self recordStart];
    }
}

- (void)recordStart {
    if (self.recorder.recording) {
        return;
    }
    
    //[self stopPlayer];
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryRecord error:nil];
            BOOL r = [session setActive:YES error:nil];
            if (!r) {
                NSLog(@"activate audio session fail");
                return;
            }
            NSLog(@"start record...");
            
            NSArray *pathComponents = [NSArray arrayWithObjects:
                                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                       @"voice.wav",
                                       nil];
            NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
            
            // Define the recorder setting
            NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
            
            [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
            [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
            [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
            
            self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
            self.recorder.delegate = self;
            self.recorder.meteringEnabled = YES;
            if (![self.recorder prepareToRecord]) {
                NSLog(@"prepare record fail");
                return;
            }
            if (![self.recorder record]) {
                NSLog(@"start record fail");
                return;
            }
            
            
            self.recordCanceled = NO;
            self.seconds = 0;
            self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
            
            self.updateMeterTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                     target:self
                                                                   selector:@selector(updateMeter:)
                                                                   userInfo:nil
                                                                    repeats:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"无法录音,请到设置-隐私-麦克风,允许程序访问" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)recordCancel {
    NSLog(@"touch cancel");
    
    if (self.recorder.recording) {
        NSLog(@"cancel record...");
        self.recordCanceled = YES;
        [self stopRecord];
    }
}

- (void)onTouchDragExit:(id)sender {
    [self.recordView recordButtonDragOutside];
}

- (void)onTouchDragEnter:(id)sender {
    [self.recordView recordButtonDragInside];
}

- (void)onTouchUpInside:(id)sender {
    [self.recordView removeFromSuperview];
    [self recordEnd];
}

- (void)onTouchUpOutside:(id)sender {
    [self.recordView removeFromSuperview];
    [self recordCancel];
}

- (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    
    if ([[AVAudioSession sharedInstance]
         respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            bCanRecord = granted;
            dispatch_async(dispatch_get_main_queue(), ^{
                bCanRecord = granted;
                if (granted) {
                    bCanRecord = YES;
                } else {
                    
                }
            });
        }];
    }
    
    return bCanRecord;
}

- (void)timerFired:(NSTimer*)timer {
    self.seconds = self.seconds + 1;
    int minute = self.seconds/60;
    int s = self.seconds%60;
    NSString *str = [NSString stringWithFormat:@"%02d:%02d", minute, s];
    NSLog(@"timer:%@", str);
    int countdown = 60 - self.seconds;
    if (countdown <= 10) {
        [self.recordView setCountdown:countdown];
    }
    if (countdown <= 0) {
        [self.recordView removeFromSuperview];
        [self recordEnd];
    }
}

- (void)updateMeter:(NSTimer*)timer {
    double voiceMeter = 0;
    if ([self.recorder isRecording]) {
        [self.recorder updateMeters];
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
        voiceMeter = lowPassResults;
    }
    [self.recordView setVoiceImage:voiceMeter];
}

-(void)recordEnd {
    if (self.recorder.recording) {
        NSLog(@"stop record...");
        self.recordCanceled = NO;
        [self stopRecord];
    }
}

-(void)stopRecord {
    [self.recorder stop];
    [self.recordingTimer invalidate];
    self.recordingTimer = nil;
    [self.updateMeterTimer invalidate];
    self.updateMeterTimer = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL r = [audioSession setActive:NO error:nil];
    if (!r) {
        NSLog(@"deactivate audio session fail");
    }
}

- (void)onSwitchBtn:(id)sender {
    self.isVoiceInput = !self.isVoiceInput;
}

- (void)setIsVoiceInput:(BOOL)isVoiceInput {
    _isVoiceInput = isVoiceInput;
    if (isVoiceInput) {
        self.inputTextField.hidden = YES;
        self.voiceBtn.hidden = NO;
        [self.switchBtn setTitle:@"A" forState:UIControlStateNormal];
        [self.inputTextField resignFirstResponder];
    } else {
        self.inputTextField.hidden = NO;
        self.voiceBtn.hidden = YES;
        [self.switchBtn setTitle:@"V" forState:UIControlStateNormal];
        [self.inputTextField becomeFirstResponder];
    }
}

- (void)onExtendedBtn:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor orangeColor];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = sourcheType;
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)scrollToBottom:(BOOL)animated {
    NSUInteger finalRow = MAX(0, self.modelList.count - 1);
    
    if (0 == finalRow) {
        return;
    }
    
    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.collectionView scrollToItemAtIndexPath:finalIndexPath
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:animated];
}

- (void)initializedSubViews {

    UICollectionViewFlowLayout *_customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _customFlowLayout.minimumLineSpacing = 0.0f;
    _customFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    _customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
    self.collectionView.collectionViewLayout = _customFlowLayout;
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self.collectionView
     setBackgroundColor:RGBCOLOR(235, 235, 235)];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self registerCell:[TextCell class] forContent:[TextMessageContent class]];
    [self registerCell:[ImageCell class] forContent:[ImageMessageContent class]];
    [self registerCell:[VoiceCell class] forContent:[SoundMessageContent class]];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)registerCell:(Class)cellCls forContent:(Class)msgContentCls {
    [self.collectionView registerClass:cellCls
            forCellWithReuseIdentifier:[NSString stringWithFormat:@"%d", [msgContentCls getContentType]]];
    [self.cellContentDict setObject:cellCls forKey:@([msgContentCls getContentType])];
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
    frame = self.collectionView.frame;
    frame.origin.y += height;
    frame.size.height -= height;
    self.collectionView.frame = frame;
    [self scrollToBottom:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect frame = self.view.frame;
  
  self.view.frame = frame;
  if (frame.origin.y < 0) {
    frame.origin.y = 0;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.tabBarController.tabBar.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  TextMessageContent *txtContent = [[TextMessageContent alloc] init];
  txtContent.text = textField.text;
  textField.text = nil;
   
    [self sendMessage:txtContent];
  return YES;
}

- (void)sendMessage:(MessageContent *)content {
    Message *message = [[IMService sharedIMService] send:self.conversation content:content success:^(long messageId, long timestamp) {
        
    } error:^(int error_code) {
        
    }];
    [self appendNewMessage:@[message]];
}
- (void)onReceiveMessages:(NSNotification *)notification {
    NSArray<Message *> *messages = notification.object;
    [self appendNewMessage:messages];
}

- (void)appendNewMessage:(NSArray<Message *> *)messages {
  BOOL showTime = YES;
    for (Message *message in messages) {
        if (self.modelList.count > 0 && (message.serverTime -  (self.modelList[self.modelList.count - 1]).message.serverTime < 60 * 1000)) {
            showTime = NO;
            
        }
        [self.modelList addObject:[MessageModel modelOf:message showName:message.direction == MessageDirection_Receive showTime:showTime]];
    }
  
  [self.collectionView reloadData];
    [self scrollToBottom:YES];
}

- (MessageModel *)modelOfMessage:(long)messageId {
    if (messageId <= 0) {
        return nil;
    }
    for (MessageModel *model in self.modelList) {
        if (model.message.messageId == messageId) {
            return model;
        }
    }
    return nil;
}

- (void)stopPlayer {
    if (self.player && [self.player isPlaying]) {
        [self.player stop];
        if ([self.playTimer isValid]) {
            [self.playTimer invalidate];
            self.playTimer = nil;
        }
    }
    [self modelOfMessage:self.playingMessageId].voicePlaying = NO;
    self.playingMessageId = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:kVoiceMessagePlayStoped object:nil];
}

-(void)prepardToPlay:(MessageModel *)model {

    if (self.playingMessageId == model.message.messageId) {
        [self stopPlayer];
    } else {
        [self stopPlayer];
        
        self.playingMessageId = model.message.messageId;
        
        SoundMessageContent *soundContent = (SoundMessageContent *)model.message.content;
        if (soundContent.localPath.length == 0) {
            __weak typeof(self) weakSelf = self;
            model.mediaDownloading = YES;
            long downloadingId = self.playingMessageId;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMediaMessageStartDownloading object:@(downloadingId)];
            dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                NSData *amrData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soundContent.remoteUrl]];
                [soundContent updateAmrData:amrData];
                [NSThread sleepForTimeInterval:10];
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.mediaDownloading = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMediaMessageDownloadFinished object:@(downloadingId)];
                    [weakSelf startPlay:model];
                });
            });
        } else {
            [self startPlay:model];
        }
        
    }
}

-(void)startPlay:(MessageModel *)model {
    
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                   error:nil];
        
        
        SoundMessageContent *snc = (SoundMessageContent *)model.message.content;
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithData:[snc getWavData] error:&error];
        [self.player setDelegate:self];
        [self.player prepareToPlay];
        [self.player play];
    model.voicePlaying = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kVoiceMessageStartPlaying object:@(self.playingMessageId)];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.modelList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MessageModel *model = self.modelList[indexPath.row];
  NSString *objName = [NSString stringWithFormat:@"%d", [model.message.content.class getContentType]];
  
   MessageCellBase *cell = [collectionView dequeueReusableCellWithReuseIdentifier:objName forIndexPath:indexPath];
    cell.delegate = self;
    
  [[NSNotificationCenter defaultCenter] removeObserver:cell];
  cell.model = model;
  
  return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  MessageModel *model = self.modelList[indexPath.row];
    Class cellCls = self.cellContentDict[@([[model.message.content class] getContentType])];
  return [cellCls sizeForCell:model withViewWidth:self.collectionView.frame.size.width];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    ImageMessageContent *imgContent = [ImageMessageContent contentFrom:image];
    [self sendMessage:imgContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MessageCellDelegate
- (void)didTapMessageCell:(MessageCellBase *)cell withModel:(MessageModel *)model {
    if ([model.message.content isKindOfClass:[ImageMessageContent class]]) {
        ImageMessageContent *imc = (ImageMessageContent *)model.message.content;
        ImagePreviewViewController *previewController = [[ImagePreviewViewController alloc] init];
        previewController.thumbnail = imc.thumbnail;
        if (imc.localPath.length) {
            previewController.imageUrl = imc.localPath;
        } else {
            previewController.imageUrl = imc.remoteUrl;
        }
        
        [self presentViewController:previewController animated:YES completion:nil];
    } else if([model.message.content isKindOfClass:[SoundMessageContent class]]) {
        [self prepardToPlay:model];
    }
}
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"record finish:%d", flag);
    if (!flag) {
        return;
    }
    if (self.recordCanceled) {
        return;
    }
    if (self.seconds < 1) {
        NSLog(@"record time too short");
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"录音时间太短了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        return;
    }
    [self sendMessage:[SoundMessageContent soundMessageContentForWav:[recorder.url path] duration:self.seconds]];
    [[NSFileManager defaultManager] removeItemAtURL:recorder.url error:nil];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"player finished");
    [self stopPlayer];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"player decode error");
    [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"网络错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [self stopPlayer];
}

@end
