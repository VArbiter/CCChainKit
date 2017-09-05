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

+ ( __kindof UIImageView *(^)(CGRect))common {
    return ^ __kindof UIImageView *(CGRect r) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:r];
        v.backgroundColor = [UIColor clearColor];
        v.contentMode = UIViewContentModeScaleAspectFit;
        return v;
    };
}

- ( __kindof UIImageView *(^)(UIImage *))imageT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView *(UIImage *image) {
        pSelf.image = image;
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)(UIImageRenderingMode))rendaring {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView *(UIImageRenderingMode mode) {
        [pSelf.image imageWithRenderingMode:mode];
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)(UIEdgeInsets))capInsets {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * (UIEdgeInsets insets) {
        [pSelf.image resizableImageWithCapInsets:insets];
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)())alwaysOriginal {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * {
        return pSelf.rendaring(UIImageRenderingModeAlwaysOriginal);
    };
}

- ( __kindof UIImageView *(^)())gussian {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * {
        CC(pSelf.image).gaussianAcc();
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)(CGFloat))gussianT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * (CGFloat f){
        CC(pSelf.image).gaussianAccS(f);
        return pSelf;
    };
}

@end
