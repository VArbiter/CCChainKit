//
//  CCRuntime.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRuntime.h"
#import <objc/runtime.h>

@interface CCRuntime () < NSCopying , NSMutableCopying >

@end

@implementation CCRuntime

static CCRuntime *_instance = nil;
+ (CCRuntime *(^)())runtime {
    return ^CCRuntime * {
        if (_instance) return _instance;
        _instance = [[CCRuntime alloc] init];
        return _instance;
    };
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_instance) return _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:zone] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (CCRuntime *(^)(SEL, SEL))swizz {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(SEL os , SEL ts) {
        Method om = class_getInstanceMethod(self.class, os);
        Method tm = class_getInstanceMethod(self.class, ts);
        if (class_addMethod(self.class,os,method_getImplementation(tm),method_getTypeEncoding(tm))) {
            class_replaceMethod(self.class,ts,method_getImplementation(om),method_getTypeEncoding(om));
        }
        else method_exchangeImplementations(om, tm);
        return pSelf;
    };
}

- (CCRuntime *(^)(NSTimeInterval, BOOL (^)(), void (^)()))timer {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(NSTimeInterval t , BOOL (^b)() , void (^c)()) {
        if (!b) return pSelf;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), t * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            if (b()) dispatch_source_cancel(timer);
        });
        dispatch_source_set_cancel_handler(timer, ^{
            dispatch_group_leave(group);
            if (c) c();
        });
        dispatch_resume(timer);
        return pSelf;
    };
}

- (CCRuntime *(^)(double, void (^)()))after {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(double f , void (^t)()) {
        if (!t) return pSelf;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (t) t();
        });
        return pSelf;
    };
}

- (CCRuntime *(^)(void (^)()))asyncM {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(void (^t)()) {
        return pSelf.async(dispatch_get_main_queue(), t);
    };
}
- (CCRuntime *(^)(void (^)()))syncM {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(void (^t)()) {
        return pSelf.sync(dispatch_get_main_queue(), t);
    };
}

- (CCRuntime *(^)(CCQueue, void (^)()))async {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCQueue q, void (^t)()) {
        if (!q) return pSelf;
        dispatch_async(q, ^{
            if (t) t();
        });
        return pSelf;
    };
}
- (CCRuntime *(^)(CCQueue, void (^)()))sync {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCQueue q, void (^t)()) {
        if (!q) return pSelf;
        dispatch_sync(q, ^{
            if (t) t();
        });
        return pSelf;
    };
}

- (CCRuntime *(^)(id, const void *, id, CCAssociationPolicy))setAssociate {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(id o, const void *k, id v, CCAssociationPolicy p){
        objc_setAssociatedObject(o, k, v, (objc_AssociationPolicy)p);
        return pSelf;
    };
}

- (id (^)(id, const void *))getAssociate {
    return ^CCRuntime * (id o, const void *k){
        return objc_getAssociatedObject(o, k);
    };
}

@end

#pragma mark - -----

@implementation CCRuntime (CCChain_Queue)

+ (CCQueue (^)(const char *, BOOL))createQ {
    return ^CCQueue (const char * c, BOOL b){
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
            return dispatch_queue_create(c, b ? NULL : DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
        } else return dispatch_queue_create(c, b ? NULL : DISPATCH_QUEUE_CONCURRENT);
    };
}

@end
