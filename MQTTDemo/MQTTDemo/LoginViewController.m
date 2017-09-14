//
//  LoginViewController.m
//  MQTTDemo
//
//  Created by Tom Lee on 2017/7/9.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "NetworkService.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCryptor.h>

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@end

const NSString *DESKey = @"abcdefgh";
const NSString *IMKey = @"testim";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    srand((int)time(NULL));
    self.userNameField.text = [NSString stringWithFormat:@"user%d", rand()%10];
}

- (NSString *) encryptUseDES:(NSString *)plainText {
  NSString *ciphertext = nil;
  const char *textBytes = [plainText UTF8String];
  NSUInteger dataLength = [plainText length];
  unsigned char buffer[1024];
  memset(buffer, 0, sizeof(char));
  Byte iv[] = {1,2,3,4,5,6,7,8};
  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding,
                                        [DESKey UTF8String], kCCKeySizeDES,
                                        iv,
                                        textBytes, dataLength,
                                        buffer, 1024,
                                        &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
    NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    
    ciphertext = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
  }
  return ciphertext;
}


- (NSString *) decryptUseDES:(NSString*)cipherText
{
  NSData* cipherData = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
  
  unsigned char buffer[1024];
  memset(buffer, 0, sizeof(char));
  size_t numBytesDecrypted = 0;
  Byte iv[] = {1,2,3,4,5,6,7,8};
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                        kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding,
                                        [DESKey UTF8String],
                                        kCCKeySizeDES,
                                        iv,
                                        [cipherData bytes],
                                        [cipherData length],
                                        buffer,
                                        1024,
                                        &numBytesDecrypted);
  NSString* plainText = nil;
  if (cryptStatus == kCCSuccess) {
    NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  return plainText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
  NSString *user = self.userNameField.text;
  NSString *token = [self encryptUseDES:[NSString stringWithFormat:@"%@|%ld|%@", IMKey, time(NULL), user]];

      [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:@"savedName"];
      [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"savedPwd"];
        [[NetworkService sharedInstance] login:self.userNameField.text password:token];
      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
      UIViewController *rootVC =  [sb instantiateViewControllerWithIdentifier:@"rootVC"];
      [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
}
@end
