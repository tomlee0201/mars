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
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _thumbnail.size.width, _thumbnail.size.height)];
    [_scrollView addSubview:_imageView];
    
    __weak typeof(self) weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:_thumbnail completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            weakSelf.scrollView.contentSize = weakSelf.imageView.image.size;
        });
    }];
    
    _scrollView.contentSize = _imageView.image.size;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClose:)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
