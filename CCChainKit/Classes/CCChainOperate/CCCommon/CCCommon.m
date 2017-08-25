//
//  CCCommon.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCCommon.h"

#import <UIKit/UIKit.h>
#import <pthread.h>

@implementation CCCommon

+ (void)load {
#if DEBUG
    _CC_DEBUG_MODE_ = 1;
#else
    _CC_DEBUG_MODE_ = 0;
#endif
    
    _CC_UUID_ = [UIDevice currentDevice].identifierForVendor.UUIDString;
}

void CC_SET_DEBUG_MODE(BOOL isOn) {
    _CC_DEBUG_MODE_ = (int) isOn;
}

BOOL CC_Available_C(double version) {
    return UIDevice.currentDevice.systemVersion.floatValue >= version;
}

void CC_Available_S(double version , void(^s)() , void(^f)()) {
    if (CC_Available_C(version)) {
        if (s) s();
    }
    else if (f) f();
}

BOOL CC_IS_MAIN_QUEUE() {
    return pthread_main_np() != 0;
}

void CC_Main_Thread_Sync(void (^t)()) {
    if (CC_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_sync(dispatch_get_main_queue(), t);
}

void CC_Main_Thread_Async(void (^t)()) {
    if (CC_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_async(dispatch_get_main_queue(), t);
}

void CC_DEBUG(void (^debug)() , void (^release)()) {
    if (_CC_DEBUG_MODE_) {
        if (debug) debug();
    } else if (release) release();
}

/// -1 DEBUG , 0 auto , 1 release
void CC_DEBUG_M(int mark , void (^debug)() , void (^release)()) {
    if (mark == 0) {
        if (_CC_DEBUG_MODE_) {
            if (debug) debug();
        } else if (release) release();
    } else if (mark > 0) {
        if (release) release();
    } else if (debug) debug();
}

void CC_DETECT_SIMULATOR(void (^y)() , void (^n)()) {
    if (_CC_IS_SIMULATOR_) {
        if (y) y();
    } else if (n) n();
}

void CC_SAFED_CHAIN(id object , void (^safe)(id object)) {
    if (object && safe) safe(object);
}

@end
