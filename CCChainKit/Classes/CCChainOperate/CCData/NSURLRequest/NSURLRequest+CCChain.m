//
//  NSURLRequest+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSURLRequest+CCChain.h"
#import "NSURL+CCChain.h"

@implementation NSURLRequest (CCChain)

+ (NSURLRequest *(^)(NSString *))requestT {
    return ^NSURLRequest *(NSString *s) {
        return [NSURLRequest requestWithURL:NSURL.urlT(s)];
    };
}

+ (NSURLRequest *(^)(NSString *))localT {
    return ^NSURLRequest *(NSString *s) {
        return [NSURLRequest requestWithURL:NSURL.local(s)];
    };
}

@end

#pragma mark - -----

@implementation NSMutableURLRequest (CCChain)

+ (NSMutableURLRequest *(^)(NSString *))requestT {
    return ^NSMutableURLRequest *(NSString *s) {
        return [NSMutableURLRequest requestWithURL:NSURL.urlT(s)];
    };
}

+ (NSMutableURLRequest *(^)(NSString *))localT {
    return ^NSMutableURLRequest *(NSString *s) {
        return [NSMutableURLRequest requestWithURL:NSURL.local(s)];
    };
}

@end
