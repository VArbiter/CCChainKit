//
//  NSTimer+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CCChain)

// timer
@property (nonatomic , class , copy , readonly) NSTimer *(^timerS)(NSTimeInterval interval , void(^)(NSTimer *sender));
@property (nonatomic , class , copy , readonly) NSTimer *(^timerC)(NSTimeInterval interval , BOOL isRepeat , void(^)(NSTimer *sender));
@property (nonatomic , class , copy , readonly) NSTimer *(^timerU)(NSTimeInterval interval , id userInfo , BOOL isRepeat , void(^)(NSTimer *sender));

/// scheduled
@property (nonatomic , class , copy , readonly) NSTimer *(^scheduledS)(NSTimeInterval interval , void(^)(NSTimer *sender));
@property (nonatomic , class , copy , readonly) NSTimer *(^scheduledC)(NSTimeInterval interval , BOOL isRepeat , void(^)(NSTimer *sender));
@property (nonatomic , class , copy , readonly) NSTimer *(^scheduledU)(NSTimeInterval interval , id userInfo , BOOL isRepeat , void(^)(NSTimer *sender));

@property (nonatomic , copy , readonly) void (^invalidateS)();

/// invalidate && set entity to nil.
void CC_TIMER_DESTORY(NSTimer *timer);

@end
