//
//  CCMediator+CCBridgeAPI.h
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCMediator.h"

#if __has_include(<MGJRouter/MGJRouter.h>)
#import "CCBridgeRouter.h"

@interface CCMediator (CCBridgeAPI)

/// for urls that can not be found
@property (nonatomic , class , copy , readonly) void (^fallback)(dispatch_block_t);
/// url , action
@property (nonatomic , class , copy , readonly) void (^regist)(NSString * , void (^)(NSDictionary *dValue));
/// url , fallback
@property (nonatomic , class , copy , readonly) void (^call)(NSString * , dispatch_block_t);
/// url , userinfo , fallback
@property (nonatomic , class , copy , readonly) void (^callP)(NSString * , id , dispatch_block_t);
/// url , value
@property (nonatomic , class , copy , readonly) void (^object)(NSString * , id (^)(id value));
/// url , fallback
@property (nonatomic , class , copy , readonly) id (^get)(NSString * , dispatch_block_t);
/// url , params , fallback
@property (nonatomic , class , copy , readonly) id (^getP)(NSString * , NSDictionary * , dispatch_block_t);

@end

#endif
