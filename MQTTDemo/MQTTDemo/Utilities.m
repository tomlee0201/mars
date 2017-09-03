//
//  Utilities.m
//  MQTTDemo
//
//  Created by Tao Li on 2017/9/1.
//  Copyright © 2017年 litao. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+ (CGSize)getTextDrawingSize:(NSString *)text
                        font:(UIFont *)font
             constrainedSize:(CGSize)constrainedSize {
  if (text.length <= 0) {
    return CGSizeZero;
  }
  
  if ([text respondsToSelector:@selector(boundingRectWithSize:
                                         options:
                                         attributes:
                                         context:)]) {
    return [text boundingRectWithSize:constrainedSize
                              options:(NSStringDrawingTruncatesLastVisibleLine |
                                       NSStringDrawingUsesLineFragmentOrigin |
                                       NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName : font
                                        }
                              context:nil]
    .size;
  } else {
    return [text sizeWithFont:font
            constrainedToSize:constrainedSize
                lineBreakMode:NSLineBreakByTruncatingTail];
  }
}
+ (UIImage *)generateThumbnail:(UIImage *)image
                    withWidth:(CGFloat)targetWidth
                   withHeight:(CGFloat)targetHeight {
    UIImage *targetImage = nil;
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = 0.0;
    CGFloat scaledHeight = 0.0;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (imageWidth/imageHeight < 2.4 && imageHeight/imageWidth < 2.4) {
        CGFloat widthFactor = targetWidth / imageWidth;
        CGFloat heightFactor = targetHeight / imageHeight;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth = imageWidth * scaleFactor;
        scaledHeight = imageHeight * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    } else {
        if(imageWidth/imageHeight > 2.4) {
            scaleFactor = 100 * targetHeight / imageHeight / 240;
        } else {
            scaleFactor = 100 * targetWidth / imageWidth / 240;
        }
        scaledWidth = imageWidth * scaleFactor;
        scaledHeight = imageHeight * scaleFactor;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [image drawInRect:thumbnailRect];
    
     targetImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(imageWidth/imageHeight > 2.4) {
        CGRect rect = CGRectZero;
        rect.origin.x = ( targetImage.size.width - 240)/2;
        rect.size.width = 240;
        rect.origin.y = 0;
        rect.size.height =  targetImage.size.height;
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([ targetImage CGImage], rect);
         targetImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    } else if(imageHeight/imageWidth > 2.4) {
        CGRect rect = CGRectZero;
        rect.origin.y = ( targetImage.size.height - 240)/2;
        rect.size.height = 240;
        rect.origin.x = 0;
        rect.size.width =  targetImage.size.width;
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([ targetImage CGImage], rect);
         targetImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    if ( targetImage == nil)
        NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    return  targetImage;
    
}

@end
