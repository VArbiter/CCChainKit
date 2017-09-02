//
//  CCProxyDealer.h
//  CCChainKit
//
//  Created by 冯明庆 on 02/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _CC_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_
    //#define _CC_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_
#endif

#ifdef _CC_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_

/// simply simulat the muti-inhert of objective-C
/// note : if you want that CCProxyDealer to simulate the muti-inhert values
///     all your methods must be instance and interface in a protocol
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

@interface CCProxyDealer : NSProxy 

/// it's not a singleton .
+ (instancetype) common ;
@property (nonatomic , class , copy , readonly) CCProxyDealer *(^commonR)(NSArray <id> * aTargets);

/// regist targets , only instance methods allowed (CCProxyDealer is an instance)
@property (nonatomic , copy , readonly) CCProxyDealer *(^registMethods)(NSArray <id> * aTargets);

@end

#endif
