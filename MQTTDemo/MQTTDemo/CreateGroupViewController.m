//
//  CreateGroupViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/14.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "IMService.h"
#import "TextMessageContent.h"
#import "CreateGroupNotificationContent.h"
#import "NetworkService.h"
#import "Utilities.h"
#import "MBProgressHUD.h"


@interface CreateGroupViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong)UIImageView *portraitView;
@property(nonatomic, strong)UITextField *nameField;
@property(nonatomic, strong)NSString *portraitUrl;
@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect bound = self.view.bounds;
    CGFloat portraitWidth = 80;
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake((bound.size.width - portraitWidth)/2, 80, portraitWidth, portraitWidth)];
    self.portraitView.image = [UIImage imageNamed:@"GroupChat"];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPortrait:)];
    [self.portraitView addGestureRecognizer:tap];
    
    [self.view addSubview:self.portraitView];
    
    CGFloat namePadding = 60;
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(namePadding, 80 + portraitWidth + 60, bound.size.width - namePadding - namePadding, 21)];
    [self.nameField setAccessibilityHint:@"请设置群名称"];
    self.nameField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.nameField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
}

- (void)onSelectPortrait:(id)sender {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"修改头像"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"拍照"
                       otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -  UIActionSheetDelegate <NSObject>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        if ([UIImagePickerController
             isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            NSLog(@"无法连接相机");
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:@"public.image"]) {
        UIImage *originImage =
        [info objectForKey:UIImagePickerControllerEditedImage];
        //获取截取区域的图像
        UIImage *captureImage = [Utilities thumbnailWithImage:originImage maxSize:CGSizeMake(60, 60)];
        [self uploadPortrait:captureImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadPortrait:(UIImage *)portraitImage {
    NSData *portraitData = UIImageJPEGRepresentation(portraitImage, 0.70);
    __weak typeof(self) ws = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"图片上传中...";
    [hud showAnimated:YES];
    
    [[IMService sharedIMService] uploadMedia:portraitData mediaType:0 success:^(NSString *remoteUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:NO];
            ws.portraitUrl = remoteUrl;
            ws.portraitView.image = portraitImage;
        });
    } error:^(int error_code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:NO];
            hud = [MBProgressHUD showHUDAddedTo:ws.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"上传失败";
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDone:(id)sender {
    [self createGroup:self.nameField.text portrait:self.portraitUrl members:self.memberIds];
}

- (void)createGroup:(NSString *)groupName portrait:(NSString *)portraitUrl members:(NSArray<NSString *> *)memberIds {
    CreateGroupNotificationContent *notifyContent = [[CreateGroupNotificationContent alloc] init];
    notifyContent.creator = [NetworkService sharedInstance].userId;
    notifyContent.groupName = groupName;
    if (![memberIds containsObject:[NetworkService sharedInstance].userId]) {
        NSMutableArray *tmpArray = [memberIds mutableCopy];
        [tmpArray insertObject:[NetworkService sharedInstance].userId atIndex:0];
        memberIds = tmpArray;
    }
    
    [[IMService sharedIMService] createGroup:nil name:groupName portrait:portraitUrl members:memberIds notifyLines:@[@(0)] notifyContent:notifyContent success:^(NSString *groupId) {
        NSLog(@"create group success");
    } error:^(int error_code) {
        NSLog(@"create group failure");
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
