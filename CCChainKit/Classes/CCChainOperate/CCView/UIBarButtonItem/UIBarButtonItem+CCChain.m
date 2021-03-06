//
//  UIBarButtonItem+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIBarButtonItem+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_ = "CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY";

@interface UIBarButtonItem (CCChain_Assit)

- (void) ccBarButtonItemChainAction : ( __kindof UIBarButtonItem *) sender ;

@end

@implementation UIBarButtonItem (CCChain_Assit)

- (void) ccBarButtonItemChainAction : ( __kindof UIBarButtonItem *) sender {
    void (^t)( __kindof UIBarButtonItem *) = objc_getAssociatedObject(self, _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) {
            t(sender);
        }
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIBarButtonItem (CCChain)

+ ( __kindof UIBarButtonItem *(^)())common {
    return ^UIBarButtonItem * {
        return UIBarButtonItem.alloc.init;
    };
}

- ( __kindof UIBarButtonItem *(^)(NSString *))titleS {
    __weak typeof(self) pSelf = self;
    return ^UIBarButtonItem * (NSString *s){
        [pSelf setTitle:s];
        return pSelf;
    };
}

- ( __kindof UIBarButtonItem *(^)(UIImage *))imageS {
    __weak typeof(self) pSelf = self;
    return ^UIBarButtonItem * (UIImage *image){
        [pSelf setImage:image];
        return pSelf;
    };
}

- ( __kindof UIBarButtonItem *(^)(void (^)( __kindof UIBarButtonItem *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIBarButtonItem *(void (^t)( __kindof UIBarButtonItem *)) {
        if (t) pSelf.targetS(pSelf, t);
        return pSelf;
    };
}

- ( __kindof UIBarButtonItem *(^)(id, void (^)( __kindof UIBarButtonItem *)))targetS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIBarButtonItem *(id t , void (^b)( __kindof UIBarButtonItem *)) {
        if (b) objc_setAssociatedObject(pSelf, _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_, b, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [pSelf setTarget:t];
        [pSelf setAction:@selector(ccBarButtonItemChainAction:)];
        return pSelf;
    };
}

@end
