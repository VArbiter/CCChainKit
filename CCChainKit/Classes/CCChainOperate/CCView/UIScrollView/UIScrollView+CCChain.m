//
//  UIScrollView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIScrollView+CCChain.h"

@implementation UIScrollView (CCChain)

+ ( __kindof UIScrollView *(^)(CGRect))common {
    return ^ __kindof UIScrollView *(CGRect r) {
        UIScrollView *v = [[UIScrollView alloc] initWithFrame:r];
        v.backgroundColor = UIColor.clearColor;
        return v;
    };
}

- ( __kindof UIScrollView *(^)(CGSize))contentSizeT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIScrollView *(CGSize size) {
        pSelf.contentSize = size;
        return pSelf;
    };
}

- ( __kindof UIScrollView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIScrollView *(id d) {
        pSelf.delegate = d;
        return pSelf;
    };
}

- ( __kindof UIScrollView *(^)(CGPoint))animatedOffset {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIScrollView *(CGPoint p) {
        return pSelf.animatedOffsetT(p , YES);
    };
}

- ( __kindof UIScrollView *(^)(CGPoint, BOOL))animatedOffsetT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIScrollView *(CGPoint p , BOOL b) {
        [pSelf setContentOffset:p
                       animated:b];
        return pSelf;
    };
}

- ( __kindof UIScrollView *)hideVerticalIndicator {
    self.showsVerticalScrollIndicator = false;
    return self;
}

- ( __kindof UIScrollView *)hideHorizontalIndicator {
    self.showsHorizontalScrollIndicator = false;
    return self;
}

- ( __kindof UIScrollView *)disableBounces {
    self.bounces = false;
    return self;
}

- ( __kindof UIScrollView *)disableScroll {
    self.scrollEnabled = false;
    return self;
}

- (UIScrollView *)disableScrollsToTop {
    self.scrollsToTop = false;
    return self;
}

- (UIScrollView *)enablePaging {
    self.pagingEnabled = YES;
    return self;
}

- (UIScrollView *)enableDirectionLock {
    self.directionalLockEnabled = YES;
    return self;
}

@end
