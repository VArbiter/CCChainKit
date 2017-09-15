//
//  CCBridgeRouter.h
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MGJRouter/MGJRouter.h>)

@import MGJRouter;

@interface CCBridgeRouter : NSObject

@property (nonatomic , class , copy , readonly) CCBridgeRouter *(^shared)();

/// fallBack
@property (nonatomic , copy , readonly) CCBridgeRouter *(^fallback)(dispatch_block_t);
/// url  , actions
@property (nonatomic , copy , readonly) CCBridgeRouter *(^regist)(NSString * , void (^)(NSDictionary *dValue));
/// url , fallback
@property (nonatomic , copy , readonly) CCBridgeRouter *(^call)(NSString * , dispatch_block_t);
/// url , userinfo , fallback
@property (nonatomic , copy , readonly) CCBridgeRouter *(^callP)(NSString * , id , dispatch_block_t);
/// url , value
@property (nonatomic , copy , readonly) CCBridgeRouter *(^object)(NSString * , id (^)(id value));
/// url , fallback
@property (nonatomic , copy , readonly) id (^get)(NSString * , dispatch_block_t);
/// url , params , fallback
@property (nonatomic , copy , readonly) id (^getP)(NSString * , NSDictionary * , dispatch_block_t);

FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_URL_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_COMPLETION_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_USER_INFO_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_FALL_BACK_URL_ ;

@end

#endif
