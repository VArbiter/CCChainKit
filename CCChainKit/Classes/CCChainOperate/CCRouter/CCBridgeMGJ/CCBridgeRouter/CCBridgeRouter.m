//
//  CCBridgeRouter.m
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCBridgeRouter.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

NSString * const _CC_ROUTER_PARAMS_URL_ = @"CC_ROUTER_PARAMS_URL";
NSString * const _CC_ROUTER_PARAMS_COMPLETION_ = @"CC_ROUTER_PARAMS_COMPLETION";
NSString * const _CC_ROUTER_PARAMS_USER_INFO_ = @"CC_ROUTER_PARAMS_USER_INFO";
NSString * const _CC_ROUTER_FALL_BACK_URL_ = @"loveCC://";

@interface CCBridgeRouter () < NSCopying , NSMutableCopying >

@property (nonatomic , copy , readonly) NSString *(^format)(NSString *);

@property (nonatomic , copy , readonly) NSDictionary *(^transferMGJ)(NSDictionary *d) ;

@end

static CCBridgeRouter *__router = nil;

@implementation CCBridgeRouter

+ (CCBridgeRouter *(^)())shared {
    return ^CCBridgeRouter * {
        if (__router) return __router;
        __router = [[CCBridgeRouter alloc] init];
        return __router;
    };
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__router) return __router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __router = [super allocWithZone:zone];
    });
    return __router;
}

- (id)copyWithZone:(NSZone *)zone {
    return __router;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __router;
}

#pragma mark - 

- (CCBridgeRouter * (^)(dispatch_block_t))fallback {
    __weak typeof(self) pSelf = self;
    return ^CCBridgeRouter *(dispatch_block_t t) {
        [MGJRouter registerURLPattern:_CC_ROUTER_FALL_BACK_URL_ toHandler:^(NSDictionary *routerParameters) {
            if (t) t();
        }];
        return pSelf;
    };
}

- (CCBridgeRouter * (^)(NSString * , void(^)(NSDictionary *)))regist {
    __weak typeof(self) pSelf = self;
    return ^CCBridgeRouter *(NSString *url , void(^t)(NSDictionary *)) {
        [MGJRouter registerURLPattern:pSelf.format(url) toHandler:^(NSDictionary *routerParameters) {
            if (t) t(pSelf.transferMGJ(routerParameters));
        }];
        return pSelf;
    };
}

- (CCBridgeRouter * (^)(NSString * , dispatch_block_t))call {
    __weak typeof(self) pSelf = self;
    return ^CCBridgeRouter *(NSString *url , dispatch_block_t t) {
        if ([MGJRouter canOpenURL:pSelf.format(url)]) {
            [MGJRouter openURL:pSelf.format(url)];
        } else if (t) t();
        return pSelf;
    };
}

- (CCBridgeRouter * (^)(NSString *, id, dispatch_block_t))callP {
    __weak typeof(self) pSelf = self;
    return ^CCBridgeRouter *(NSString *url , id p , dispatch_block_t f) {
        if (![MGJRouter canOpenURL:pSelf.format(url)]) {
            if (f) f();
            return pSelf;
        }
        
        [MGJRouter openURL:pSelf.format(url) withUserInfo:p completion:nil];
        return pSelf;
    };
}

- (CCBridgeRouter * (^)(NSString *, id (^)(id)))object {
    __weak typeof(self) pSelf = self;
    return ^CCBridgeRouter *(NSString *url , id (^t)(id)) {
        [MGJRouter registerURLPattern:pSelf.format(url) toObjectHandler:^id(NSDictionary *routerParameters) {
            if (t) return t(pSelf.transferMGJ(routerParameters));
            return nil;
        }];
        return pSelf;
    };
}

- (id (^)(NSString *, dispatch_block_t))get {
    __weak typeof(self) pSelf = self;
    return ^id (NSString *url , dispatch_block_t t) {
        return pSelf.getP(url, nil, t);
    };
}

- (id (^)(NSString *, NSDictionary *, dispatch_block_t))getP {
    __weak typeof(self) pSelf = self;
    return ^id (NSString *url , NSDictionary * p, dispatch_block_t t) {
        id v = [MGJRouter objectForURL:pSelf.format(url) withUserInfo:p];
        if (v) return v;
        else if (t) t();
        return nil;
    };
}

#pragma mark - Private

- (NSString *(^)(NSString *))format {
    return ^NSString *(NSString *s) {
        if (s.length <= 0) {
            return _CC_ROUTER_FALL_BACK_URL_;
        }
        if ([s hasPrefix:@"/"]) {
            return [_CC_ROUTER_FALL_BACK_URL_ stringByAppendingString:[s substringFromIndex:1]];
        }
        if ([s rangeOfString:_CC_ROUTER_FALL_BACK_URL_].location != NSNotFound) {
            return s;
        }
        return _CC_ROUTER_FALL_BACK_URL_;
    };
}

- (NSDictionary *(^)(NSDictionary *))transferMGJ {
    return ^NSDictionary *(NSDictionary *d) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:d[MGJRouterParameterURL] forKey:_CC_ROUTER_PARAMS_URL_];
        [dict setValue:d[MGJRouterParameterCompletion] forKey:_CC_ROUTER_PARAMS_COMPLETION_];
        [dict setValue:d[MGJRouterParameterUserInfo] forKey:_CC_ROUTER_PARAMS_USER_INFO_];
        return dict;
    };
}

@end

#endif
