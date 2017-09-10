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
@end
