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

CCQueue CC_MAIN_QUEUE() {
    return dispatch_get_main_queue();
}

static CCRuntime *_instance = nil;
+ (CCRuntime *(^)())runtime {
    return ^CCRuntime * {
        /*
        if (_instance) return _instance;
        _instance = [[CCRuntime alloc] init];
        return _instance;
         */
        if (_instance) return _instance;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[CCRuntime alloc] init];
        });
        return _instance;
    };
}
/*
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_instance) return _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:zone] init];
    });
    return _instance;
}
*/
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
        dispatch_async(q ? q : CC_MAIN_QUEUE(), t);
        return pSelf;
    };
}
- (CCRuntime *(^)(CCQueue, void (^)()))sync {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCQueue q, void (^t)()) {
        if (!q) return pSelf;
        dispatch_sync(q ? q : dispatch_queue_create("love.cc.love.home", NULL), t);
        return pSelf;
    };
}

- (CCRuntime *(^)(CCQueue, void (^)()))barrierAsync {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCQueue q , void (^t)()) {
        dispatch_barrier_async(q ? q : CC_MAIN_QUEUE(), t);
        return pSelf;
    };
}

- (CCRuntime *(^)(CCCount, CCQueue, void (^)(CCCount)))applyFor {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime * (CCCount c , CCQueue q , void (^t)(CCCount)) {
        dispatch_apply(c, q ? q : CC_MAIN_QUEUE(), t);
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

+ (CCQueue (^)(CCQueueQOS))global {
    return ^CCQueue (CCQueueQOS qos){
        /// for unsigned long flags , what's DOCs told that , it use for reserves for future needs .
        /// thus , for now , it's always be 0 .
        return dispatch_get_global_queue(qos, 0) ;
    };
}

@end

#pragma mark - -----

@implementation CCRuntime (CCChain_Group)

@dynamic group;
@dynamic queue;

CCGroup CC_GROUP_INIT() {
    return dispatch_group_create();
}

+ (CCRuntime *(^)(CCGroup, CCQueue))groupG {
    return ^CCRuntime *(CCGroup g , CCQueue q) {
        CCRuntime *r = CCRuntime.alloc.init;
        r.group = g;
        r.queue = q;
        return r;
    };
}

- (CCRuntime *(^)(void (^)()))groupAction {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime * (void (^t)()) {
        dispatch_group_async(pSelf.group, pSelf.queue, t);
        return pSelf;
    };
}

- (CCRuntime *(^)(CCQueue, void (^)()))notifyG {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCQueue q, void (^t)()) {
        dispatch_group_notify(pSelf.group, q, t);
        return pSelf;
    };
}

- (CCRuntime *(^)())enterG {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime * {
        dispatch_group_enter(pSelf.group);
        return pSelf;
    };
}

- (CCRuntime *(^)())leaveG {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime * {
        dispatch_group_leave(pSelf.group);
        return pSelf;
    };
}

- (CCRuntime *(^)(CCTime))waitG {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime *(CCTime t){
        dispatch_group_wait(pSelf.group, t);
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation CCRuntime (CCChain_Class)

- (CCRuntime *(^)(__unsafe_unretained Class, void (^)(NSDictionary<NSString *,NSString *> *)))getIVar {
    __weak typeof(self) pSelf = self;
    return ^CCRuntime * (Class c , void (^t)(NSDictionary<NSString *,NSString *> *)) {
        unsigned int iVars = 0;
        Ivar *ivarList = class_copyIvarList(c, &iVars);
        
        NSMutableDictionary <NSString * , NSString *> * dictionary = [NSMutableDictionary dictionary];
        for (unsigned int i = 0 ; i < iVars; i ++) {
            // get type and property names
            NSString *sMember = [NSString stringWithUTF8String:ivar_getName(ivarList[i])]; // output with _ , eg:_cc
            if ([sMember hasPrefix:@"_"]) {
                sMember = [sMember substringFromIndex:1];
            }
            // get ignores
            if ([c respondsToSelector:NSSelectorFromString(@"CCIgnores")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                NSArray *a = [c performSelector:NSSelectorFromString(@"CCIgnores")];
#pragma clang diagnostic pop
                if ([a containsObject:sMember]) continue;
            }
            
            NSString *sMemberType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])]; // output @"NSString"
            sMemberType = [sMemberType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]]; // compress
            [dictionary setValue:sMemberType // types can be found multi times , therefore , make it values .
                          forKey:sMember];
        }
        if (t) t(dictionary);
        return pSelf;
    };
}

- (CCRuntime *(^)(__unsafe_unretained Class, NSString *, SEL))addMethod {
    __weak typeof(self) pSelf = self;
    return ^(Class c , NSString *s , SEL sel) {
        class_addMethod(c,
                        NSSelectorFromString(s),
                        class_getMethodImplementation(c, sel),
                        "s@:@");
        return pSelf;
    };
}

@end
