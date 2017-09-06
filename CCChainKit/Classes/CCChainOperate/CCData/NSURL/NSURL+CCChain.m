//
//  NSURL+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSURL+CCChain.h"

@implementation NSURL (CCChain)

+ (NSURL *(^)(NSString *))urlT {
    return ^NSURL *(NSString *s) {
        return [NSURL URLWithString:(s && s.length) ? s : @""];
    };
}

+ (NSURL *(^)(NSString *))local {
    return ^NSURL *(NSString *s) {
        return [NSURL fileURLWithPath:(s && s.length) ? s : @""];
    };
}

@end
