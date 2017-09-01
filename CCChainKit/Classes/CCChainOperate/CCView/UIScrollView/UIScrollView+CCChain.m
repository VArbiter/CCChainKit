//
//  UIScrollView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIScrollView+CCChain.h"

@implementation UIScrollView (CCChain)

+ (UIScrollView *(^)(CGRect))common {
    return ^UIScrollView *(CGRect r) {
        UIScrollView *v = [[UIScrollView alloc] initWithFrame:r];
        v.backgroundColor = UIColor.clearColor;
        return v;
    };
}

- (UIScrollView *(^)(CGSize))contentSizeT {
    __weak typeof(self) pSelf = self;
    return ^UIScrollView *(CGSize size) {
        pSelf.contentSize = size;
        return pSelf;
    };
}

- (UIScrollView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UIScrollView *(id d) {
        pSelf.delegate = d;
        return pSelf;
    };
}

- (UIScrollView *(^)(CGPoint))animatedOffset {
    __weak typeof(self) pSelf = self;
    return ^UIScrollView *(CGPoint p) {
        return pSelf.animatedOffsetT(p , YES);
    };
}

- (UIScrollView *(^)(CGPoint, BOOL))animatedOffsetT {
    __weak typeof(self) pSelf = self;
    return ^UIScrollView *(CGPoint p , BOOL b) {
        [pSelf setContentOffset:p
                       animated:b];
        return pSelf;
    };
}

- (UIScrollView *)hideVerticalIndicator {
    self.showsVerticalScrollIndicator = false;
    return self;
}

- (UIScrollView *)hideHorizontalIndicator {
    self.showsHorizontalScrollIndicator = false;
    return self;
}

- (UIScrollView *)disableBounces {
    self.bounces = false;
    return self;
}

- (UIScrollView *)disableScroll {
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
