//
//  NSDate+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSDate+CCChain.h"

@implementation NSDate (CCChain)
- (NSInteger (^)())firstWeekDayInThisMonth {
    __weak typeof(self) pSelf = self;
    return ^NSInteger {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                             fromDate:pSelf];
        [comp setDay:1];
        NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
        
        NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday
                                                      inUnit:NSCalendarUnitWeekOfMonth
                                                     forDate:firstDayOfMonthDate];
        return firstWeekday - 1;
    };
}

- (NSInteger (^)())weekDay {
    __weak typeof(self) pSelf = self;
    return ^NSInteger () {
        return (pSelf.firstWeekDayInThisMonth() + pSelf.day() - 1) % 7;
    };
}

- (NSInteger (^)())day {
    __weak typeof(self) pSelf = self;
    return ^NSInteger {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                       fromDate:pSelf];
        return [components day];
    };
}

- (NSString *(^)(NSTimeInterval))timeSince1970 {
    return ^NSString *(NSTimeInterval interval) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [formatter stringFromDate:date];
        return string;
    };
}

- (NSString *)toWeek {
    switch (self.weekDay()) {
        case 1:{
            return @"1";
        }break;
        case 2:{
            return @"2";
        }break;
        case 3:{
            return @"3";
        }break;
        case 4:{
            return @"4";
        }break;
        case 5:{
            return @"5";
        }break;
        case 6:{
            return @"6";
        }break;
        case 7:{
            return @"7";
        }break;
            
        default:{
            return @"0";
        }break;
    }
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@",self];
}

@end
