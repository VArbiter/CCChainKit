//
//  NSObject+CCProtocol.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSObject+CCProtocol.h"

#import "CCCommon.h"

@implementation NSObject (CCProtocol)

- (instancetype)cc {
    return self;
}
+ (Class)cc {
    return self;
}

- (instancetype)cc:(id (^)(id))sameObject {
    CC(self);
    if (self && sameObject) return sameObject(self);
    return self;
}

- (instancetype)begin {
    return self;
}
- (void (^)())endT {
    return ^{};
}

+ (instancetype)CC_Non_NULL:(void (^)(id))setting {
    id value = [[self alloc] init];
    if (setting && value) setting(value);
    return value;
}

id CC_NON_NULL(Class clazz , void (^setting)(id value)) {
    id value = [[clazz alloc] init];
    if (setting) setting(value);
    return value;
}

@end
