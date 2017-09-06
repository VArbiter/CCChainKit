//
//  NSDate+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCChain)

@property (nonatomic , copy , readonly) NSInteger (^firstWeekDayInThisMonth)();
@property (nonatomic , copy , readonly) NSInteger (^weekDay)();
@property (nonatomic , copy , readonly) NSInteger (^day)();

/// yyyy-MM-dd HH:mm
@property (nonatomic , class , copy , readonly) NSString *(^timeSince1970)(NSTimeInterval interval);

// returns current week day ,@return @"1" , @"2" ...
@property (nonatomic , readonly) NSString * toWeek;

@property (nonatomic , readonly) NSString * toString;

@end
