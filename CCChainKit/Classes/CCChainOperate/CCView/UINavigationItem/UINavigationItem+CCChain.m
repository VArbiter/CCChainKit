//
//  UINavigationItem+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UINavigationItem+CCChain.h"

@implementation UINavigationItem (CCChain)

@end

#pragma mark - -----

@implementation UINavigationItem (CCChain_FixedSpace)

- (void (^)(CGFloat, UIBarButtonItem *))leftOffset {
    __weak typeof(self) pSelf = self;
    return ^void (CGFloat f , UIBarButtonItem * v) {
        if (f >= 0) return;
        UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:nil
                                                                                 action:nil];
        itemBar.width = f;
        NSArray *array = [NSArray arrayWithObjects:itemBar, v, nil];
        [pSelf setLeftBarButtonItems:array];
    };
}

- (void (^)(CGFloat, UIBarButtonItem *))rightOffset {
    __weak typeof(self) pSelf = self;
    return ^void (CGFloat f , UIBarButtonItem * v) {
        if (f >= 0) return;
        UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:nil
                                                                                 action:nil];
        itemBar.width = f;
        NSArray *array = [NSArray arrayWithObjects:itemBar, v, nil];
        [pSelf setRightBarButtonItems:array];
    };
}

@end
