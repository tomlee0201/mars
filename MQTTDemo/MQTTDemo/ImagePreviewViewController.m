//
//  ImagePreviewViewController.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "SDWebImage.h"

@interface ImagePreviewViewController ()
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:_thumbnail];
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

@end
