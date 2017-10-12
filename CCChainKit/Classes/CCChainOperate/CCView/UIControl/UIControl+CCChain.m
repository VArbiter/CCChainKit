//
//  UIControl+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIControl+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIControl (CCChain_Assit)

- (void) ccControlChainAction : ( __kindof UIControl *) sender ;

@end

@implementation UIControl (CCChain_Assit)

- (void) ccControlChainAction : ( __kindof UIControl *) sender {
    void (^t)( __kindof UIControl *) = objc_getAssociatedObject(self, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY";

@implementation UIControl (CCChain)

+ ( __kindof UIControl *(^)(CGRect))commonC {
    return ^ __kindof UIControl *(CGRect r) {
        UIControl *c = [[self alloc] initWithFrame:r];
        c.userInteractionEnabled = YES;
        return c;
    };
}

- ( __kindof UIControl *(^)(void (^)( __kindof UIControl *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIControl *(void (^t)( __kindof UIControl *)) {
        return pSelf.targetS(pSelf, t);
    };
}

- ( __kindof UIControl *(^)(id, void (^)( __kindof UIControl *)))targetS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIControl *(id v , void (^t)( __kindof UIControl *)) {
        objc_setAssociatedObject(pSelf, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [pSelf addTarget:t
                  action:@selector(ccControlChainAction:)
        forControlEvents:UIControlEventTouchUpInside];
        return pSelf;
    };
}

- ( __kindof UIControl *(^)(id, SEL, UIControlEvents))custom {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIControl *(id v , SEL s , UIControlEvents e) {
        [pSelf addTarget:(v ? v : pSelf)
                  action:s
        forControlEvents:e];
        return pSelf;
    };
}

- ( __kindof UIControl *(^)(UIEdgeInsets))increaseC {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIControl *(UIEdgeInsets insets) {
        objc_setAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_,
                                 @(insets.top), OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_,
                                 @(insets.left), OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_,
                                 @(insets.bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_,
                                 @(insets.right), OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __weak typeof(self) pSelf = self;
    CGRect (^t)() = ^CGRect {
        NSNumber * top = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_);
        NSNumber * left = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_);
        NSNumber * bottom = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_);
        NSNumber * right = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_);
        if (top && left && bottom && right) {
            return CGRectMake(pSelf.bounds.origin.x - left.floatValue,
                              pSelf.bounds.origin.y - top.floatValue,
                              pSelf.bounds.size.width + left.floatValue + right.floatValue,
                              pSelf.bounds.size.height + top.floatValue + bottom.floatValue);
        }
        else return pSelf.bounds;
    };
    
    CGRect rect = t();
    if (CGRectEqualToRect(rect, self.bounds)) return [super hitTest:point withEvent:event];
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
