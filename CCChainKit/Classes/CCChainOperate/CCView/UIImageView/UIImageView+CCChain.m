//
//  UIImageView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIImageView+CCChain.h"

#import "UIImage+CCChain.h"

#import "NSObject+CCProtocol.h"
#import "CCCommon.h"

@implementation UIImageView (CCChain)

+ (UIImageView *(^)(CGRect))common {
    return ^UIImageView *(CGRect r) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:r];
        v.backgroundColor = [UIColor clearColor];
        v.contentMode = UIViewContentModeScaleAspectFit;
        return v;
    };
}

- (UIImageView *(^)(UIImage *))imageT {
    __weak typeof(self) pSelf = self;
    return ^UIImageView *(UIImage *image) {
        pSelf.image = image;
        return pSelf;
    };
}

- (UIImageView *(^)(UIImageRenderingMode))rendaring {
    __weak typeof(self) pSelf = self;
    return ^UIImageView *(UIImageRenderingMode mode) {
        [pSelf.image imageWithRenderingMode:mode];
        return pSelf;
    };
}

- (UIImageView *(^)(UIEdgeInsets))capInsets {
    __weak typeof(self) pSelf = self;
    return ^UIImageView * (UIEdgeInsets insets) {
        [pSelf.image resizableImageWithCapInsets:insets];
        return pSelf;
    };
}

- (UIImageView *(^)())alwaysOriginal {
    __weak typeof(self) pSelf = self;
    return ^UIImageView * {
        return pSelf.rendaring(UIImageRenderingModeAlwaysOriginal);
    };
}

- (UIImageView *(^)())gussian {
    __weak typeof(self) pSelf = self;
    return ^UIImageView * {
        CC(pSelf.image).gaussianAcc();
        return pSelf;
    };
}

- (UIImageView *(^)(CGFloat))gussianT {
    __weak typeof(self) pSelf = self;
    return ^UIImageView * (CGFloat f){
        CC(pSelf.image).gaussianAccS(f);
        return pSelf;
    };
}

@end
