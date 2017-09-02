//
//  CCProxyDealerMacro.h
//  CCChainKit
//
//  Created by 冯明庆 on 02/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#ifndef CCProxyDealerMacro_h
    #define CCProxyDealerMacro_h

/// simply simulat the muti-inhert of objective-C
/// note : if you want that CCProxyDealer to simulate the muti-inhert values
///     all your methods must be instance and interface in a protocol
/// note : and be sure do "#import <objc/runtime.h>" in your implementation file
/// eg :
///
/// @@protocol CCTestProtocol : <NSObject>
/// - (void) testMethod ;
/// @end
///
/// @interface CCSomeClass : NSObject < CCTestProtocol >
/// @end
///
/// @implementation CCSomeClass
///
/// - (void) testMethod {/* do sth. */}
///
/// @end

#ifndef CC_PROXY_DEALER_INTERFACE
    /// name , protocols that want to be simulated

    #define CC_PROXY_DEALER_INTERFACE(_name_ , ...) \
    @protocol CCProxyHolderProtocol <NSObject> \
    @end \
\
    @interface CCProxy_t_##_name_ : NSProxy < CCProxyHolderProtocol , ##__VA_ARGS__ > \
        + (instancetype) common ; \
        @property (nonatomic , class , copy , readonly) CCProxy_t_##_name_ *(^commonR)(NSArray <id> * aTargets); \
        @property (nonatomic , copy , readonly) CCProxy_t_##_name_ *(^registMethods)(NSArray <id> * aTargets); \
    @end

    #define CC_PROXY_DEALER_IMPLEMENTATION(_name_) \
\
    @interface CCProxy_t_##_name_  () \
    @property (nonatomic , strong) NSMutableDictionary *dMapMethods ; \
    @end \
\
    @implementation CCProxy_t_##_name_ \
\
    + (instancetype)common { \
        return [[self alloc] init]; \
    } \
\
    + (CCProxy_t_##_name_ *(^)(NSArray<id> *))commonR { \
        return ^CCProxy_t_##_name_ *(NSArray <id> *a ) { \
            return CCProxy_t_##_name_.common.registMethods(a); \
        }; \
    } \
\
    - (CCProxy_t_##_name_ *(^)(NSArray<id> *))registMethods { \
        __weak typeof(self) pSelf = self; \
        return ^CCProxy_t_##_name_ *(NSArray<id> *aTargets) { \
            for (id t in aTargets) { \
                unsigned int iMethods = 0; \
                Method *methodList = class_copyMethodList([t class], &iMethods); \
                for (int i = 0; i < iMethods; i ++) { \
                    Method tMethod = methodList[i]; \
                    SEL tSel = method_getName(tMethod); \
                    const char *tMethodName = sel_getName(tSel); \
                    [pSelf.dMapMethods setObject:t \
                                          forKey:[NSString stringWithUTF8String:tMethodName]]; \
                } \
                free(methodList); \
            } \
            return pSelf; \
        }; \
    } \
\
    - (void)forwardInvocation:(NSInvocation *)invocation { \
        SEL sel = invocation.selector; \
        NSString *sMethodName = NSStringFromSelector(sel); \
        id target = self.dMapMethods[sMethodName]; \
        if (target && [target respondsToSelector:sel]) [invocation invokeWithTarget:target]; \
        else [super forwardInvocation:invocation]; \
    } \
\
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel { \
        NSString *sMethodName = NSStringFromSelector(sel); \
        id target = self.dMapMethods[sMethodName]; \
        if (target && [target respondsToSelector:sel]) return [target methodSignatureForSelector:sel]; \
        else return [super methodSignatureForSelector:sel]; \
    } \
\
    - (NSMutableDictionary *)dMapMethods { \
        if (_dMapMethods) return _dMapMethods; \
        NSMutableDictionary *d = [NSMutableDictionary dictionary]; \
        _dMapMethods = d; \
        return _dMapMethods; \
    } \
\
    @end

#endif

#endif /* CCProxyDealerMacro_h */
