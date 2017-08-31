//
//  CCMediator.m
//  CCSubModuleMediator
//
//  Created by Elwinfrederick on 24/07/2017.
//  Copyright © 2017 VArbiter. All rights reserved.
//

#import "CCMediator.h"

@implementation CCMediator

+ (id (^)(NSString *, NSString *, BOOL , id (^)()))perform {
    return ^id (NSString *t , NSString *a ,BOOL b , id(^p)()) {
        id m;
        if (p) m = p();
        Class ts = NSClassFromString(t);
        SEL as = NSSelectorFromString(a);
        
        if (!ts || !as || ![ts respondsToSelector:as]) return nil;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (b) return [ts performSelector:as withObject:m];
        else [ts performSelector:as withObject:m];
#pragma clang diagnostic pop
        return nil;
    };
}

@end
