//
//  UITextView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITextView+CCChain.h"

@implementation UITextView (CCChain)

+ ( __kindof UITextView *(^)(CGRect))common {
    return ^ __kindof UITextView *(CGRect r) {
        UITextView *v = [[UITextView alloc] initWithFrame:r];
        v.layer.backgroundColor = UIColor.clearColor.CGColor;
        v.editable = YES;
        v.selectable = false;
        return v;
    };
}

- ( __kindof UITextView *(^)(id<UITextViewDelegate>))delegateT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextView *(id < UITextViewDelegate > d) {
        if (d) pSelf.delegate = d;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- ( __kindof UITextView *(^)(UIEdgeInsets))containerInsets {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextView *(UIEdgeInsets e) {
        pSelf.textContainerInset = e;
        return pSelf;
    };
}

@end
