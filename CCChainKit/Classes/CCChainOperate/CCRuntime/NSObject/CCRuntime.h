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

typedef NS_ENUM(unsigned long , CCQueueQOS) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    CCQueueQOS_Default = 0,
    CCQueueQOS_High = 2,
    CCQueueQOS_Low = -2,
    CCQueueQOS_Background = INT16_MIN
#else
    CCQueueQOS_User_interaction = 0x21 , // user intercation , will finish as soon as possiable , DO NOT use it for large tasks !
    CCQueueQOS_User_Initiated = 0x19 , // what's user expacted , DO NOT use it for large tasks !
    CCQueueQOS_Default = 0x15 , // default , not for programmer . use it when you have to reset a serial tasks .
    CCQueueQOS_Utility = 0x11 , // recommended , (also availiable for large tasks)
    CCQueueQOS_Background = 0x09 , // background tasks .
    CCQueueQOS_Unspecified = 0x00 // unspecified , wait unit the system to specific one .
#endif
};

typedef dispatch_queue_t CCQueue;
typedef dispatch_group_t CCGroup;
typedef dispatch_source_t CCSource;
typedef dispatch_time_t CCTime;
typedef size_t CCCount;

@interface CCRuntime : NSObject

CCQueue CC_MAIN_QUEUE();

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
/// equals to dispatch_barrier_async
@property (nonatomic , copy , readonly) CCRuntime *(^barrierAsync)(CCQueue queue , void (^)());
/// equals to dispatch_apply
@property (nonatomic , copy , readonly) CCRuntime *(^applyFor)(CCCount count , CCQueue queue , void (^time)(CCCount t));
/// equals to objc_setAssociatedObject
@property (nonatomic , copy , readonly) CCRuntime *(^setAssociate)(id object , const void *key , id value , CCAssociationPolicy policy);
/// equals to objc_getAssociatedObject
@property (nonatomic , copy , readonly) id (^getAssociate)(id object , const void *key);

@end

#pragma mark - -----

@interface CCRuntime (CCChain_Queue)

@property (nonatomic , class , copy , readonly) CCQueue (^createQ)(const char * label , BOOL isSerial);
@property (nonatomic , class , copy , readonly) CCQueue (^global)(CCQueueQOS);

@end

#pragma mark - -----

@protocol CCRunTimeGroupProtocol <NSObject>

@property (nonatomic , strong) CCGroup group;
@property (nonatomic , strong) CCQueue queue;

@end

@interface CCRuntime (CCChain_Group) < CCRunTimeGroupProtocol >

CCGroup CC_GROUP_INIT();

/// return a new object of CCRuntime , not the shared instance .
@property (nonatomic , class , copy , readonly) CCRuntime *(^groupG)(CCGroup group , CCQueue queue);
/// actions for group
@property (nonatomic , copy , readonly) CCRuntime *(^groupAction)(void (^actions)());
/// when all group actions finished
@property (nonatomic , copy , readonly) CCRuntime *(^notifyG)(CCQueue queue , void(^finish)());

/// enter and leave mast use it with a pair
/// enter a group
@property (nonatomic , copy , readonly) CCRuntime *(^enterG)();
/// leave a group
@property (nonatomic , copy , readonly) CCRuntime *(^leaveG)();
/// do someting after delay .
@property (nonatomic , copy , readonly) CCRuntime *(^waitG)(CCTime time);

@end

#pragma mark - -----

@protocol CCChainClassProtocol <NSObject>

/// for some properties that don't want be found .
+ (NSArray <NSString *> *) CCIgnores ;

@end

@interface CCRuntime (CCChain_Class)

/// class that want to be found , <types , properties>
@property (nonatomic , copy , readonly) CCRuntime *(^getIVar)(Class clazz , void (^finish)(NSDictionary <NSString * , NSString *> *dictionary));
/// add a method with one argument .
@property (nonatomic , copy , readonly) CCRuntime *(^addMethod)(Class clazz, NSString *selName , SEL impSupply) ;

@end


