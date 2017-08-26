//
//  NSObject+CCProtocol.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSObject+CCProtocol.h"

@implementation NSObject (CCProtocol)

- (instancetype)cc {
    return self;
}
+ (Class)cc {
    return self;
}

- (instancetype)ccS:(id (^)(id))sameObject {
    if (self && sameObject) return sameObject(self);
    return self;
}

- (instancetype)begin {
    return self;
}
- (void)end {}

@end
