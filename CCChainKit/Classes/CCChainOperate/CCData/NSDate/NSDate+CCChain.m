//
//  NSDate+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSDate+CCChain.h"

#import "NSObject+CCChain.h"

@implementation NSDate (CCChain)
- (NSDate *(^)())firstWeekDayInThisMonth {
    __weak typeof(self) pSelf = self;
    return ^NSDate *() {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                             fromDate:self];
        [comp setDay:1];
        NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
        
        pSelf.bridge = ^id{
            return calendar;
        };
        
        return firstDayOfMonthDate;
    };
}

- (NSDate *(^)())weekDay {
    __weak typeof(self) pSelf = self;
    return ^NSDate *() {
        pSelf.bridge = ^id{
            return @((pSelf.firstWeekDayInThisMonth().toInt + pSelf.day().toInt - 1) % 7);
        };
        return pSelf;
    };
}

- (NSDate *(^)())day {
    __weak typeof(self) pSelf = self;
    return ^NSDate *() {
        pSelf.bridge = ^id{
            return [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:pSelf];
        };
        return pSelf;
    };
}

- (NSString *)toWeek {
    switch (self.weekDay().toInt) {
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

- (NSUInteger) toInt {
    id value = nil;
    if (self.bridge) {
        value = self.bridge();
    }
    
    if ([value isKindOfClass:NSCalendar.class]) {
        NSUInteger firstWeekday = [(NSCalendar *)value ordinalityOfUnit:NSCalendarUnitWeekday
                                                                 inUnit:NSCalendarUnitWeekOfMonth
                                                                forDate:self];
        return firstWeekday - 1;
    }
    if ([value isKindOfClass:NSDateComponents.class]) {
        return [(NSDateComponents *)value day];
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [value integerValue];
    }
    
    return -1;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@",self];
}

@end
