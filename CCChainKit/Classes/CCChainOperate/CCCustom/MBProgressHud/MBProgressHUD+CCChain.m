//
//  MBProgressHUD+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCChain.h"

@implementation MBProgressHUD (CCChain)

+ ( __kindof MBProgressHUD *(^)())initC {
    return ^ __kindof MBProgressHUD * {
        return MBProgressHUD.initS(nil);
    };
}
+ ( __kindof MBProgressHUD *(^)(UIView *))initS {
    return ^ __kindof MBProgressHUD *(UIView *v) {
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        if (!v) v = UIApplication.sharedApplication.delegate.window;
        return [MBProgressHUD showHUDAddedTo:v
                                    animated:YES].simple().enable();
    };
}
+ ( __kindof MBProgressHUD *(^)())generate {
    return ^ __kindof MBProgressHUD *{
        return MBProgressHUD.generateS(nil);
    };
}
+ ( __kindof MBProgressHUD *(^)(UIView *))generateS {
    return ^ __kindof MBProgressHUD *(UIView *v){
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        if (!v) v = UIApplication.sharedApplication.delegate.window;
        return [[MBProgressHUD alloc] initWithView:v].simple().disableT();
    };
}

- ( __kindof MBProgressHUD *(^)())enable {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * {
        pSelf.userInteractionEnabled = false;
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)())disableT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * {
        pSelf.userInteractionEnabled = YES;
        return pSelf;
    };
}

+ (BOOL (^)())hasHud {
    return ^BOOL {
        return self.hasHudS(nil);
    };
}
+ (BOOL (^)(UIView *))hasHudS {
    return  ^BOOL (UIView *v) {
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        return !![MBProgressHUD HUDForView:v];
    };
}

- ( __kindof MBProgressHUD *(^)())show {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD *() {
        if (NSThread.isMainThread) [pSelf showAnimated:YES];
        else dispatch_sync(dispatch_get_main_queue(), ^{
            [pSelf showAnimated:YES];
        });
        return pSelf;
    };
}

- (void (^)())hide {
    __weak typeof(self) pSelf = self;
    return ^{
        pSelf.hideS(2.f);
    };
}
- (void (^)(NSTimeInterval))hideS {
    __weak typeof(self) pSelf = self;
    return ^(NSTimeInterval i) {
        pSelf.removeFromSuperViewOnHide = YES;
        if (i > .0f) {
            [pSelf hideAnimated:YES
                     afterDelay:i];
        }
        else [pSelf hideAnimated:YES];
    };
}

- ( __kindof MBProgressHUD *(^)())indicatorD {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * {
        pSelf.mode = MBProgressHUDModeIndeterminate;
        return pSelf;
    };
}
- ( __kindof MBProgressHUD *(^)())simple {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * {
        pSelf.mode = MBProgressHUDModeText;
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(NSString *))title {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * (NSString *t){
        pSelf.label.text = t;
        return pSelf;
    };
}
- ( __kindof MBProgressHUD *(^)(NSString *))message {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD *(NSString *m) {
        pSelf.detailsLabel.text = m;
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(CCHudChainType))type {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD *(CCHudChainType t) {
        NSDictionary *d = @{@(CCHudChainTypeLight) : ^{
                                pSelf.contentColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeDarkDeep) : ^{
                                pSelf.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                                pSelf.contentColor = UIColor.whiteColor;
                                pSelf.bezelView.backgroundColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeDark) : ^{
                                pSelf.contentColor = UIColor.whiteColor;
                                pSelf.bezelView.backgroundColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeNone) : ^{
                                pSelf.contentColor = UIColor.blackColor;
                            }};
        if (!d[@(t)]) return pSelf;
        void (^b)() = d[@(t)];
        if (b) b();
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(CGFloat))delay {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * (CGFloat f) {
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f * NSEC_PER_SEC));
        dispatch_after(t, dispatch_get_main_queue(), ^{
            pSelf.show();
        });
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(NSTimeInterval))grace {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD *(NSTimeInterval i) {
        pSelf.graceTime = i;
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(NSTimeInterval))min {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD *(NSTimeInterval i) {
        pSelf.minShowTime = i;
        return pSelf;
    };
}

- ( __kindof MBProgressHUD *(^)(void (^)()))complete {
    __weak typeof(self) pSelf = self;
    return ^ __kindof MBProgressHUD * (void (^t)()) {
        pSelf.completionBlock = t;
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UIView (CCChain_Hud)

- (MBProgressHUD *(^)())hud {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        return UIView.hudC(pSelf);
    };
}

+ (MBProgressHUD *(^)(UIView *))hudC {
    return ^MBProgressHUD * (UIView *v){
        return MBProgressHUD.initS(v);
    };
}

@end
