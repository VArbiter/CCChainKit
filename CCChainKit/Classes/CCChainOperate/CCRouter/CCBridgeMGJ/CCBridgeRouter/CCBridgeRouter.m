//
//  CCBridgeRouter.m
//  RisSubModule
//
//  Created by Elwinfrederick on 04/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCBridgeRouter.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

#import <MGJRouter/MGJRouter.h>

@interface CCBridgeRouter () < NSCopying , NSMutableCopying >

@property (nonatomic , copy , readonly) NSString *(^format)(NSString *);
@property (nonatomic , copy , readonly) NSString *(^append)(NSString *);

@end

static CCBridgeRouter *_router = nil;
static NSString * _CC_ROUTER_FALL_BACK_URL_ = @"loveCC://";

@implementation CCBridgeRouter

+ (CCBridgeRouter *(^)())shared {
    return ^CCBridgeRouter * {
        if (_router) return _router;
        _router = [[CCBridgeRouter alloc] init];
        return _router;
    };
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_router) return _router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [super allocWithZone:zone];
    });
    return _router;
}

- (id)copyWithZone:(NSZone *)zone {
    return _router;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _router;
}

#pragma mark - 

- (void (^)(dispatch_block_t))fallback {
    return ^(dispatch_block_t t) {
        [MGJRouter registerURLPattern:_CC_ROUTER_FALL_BACK_URL_ toHandler:^(NSDictionary *routerParameters) {
            if (t) t();
        }];
    };
}

- (void (^)(NSString *, id , void(^)(NSDictionary *)))regist {
    __weak typeof(self) pSelf = self;
    return ^(NSString *url , id b, void(^t)(NSDictionary *)) {
        if (b) pSelf.object(url, ^id (id value){
            return b;
        });
        [MGJRouter registerURLPattern:pSelf.format(url) toHandler:^(NSDictionary *routerParameters) {
            if (t) t(routerParameters[MGJRouterParameterUserInfo]);
        }];
    };
}

- (void (^)(NSString * , dispatch_block_t))call {
    __weak typeof(self) pSelf = self;
    return ^(NSString *url , dispatch_block_t t) {
        if ([MGJRouter canOpenURL:pSelf.format(url)]) {
            [MGJRouter openURL:pSelf.format(url)];
        } else if (t) t();
    };
}

- (void (^)(NSString *, id, void(^)(id), dispatch_block_t))callP {
    __weak typeof(self) pSelf = self;
    return ^(NSString *url , id p , void(^c)(id) , dispatch_block_t f) {
        if (![MGJRouter canOpenURL:pSelf.format(url)]) {
            if (f) f();
            return ;
        }
        
        [MGJRouter openURL:pSelf.format(url) withUserInfo:p completion:nil];
        if (c) c(pSelf.get(url, nil, ^{
            if (f) f();
        }));
    };
}

- (void (^)(NSString *, id (^)(id)))object {
    __weak typeof(self) pSelf = self;
    return ^(NSString *url , id (^t)(id)) {
        [MGJRouter registerURLPattern:pSelf.append(pSelf.format(url)) toObjectHandler:^id(NSDictionary *routerParameters) {
            if (t) return t(routerParameters[MGJRouterParameterUserInfo]);
            return nil;
        }];
    };
}

- (id (^)(NSString *, NSDictionary *, dispatch_block_t))get {
    __weak typeof(self) pSelf = self;
    return ^id (NSString *url , NSDictionary * p, dispatch_block_t t) {
        id v = [MGJRouter objectForURL:pSelf.append(pSelf.format(url)) withUserInfo:p];
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

- (NSString *(^)(NSString *))append {
    return ^NSString *(NSString * s) {
        if (s) return [s stringByAppendingString:@"/cc_append_object"];
        return [s stringByAppendingString:@""];
    };
}

@end

#endif
