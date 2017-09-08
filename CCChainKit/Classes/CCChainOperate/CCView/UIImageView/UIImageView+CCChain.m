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

@end
