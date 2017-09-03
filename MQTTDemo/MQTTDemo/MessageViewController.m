//
//  MessageViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/8/31.
//  Copyright © 2017年 tomlee. All rights reserved.
//

#import "MessageViewController.h"
#import "NetworkService.h"
#import "TextMessageContent.h"
#import "ImageMessageContent.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "IMService.h"


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

@interface MessageViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)NSMutableArray<MessageModel *> *modelList;
@property (nonatomic, strong)NSMutableDictionary<NSNumber *, Class> *cellContentDict;
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
  NSArray *messageList = [[[NetworkService sharedInstance] getMessages:self.conversation from:0 count:10] mutableCopy];
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
}

- (void)onExtendedBtn:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor orangeColor];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = sourcheType;
    picker.delegate = self;
    picker.allowsEditing = YES;
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
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.modelList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MessageModel *model = self.modelList[indexPath.row];
  NSString *objName = [NSString stringWithFormat:@"%d", [model.message.content.class getContentType]];
  
   MessageCellBase *cell = [collectionView dequeueReusableCellWithReuseIdentifier:objName forIndexPath:indexPath];
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
    UIImage *image = info[UIImagePickerControllerEditedImage];
    ImageMessageContent *imgContent = [ImageMessageContent contentFrom:image];
    [self sendMessage:imgContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
