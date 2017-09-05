//
//  UIViewController+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIViewController+CCChain.h"
#import "UIView+CCChain.h"

#import <objc/runtime.h>

@implementation UIViewController (CCChain)

- (__kindof UIViewController *)disableAnimated {
    objc_setAssociatedObject(self, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_", @(false), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (UIViewController *)enableAnimated {
    objc_setAssociatedObject(self, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_", @(YES), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (void (^)())goBack {
    __weak typeof(self) pSelf = self;
    return ^ {
        if (pSelf.navigationController) pSelf.pop();
        else if (pSelf.presentingViewController) pSelf.dismiss();
    };
}

- (void (^)())dismiss {
    __weak typeof(self) pSelf = self;
    return ^ {
        pSelf.dismissS(.0f);
    };
}

- (void (^)(CGFloat))dismissS {
    __weak typeof(self) pSelf = self;
    return ^(CGFloat f) {
        pSelf.dismissT(f, nil);
    };
}

- (void (^)(CGFloat, void (^)()))dismissT {
    __weak typeof(self) pSelf = self;
    return ^(CGFloat f , void (^t)()) {
        id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        if (self.presentingViewController) {
            if (f <= .0f) [pSelf dismissViewControllerAnimated:b
                                                    completion:t];
        }
        else pSelf.goBack();
    };
}

- (void (^)())pop {
    __weak typeof(self) pSelf = self;
    return ^ {
        if (pSelf.navigationController) {
            id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
            BOOL b = o ? [o boolValue] : YES;
            [pSelf.navigationController popViewControllerAnimated:b];
        }
        else pSelf.goBack();
    };
}

- (void (^)(__kindof UIViewController *))popTo {
    __weak typeof(self) pSelf = self ;
    return ^(__kindof UIViewController *vc) {
        id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        if (vc
            && [vc isKindOfClass:UIViewController.class]
            && [vc.navigationController.viewControllers containsObject:pSelf]) {
            if (pSelf.navigationController) [pSelf.navigationController popToViewController:vc
                                                                                   animated:b];
        }
        else pSelf.goBack();
    };
}

- (void (^)())popToRoot {
    __weak typeof(self) pSelf = self;
    return ^ {
        id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        if (self.navigationController) [pSelf.navigationController popToRootViewControllerAnimated:b];
        else pSelf.goBack();
    };
}

- (__kindof UIViewController *(^)(__kindof UIViewController *))push {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIViewController *(__kindof UIViewController *vc) {
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return pSelf;
        if (pSelf.navigationController) return pSelf.pushS(vc, YES);
        return pSelf.present(vc);
    };
}

- (__kindof UIViewController *(^)( __kindof UIViewController *, BOOL)) pushS {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIViewController *(__kindof UIViewController *vc , BOOL b) {
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return pSelf;
        if (pSelf.navigationController) {
            id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
            BOOL b = o ? [o boolValue] : YES;
            [pSelf.navigationController pushViewController:vc
                                                  animated:b];
            return pSelf;
        }
        return pSelf.present(vc);
    };
}

- (__kindof UIViewController *(^)(__kindof UIViewController *))present {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIViewController *(__kindof UIViewController *vc) {
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return pSelf;
        return pSelf.presentT(vc, nil);
    };
}

- (__kindof UIViewController *(^)(__kindof UIViewController *, void (^)()))presentT {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIViewController *(__kindof UIViewController *vc , void (^t)()) {
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return pSelf;
        id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        [pSelf presentViewController:vc animated:b completion:t];
        return pSelf;
    };
}

- (__kindof UIViewController *(^)(__kindof UIViewController *, CGFloat))addViewFrom {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIViewController *(__kindof UIViewController *vc , CGFloat f) {
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return pSelf;
        for (id item in pSelf.view.subviews) {
            if (item == vc.view) return pSelf;
        }
        id o = objc_getAssociatedObject(pSelf, "_CC_CHAIN_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        if (b) {
            vc.view.alpha = .01f;
            [pSelf.view addSubview:vc.view];
            [UIView animateWithDuration:(f > .0f ? f : _CC_DEFAULT_ANIMATION_COMMON_DURATION_) animations:^{
                vc.view.alpha = 1.f;
            }];
        }
        else [pSelf.view addSubview:vc.view];
        [pSelf addChildViewController:vc];
        return pSelf;
    };
}

+ (void (^)(__kindof UIViewController *, BOOL, CGFloat))coverViewWith {
    return ^(__kindof UIViewController *vc , BOOL b , CGFloat f) {
        UIWindow *w = UIApplication.sharedApplication.delegate.window;
        if (!vc || ![vc isKindOfClass:UIViewController.class]) return ;
        for (id item in w.subviews) {
            if (item == vc.view) return ;
        }
        if (b) {
            vc.view.alpha = .01f;
            [w addSubview:vc.view];
            [UIView animateWithDuration:(f > .0f ? f : _CC_DEFAULT_ANIMATION_COMMON_DURATION_) animations:^{
                vc.view.alpha = 1.f;
            }];
        }
        else [w addSubview:vc.view];
    };
}

+ (__kindof UIViewController *(^)())currentT {
    return ^__kindof UIViewController * {
        id vc = nil;
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *arrayWindows = [[UIApplication sharedApplication] windows];
            for (UIWindow *tempWindow in arrayWindows) {
                if (tempWindow.windowLevel == UIWindowLevelNormal) {
                    window = tempWindow;
                    break;
                }
            }
        }
        UIView *viewFront = [[window subviews] firstObject];
        vc = [viewFront nextResponder];
        if ([vc isKindOfClass:[UIViewController class]]) return vc;
        else return window.rootViewController;
    };
}

@end
