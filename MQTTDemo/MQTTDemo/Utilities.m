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
@end
