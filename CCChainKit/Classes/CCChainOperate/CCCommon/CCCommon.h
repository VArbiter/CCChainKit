//
//  CCCommon.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
    #define _CC_IS_SIMULATOR_ 1
#else
    #define _CC_IS_SIMULATOR_ 0
#endif

/// formatStrings.
#define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
#define ccString(VALUE) [NSString stringWithFormat:@"%@",(VALUE)]

/// manually control debug mode .
/// if not CC_SET_DEBUG_MODE , returns 1 if debug , 0 if release.
static int _CC_DEBUG_MODE_;

#if _CC_DEBUG_MODE_
    #define CCLog(fmt , ...) NSLog((@"\n\n_CC_LOG_\n\n_CC_FILE_  %s\n_CC_METHOND_  %s\n_CC_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
#else
    #define CCLog(fmt , ...) /* */
#endif

#define CC_CLASS(VALUE) typeof(VALUE) sameT##VALUE = VALUE

#define CC_WEAK_INSTANCE(VALUE) __unsafe_unretained typeof(VALUE) weakT##VALUE = VALUE
#define CC_WEAK_SELF __weak typeof(&*self) pSelf = self
#define CC_TYPE(_type_ , _value_) ((_type_)_value_) // forced transfer with a specific type

/// returns uuid
static NSString * _CC_UUID_;

@interface CCCommon : NSObject

void CC_SET_DEBUG_MODE(BOOL isOn);

BOOL CC_IS_MAIN_QUEUE();

BOOL CC_Available_C(double version);
void CC_Available_S(double version , void(^s)() , void(^f)());

/// if not in the main thread, operation will sync to it.
void CC_Main_Thread_Sync(void (^)());
/// if not in the main thread, operation will async to it.
void CC_Main_Thread_Async(void (^)());

/// operation for debug and release
void CC_DEBUG(void (^debug)() , void (^release)());

/// operation for debug and release , also , can be controlled manually
/// -1 DEBUG , 0 auto , 1 release
void CC_DEBUG_M(int mark , void (^debug)() , void (^release)());

/// if is SIMULATOR
void CC_DETECT_SIMULATOR(void (^y)() , void (^n)());

/// make sure that if a chain has started ,
/// no 'nil' return for next chain actions . (if does , system will crash immediately) .
void CC_SAFED_CHAIN(id object , void (^safe)(id object));

@end
