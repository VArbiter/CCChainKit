
//
//  CCMediator+CCBridgeAPI.m
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCMediator+CCBridgeAPI.h"
#import "CCBridgeRouter.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

@implementation CCMediator (CCBridgeAPI)

+ (void (^)(dispatch_block_t))fallback {
    return ^(dispatch_block_t t) {
        CCBridgeRouter.shared().fallback(t);
    };
}

+ (void (^)(NSString *, id , void(^)(NSDictionary *)))regist {
    return ^(NSString *s , id b, void (^t)(NSDictionary *)) {
        CCBridgeRouter.shared().regist(s, b, t);
    };
}

+ (void (^)(NSString *, dispatch_block_t))call {
    return ^(NSString *s , dispatch_block_t t) {
        CCBridgeRouter.shared().call(s, t);
    };
}

+ (void (^)(NSString *, id, void(^)(id), dispatch_block_t))callP {
    return ^(NSString *s , id p , void(^c)(id) , dispatch_block_t f) {
        CCBridgeRouter.shared().callP(s, p, c, f);
    };
}

+ (void (^)(NSString *, id (^)(id)))object {
    return ^(NSString *url , id (^t)(id)) {
        CCBridgeRouter.shared().object(url, t);
    };
}

+ (id (^)(NSString *, NSDictionary *, dispatch_block_t))get {
    return ^id (NSString *url , NSDictionary * p, dispatch_block_t t) {
        return CCBridgeRouter.shared().get(url, p, t);
    };
}

@end

#endif
