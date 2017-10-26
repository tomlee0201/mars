//
//  MyPortraitViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/10/6.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "MyPortraitViewController.h"
#import "IMService.h"
#import "SDWebImage.h"
#import "NetworkService.h"
#import "MBProgressHUD.h"
#import "Utilities.h"


@interface MyPortraitViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
  @property (weak, nonatomic) IBOutlet UIImageView *portraitView;
  
@end

@implementation MyPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UserInfo *userInfo = [[IMService sharedIMService] getUserInfo:[NetworkService sharedInstance].userId refresh:NO];
  [self.portraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
}

- (IBAction)onModify:(id)sender {
  UIActionSheet *actionSheet =
  [[UIActionSheet alloc] initWithTitle:@"修改头像"
                              delegate:self
                     cancelButtonTitle:@"取消"
                destructiveButtonTitle:@"拍照"
                     otherButtonTitles:@"相册", nil];
  [actionSheet showInView:self.view];
}
  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
  NSData *data = nil;
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if ([mediaType isEqual:@"public.image"]) {
    UIImage *originImage =
    [info objectForKey:UIImagePickerControllerEditedImage];
    //获取截取区域的图像
    UIImage *captureImage = [Utilities thumbnailWithImage:originImage maxSize:CGSizeMake(600, 600)];
    data = UIImageJPEGRepresentation(captureImage, 0.00001);
  }
  
  UIImage *previousImage = self.portraitView.image;
  __weak typeof(self) ws = self;
  __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"更新中...";
  [hud showAnimated:YES];
  
  [[IMService sharedIMService] uploadMedia:data mediaType:0 success:^(NSString *remoteUrl) {
    [[IMService sharedIMService] modifyMyInfo:@{@(Modify_Portrait):remoteUrl} success:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        [ws.portraitView sd_setImageWithURL:[NSURL URLWithString:remoteUrl] placeholderImage:previousImage];
          [hud hideAnimated:NO];
        [ws showHud:@"更新成功"];
      });
    } error:^(int error_code) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:NO];
        [ws showHud:@"更新失败"];
      });
    }];
  } error:^(int error_code) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [hud hideAnimated:NO];
      [ws showHud:@"更新失败"];
    });
  }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
  
  - (void)showHud:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:1.f];
  }
  
@end
