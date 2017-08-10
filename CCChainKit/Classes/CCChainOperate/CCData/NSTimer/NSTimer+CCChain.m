//
//  NSTimer+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSTimer+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_NSTIMER_ASSOCIATE_TIMER_KEY_ = "CC_NSTIMER_ASSOCIATE_TIMER_KEY";
static const char * _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_ = "CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY";

@interface NSTimer (CCChain_Assit)

+ (void) ccTimerAction : (NSTimer *) sender ;

@end

@implementation NSTimer (CCChain_Assit)

+ (void) ccTimerAction : (NSTimer *) sender {
    void (^t)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_TIMER_KEY_);
    if (t) t(sender);
    void (^s)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_);
    if (s) s(sender);
}

@end

#pragma mark - -----

@implementation NSTimer (CCChain)

+ (NSTimer *(^)(NSTimeInterval, void (^)(NSTimer *)))timerS {
    return ^NSTimer *(NSTimeInterval interval, void (^t)(NSTimer *)) {
        return self.timerC(interval , YES , t);
    };
}

+ (NSTimer *(^)(NSTimeInterval, BOOL, void (^)(NSTimer *)))timerC {
    return ^NSTimer *(NSTimeInterval interval, BOOL isRepeat, void (^t)(NSTimer *)) {
        return self.timerU(interval , nil , isRepeat , t);
    };
}

+ (NSTimer *(^)(NSTimeInterval, id, BOOL, void (^)(NSTimer *)))timerU {
    return ^ NSTimer *(NSTimeInterval interval, id userInfo, BOOL isRepeat, void (^t)(NSTimer *)){
        NSTimer *tTimer = [NSTimer timerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(ccTimerAction:)
                                                userInfo:userInfo
                                                 repeats:isRepeat];
        objc_setAssociatedObject(tTimer, _CC_NSTIMER_ASSOCIATE_TIMER_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return tTimer;
    };
}

+ (NSTimer *(^)(NSTimeInterval, void (^)(NSTimer *)))scheduledS {
    return ^NSTimer *(NSTimeInterval interval, void (^t)(NSTimer *)) {
        return self.scheduledC(interval , YES , t);
    };
}

+ (NSTimer *(^)(NSTimeInterval, BOOL, void (^)(NSTimer *)))scheduledC {
    return ^NSTimer *(NSTimeInterval interval, BOOL isRepeat, void (^t)(NSTimer *)) {
        return self.scheduledU(interval , nil , isRepeat , t);
    };
}

+ (NSTimer *(^)(NSTimeInterval, id, BOOL, void (^)(NSTimer *)))scheduledU {
    return ^ NSTimer *(NSTimeInterval interval, id userInfo, BOOL isRepeat, void (^t)(NSTimer *)){
        NSTimer *tTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                           target:self
                                                         selector:@selector(ccTimerAction:)
                                                         userInfo:userInfo
                                                          repeats:isRepeat];
        objc_setAssociatedObject(tTimer, _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return tTimer;
    };
}

- (void (^)())invalidateS {
    __weak typeof(self) pSelf = self;
    return ^ {
        [pSelf invalidate];
    };
}

void CC_TIMER_DESTORY(NSTimer *timer){
    [timer invalidate];
    timer = nil;
}

@end
