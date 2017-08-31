//
//  UIFont+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIFont+CCChain.h"

@implementation UIFont (CCChain)

- (UIFont *(^)(CGFloat))sizeT {
    __weak typeof(self) pSelf = self;
    return ^UIFont * (CGFloat f) {
        return [pSelf fontWithSize:f];
    };
}

+ (UIFont *(^)(CGFloat))system {
    return ^UIFont *(CGFloat f) {
        return [UIFont systemFontOfSize:f];
    };
}

+ (UIFont *(^)(CGFloat))bold {
    return ^UIFont *(CGFloat f) {
        return [UIFont boldSystemFontOfSize:f];
    };
}

+ (UIFont *(^)(NSString *, CGFloat))names {
    return ^UIFont * (NSString *s , CGFloat f) {
        if ([s isKindOfClass:NSString.class] && s && s.length) {
            return [UIFont fontWithName:s size:f];
        }
        return self.system(f);
    };
}

@end
