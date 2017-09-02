//
//  UIImageView+CCChain_WeakNetwork.m
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIImageView+CCChain_WeakNetwork.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

#import "CCNetworkMoniter.h"

@import SDWebImage;

static BOOL __isEnableLoading = YES;

@implementation UIImageView (CCChain_WeakNetwork)

- (UIImageView *(^)(NSURL *, UIImage *))weakImage {
    __weak typeof(self) pSelf = self;
    return ^UIImageView *(NSURL *u , UIImage *m) {
        BOOL isStrong = CCNetworkMoniter.shared.environmentType() == CCNetworkEnvironmentStrong;
        if (isStrong && __isEnableLoading) {
            [pSelf sd_setImageWithURL:u
                     placeholderImage:m
                              options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates | SDWebImageScaleDownLargeImages];
        };
        return pSelf;
    };
}

+ (void (^)(BOOL))enableLoading {
    return ^ (BOOL b) {
        __isEnableLoading = b;
    };
}

@end

#endif
