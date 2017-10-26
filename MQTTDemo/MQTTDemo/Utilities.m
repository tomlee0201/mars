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

+ (NSString *)formatTimeLabel:(int64_t)timestamp {
    if (timestamp == 0) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDate *current = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger days = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger curDays = [calendar component:NSCalendarUnitDay fromDate:current];
    if (days >= curDays) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    } else if(days == curDays -1) {
        return @"昨天";
    } else {
        NSInteger weeks = [calendar component:NSCalendarUnitWeekOfYear fromDate:date];
        NSInteger curWeeks = [calendar component:NSCalendarUnitWeekOfYear fromDate:current];
        
        NSInteger weekDays = [calendar component:NSCalendarUnitWeekday fromDate:date];
        if (weeks == curWeeks) {
            return [NSString stringWithFormat:@"周%ld", (long)weekDays];
        } else if (weeks == curWeeks - 1) {
            return @"上周";
        } else {
            NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
            NSInteger curMonth = [calendar component:NSCalendarUnitMonth fromDate:current];
            if (month == curMonth) {
                return @"本月";
            } else if(month == curMonth - 1) {
                return @"上月";
            } else if(curMonth - month < 6) {
                return @"上月之前";
            } else if(curMonth - month < 12)  {
                return @"半年之前";
            } else {
                return @"一年之前";
            }

        }
    }
}
+ (NSString *)formatTimeDetailLabel:(int64_t)timestamp {
    if (timestamp == 0) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDate *current = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger days = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger curDays = [calendar component:NSCalendarUnitDay fromDate:current];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time =  [formatter stringFromDate:date];
    
    if (days >= curDays) {
        return time;
    } else if(days == curDays -1) {
        return [NSString stringWithFormat:@"昨天 %@", time];
    } else {
        NSInteger weeks = [calendar component:NSCalendarUnitWeekOfYear fromDate:date];
        NSInteger curWeeks = [calendar component:NSCalendarUnitWeekOfYear fromDate:current];
        
        NSInteger weekDays = [calendar component:NSCalendarUnitWeekday fromDate:date];
        if (weeks == curWeeks) {
            return [NSString stringWithFormat:@"周%ld %@", (long)weekDays, time];
        } else if (weeks == curWeeks - 1) {
            return [NSString stringWithFormat:@"上周%ld %@", (long)weekDays, time];
        } else {
            NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
            NSInteger curYear = [calendar component:NSCalendarUnitYear fromDate:current];
            
            NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
            NSInteger curMonth = [calendar component:NSCalendarUnitMonth fromDate:current];
            if (month == curMonth) {
                [formatter setDateFormat:@"dd' 'HH':'mm"];
                return [formatter stringFromDate:date];
            } else if (year == curYear) {
                [formatter setDateFormat:@"MM-dd' 'HH':'mm"];
                return [formatter stringFromDate:date];
            } else {
                [formatter setDateFormat:@"yyyy-MM-dd' 'HH':'mm"];
                return [formatter stringFromDate:date];
            }
            
        }
    }
}
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage maxSize:(CGSize)size {
    CGSize originalsize = [originalImage size];
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height){
        return originalImage;
    }
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height){
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        rate = widthRate>heightRate?heightRate:widthRate;
        CGImageRef imageRef = nil;
        if (heightRate>widthRate){
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }else{
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width){
        CGImageRef imageRef = nil;
        if(originalsize.height>size.height){
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-originalsize.width/2, originalsize.width, originalsize.width));//获取图片整体部分
        }
        else if (originalsize.width>size.width){
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-originalsize.height/2, 0, originalsize.height, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    //原图为标准长宽的，不做处理
    else{
        return originalImage;
    }
}
@end
