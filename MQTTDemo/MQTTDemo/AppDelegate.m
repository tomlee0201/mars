//
//  AppDelegate.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/6/29.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkService.h"
#import "LoginViewController.h"

@interface AppDelegate () <ConnectionStatusDelegate, ReceiveMessageDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [NetworkService startLog];
  [NetworkService sharedInstance].connectionStatusDelegate = self;
  [NetworkService sharedInstance].receiveMessageDelegate = self;
  NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedName"];
  NSString *savedPwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPwd"];
    NSString *savedToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedToken"];
    NSString *savedUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedUserId"];
    
  if (savedName.length > 0 && savedPwd.length > 0 && savedToken.length > 0 && savedUserId.length > 0) {
    [[NetworkService sharedInstance] login:savedUserId password:savedPwd];
      [LoginViewController login:savedName password:savedPwd success:^(NSString *userId, NSString *token) {
          
      } error:^(int errCode, NSString *message) {
          
      }];
  } else {
    [self onConnectionStatusChanged:[NetworkService sharedInstance].currentConnectionStatus];
  }
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [[NetworkService sharedInstance] reportEvent_OnForeground:NO];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  [[NetworkService sharedInstance] reportEvent_OnForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [NetworkService startLog];
}

- (void)onReceiveMessage:(NSArray<Message *> *)messages hasMore:(BOOL)hasMore {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReceiveMessages" object:messages];
  });
}

- (void)onConnectionStatusChanged:(ConnectionStatus)status {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (status == kConnectionStatusLogout) {
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      LoginViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
      self.window.rootViewController = loginViewController;
    } else {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kConnectionStatusChanged" object:@(status)];
    }
  });
}


@end
