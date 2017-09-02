//
//  CCBridgeRouter.h
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MGJRouter/MGJRouter.h>)

@interface CCBridgeRouter : NSObject

@property (nonatomic , class , copy , readonly) CCBridgeRouter *(^shared)();

/// fallBack
@property (nonatomic , copy , readonly) void(^fallback)(dispatch_block_t);
/// url , binding , params
@property (nonatomic , copy , readonly) void(^regist)(NSString * , id , void (^)(NSDictionary *dValue));
/// url , fallback
@property (nonatomic , copy , readonly) void(^call)(NSString * , dispatch_block_t);
/// url , params , userinfo , fallback
@property (nonatomic , copy , readonly) void(^callP)(NSString * , id , void(^)(id value) , dispatch_block_t);
/// url , value
@property (nonatomic , copy , readonly) void(^object)(NSString * , id (^)(id value));
/// url , params , fallback
@property (nonatomic , copy , readonly) id (^get)(NSString * , NSDictionary * , dispatch_block_t);

@end

#endif
