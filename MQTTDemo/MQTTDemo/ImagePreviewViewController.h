//
//  ImagePreviewViewController.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewViewController : UIViewController
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)UIImage *thumbnail;
@end
