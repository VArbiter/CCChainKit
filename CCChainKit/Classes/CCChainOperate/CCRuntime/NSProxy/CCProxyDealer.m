//
//  CCProxyDealer.m
//  CCChainKit
//
//  Created by 冯明庆 on 02/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCProxyDealer.h"

#ifdef _CC_PROXY_DELER_PROTOCOL_
#import <objc/runtime.h>

@interface CCProxyDealer ()

@property (nonatomic , strong) NSMutableDictionary *dMapMethods ;

@end

@implementation CCProxyDealer

+ (instancetype)common {
    return [[self alloc] init];
}

+ (CCProxyDealer *(^)(NSArray<id> *))commonR {
    return ^CCProxyDealer *(NSArray <id> *a ) {
        return CCProxyDealer.common.registMethods(a);
    };
}

- (CCProxyDealer *(^)(NSArray<id> *))registMethods {
    __weak typeof(self) pSelf = self;
    return ^CCProxyDealer *(NSArray<id> *aTargets) {
        for (id t in aTargets) {
            unsigned int iMethods = 0; // methods count
            // get target methods list
            Method *methodList = class_copyMethodList([t class], &iMethods);
            
            for (int i = 0; i < iMethods; i ++) {
                // get names of methods and stored in dictionary
                Method tMethod = methodList[i];
                SEL tSel = method_getName(tMethod);
                const char *tMethodName = sel_getName(tSel);
                [pSelf.dMapMethods setObject:t
                                      forKey:[NSString stringWithUTF8String:tMethodName]];
            }
            free(methodList);
        }
        return pSelf;
    };
}

#pragma mark - ----
// override NSProxy methods

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector; // find current selector that selected
    NSString *sMethodName = NSStringFromSelector(sel); // get sel 's method name
    id target = self.dMapMethods[sMethodName]; // find target in dictionary
    
    // check target
    if (target && [target respondsToSelector:sel]) [invocation invokeWithTarget:target];
    else [super forwardInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSString *sMethodName = NSStringFromSelector(sel);
    id target = self.dMapMethods[sMethodName];
    
    if (target && [target respondsToSelector:sel]) return [target methodSignatureForSelector:sel];
    else return [super methodSignatureForSelector:sel];
}

- (NSMutableDictionary *)dMapMethods {
    if (_dMapMethods) return _dMapMethods;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    _dMapMethods = d;
    return _dMapMethods;
}

@end

#endif
