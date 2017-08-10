//
//  CCRuntime.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned long , CCAssociationPolicy) {
    CCAssociationPolicy_assign = 0,
    CCAssociationPolicy_retain_nonatomic = 1,
    CCAssociationPolicy_copy_nonatomic = 3,
    CCAssociationPolicy_retain = 01401,
    CCAssociationPolicy_copy = 01403
};

typedef NS_ENUM(unsigned long , CCQueuePriority) {
    CCQueuePriority_Default = 0,
    CCQueuePriority_High = 2,
    CCQueuePriority_Low = -2,
    CCQueuePriority_Background = INT16_MIN 
};

typedef dispatch_queue_t CCQueue;
typedef dispatch_group_t CCGroup;
typedef dispatch_source_t CCSource;

@interface CCRuntime : NSObject
/// absolute singleton
@property (nonatomic , class , copy , readonly) CCRuntime *(^runtime)();

/// original selector , target selector
@property (nonatomic , copy , readonly) CCRuntime *(^swizz)(SEL original , SEL target);
/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it);
@property (nonatomic , copy , readonly) CCRuntime *(^timer)(NSTimeInterval interval , BOOL (^)() , void (^)());
/// interval time , actions
@property (nonatomic , copy , readonly) CCRuntime *(^after)(double seconds , void (^)());
/// async to main
@property (nonatomic , copy , readonly) CCRuntime *(^asyncM)(void (^)());
/// sync to main . warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .  
@property (nonatomic , copy , readonly) CCRuntime *(^syncM)(void (^)());
/// async to specific queue
@property (nonatomic , copy , readonly) CCRuntime *(^async)(CCQueue queue , void (^)());
/// sync to specific queue , warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .
@property (nonatomic , copy , readonly) CCRuntime *(^sync)(CCQueue queue , void (^)());
/// equals to objc_setAssociatedObject
@property (nonatomic , copy , readonly) CCRuntime *(^setAssociate)(id object , const void *key , id value , CCAssociationPolicy policy);
/// equals to objc_getAssociatedObject
@property (nonatomic , copy , readonly) id (^getAssociate)(id object , const void *key);

@end

@interface CCRuntime (CCChain_Queue)

@property (nonatomic , class , copy , readonly) CCQueue (^createQ)(const char * label , BOOL isSerial);
@property (nonatomic , class , copy , readonly) CCQueue (^global)()

@end
