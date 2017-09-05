//
//  UITextField+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITextField+CCChain.h"

@implementation UITextField (CCChain)

+ ( __kindof UITextField *(^)(CGRect))common {
    return ^ __kindof UITextField *(CGRect r) {
        UITextField *v = [[UITextField alloc] initWithFrame:r];
        v.clearsOnBeginEditing = YES;
        v.clearButtonMode = UITextFieldViewModeWhileEditing ;
        return v;
    };
}

- ( __kindof UITextField *(^)(id<UITextFieldDelegate>))delegateT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextField *(id<UITextFieldDelegate> d) {
        if (d) pSelf.delegate = d;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- ( __kindof UITextField *(^)(NSDictionary<NSString *,id> *, NSString *))placeHolder {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextField *(NSDictionary<NSString *,id> *d, NSString *s) {
        if (![s isKindOfClass:NSString.class] || !s || !s.length) return pSelf;
        NSAttributedString *sAttr = [[NSAttributedString alloc] initWithString:s
                                                                    attributes:d];
        pSelf.attributedPlaceholder = sAttr;
        return pSelf;
    };
}

- ( __kindof UITextField *(^)(UIImage *, UITextFieldViewMode))rightViewT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextField * (UIImage *image , UITextFieldViewMode mode) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *v = [[UIImageView alloc] initWithImage:image];
        v.contentMode = UIViewContentModeScaleAspectFit;
        [v sizeToFit];
        pSelf.rightViewMode = mode;
        pSelf.rightView = v;
        return pSelf;
    };
}

- ( __kindof UITextField *(^)(UIImage *, UITextFieldViewMode))leftViewT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITextField *(UIImage *image , UITextFieldViewMode mode) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *v = [[UIImageView alloc] initWithImage:image];
        v.contentMode = UIViewContentModeScaleAspectFit;
        [v sizeToFit];
        pSelf.leftViewMode = mode;
        pSelf.leftView = v;
        return pSelf;
    };
}

- (BOOL)resignFirstResponderT {
    BOOL b = [self canResignFirstResponder];
    if (b) [self resignFirstResponder];
    return b;
}

@end
