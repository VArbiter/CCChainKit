//
//  UIButton+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIButton+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (CCChain_Assit)

- (void) ccButtonChainAction : ( __kindof UIButton *) sender ;

@end

@implementation UIButton (CCChain_Assit)

- (void) ccButtonChainAction : ( __kindof UIButton *) sender {
    void (^t)( __kindof UIButton *) = objc_getAssociatedObject(self, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIButton (CCChain)

+ ( __kindof UIButton *(^)())common {
    return ^ __kindof UIButton * {
        return self.commonS(UIButtonTypeCustom);
    };
}
+ ( __kindof UIButton *(^)(UIButtonType))commonS {
    return ^ __kindof UIButton * (UIButtonType t) {
        return [UIButton buttonWithType:t];
    };
}

- ( __kindof UIButton *(^)(NSString *, UIControlState))titleS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIButton *(NSString *s , UIControlState t) {
        [pSelf setTitle:s forState:t];
        return pSelf;
    };
}

- ( __kindof UIButton *(^)(UIImage *, UIControlState))imageS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIButton *(UIImage *m , UIControlState t) {
        [pSelf setImage:m forState:t];
        return pSelf;
    };
}

- ( __kindof UIButton *(^)(void (^)( __kindof UIButton *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIButton *(void (^t)(UIButton *)) {
        return pSelf.targetS(pSelf, t);
    };
}

- ( __kindof UIButton *(^)(id, void (^)( __kindof UIButton *)))targetS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIButton *(id t , void (^b)( __kindof UIButton *)) {
        objc_setAssociatedObject(pSelf, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_, b, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [pSelf addTarget:t
                  action:@selector(ccButtonChainAction:)
        forControlEvents:UIControlEventTouchUpInside];
        return pSelf;
    };
}

- ( __kindof UIButton *(^)(id, SEL, UIControlEvents))custom {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIButton *(id t, SEL s , UIControlEvents e) {
        [pSelf addTarget:(t ? t : pSelf)
                  action:s
        forControlEvents:e];
        return pSelf;
    };
}

@end
