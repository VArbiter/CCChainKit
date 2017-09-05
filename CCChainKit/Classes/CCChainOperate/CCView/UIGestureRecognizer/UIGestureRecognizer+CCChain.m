//
//  UIGestureRecognizer+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_ = "CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY";

@interface UIGestureRecognizer (CCChain_Assit)

- (void) ccGestureChainAction : ( __kindof UIGestureRecognizer *) sender ;

@end

@implementation UIGestureRecognizer (CCChain_Assit)

- (void)ccGestureChainAction:( __kindof UIGestureRecognizer *)sender {
    UIGestureRecognizer *(^t)( __kindof UIGestureRecognizer *) = objc_getAssociatedObject(self, _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(self);
        else {
            __weak typeof(self) pSelf = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                t(pSelf);
            });
        }
    }
}

@end

#pragma mark - -----

@implementation UIGestureRecognizer (CCChain)

- ( __kindof UIGestureRecognizer *(^)(void (^)( __kindof UIGestureRecognizer *)))action {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIGestureRecognizer *(void(^t)( __kindof UIGestureRecognizer *g)) {
        if (t) objc_setAssociatedObject(pSelf, _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- ( __kindof UIGestureRecognizer *(^)(id, void (^)( __kindof UIGestureRecognizer *)))target {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIGestureRecognizer * (id target, void (^t)( __kindof UIGestureRecognizer *)) {
        pSelf.action(t);
        [pSelf addTarget:target
                  action:@selector(ccGestureChainAction:)];
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UITapGestureRecognizer (CCChain)

+ (UITapGestureRecognizer *(^)())common {
    return ^UITapGestureRecognizer * {
        return UITapGestureRecognizer.alloc.init;
    };
}

- (UITapGestureRecognizer *(^)(void (^)(UIGestureRecognizer *)))tap {
    __weak typeof(self) pSelf = self;
    return ^UITapGestureRecognizer *(void (^t)(UIGestureRecognizer *)) {
        return pSelf.tapC(1, t);
    };
}

- (UITapGestureRecognizer *(^)(NSInteger, void (^)(UIGestureRecognizer *)))tapC {
    __weak typeof(self) pSelf = self;
    return ^UITapGestureRecognizer *(NSInteger i , void (^t)(UIGestureRecognizer *)) {
        pSelf.numberOfTapsRequired = i;
        pSelf.target(pSelf, t);
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UILongPressGestureRecognizer (CCChain)

+ (UILongPressGestureRecognizer *(^)())common {
    return ^UILongPressGestureRecognizer * {
        return UILongPressGestureRecognizer.alloc.init;
    };
}

- (UILongPressGestureRecognizer *(^)(void (^)(UIGestureRecognizer *)))press {
    __weak typeof(self) pSelf = self;
    return ^UILongPressGestureRecognizer *(void (^t)(UIGestureRecognizer *)) {
        return pSelf.pressC(.5f, t);
    };
}

- (UILongPressGestureRecognizer *(^)(CGFloat, void (^)(UIGestureRecognizer *)))pressC {
    __weak typeof(self) pSelf = self;
    return ^UILongPressGestureRecognizer *(CGFloat f , void (^t)(UIGestureRecognizer *)) {
        pSelf.numberOfTapsRequired = 1;
        pSelf.minimumPressDuration = f;
        pSelf.target(pSelf, t);
        return pSelf;
    };
}

@end
