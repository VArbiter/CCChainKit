//
//  UIVisualEffectView+CCChain.m
//  CCChainKit
//
//  Created by 冯明庆 on 12/10/2017.
//

#import "UIVisualEffectView+CCChain.h"

@implementation UIVisualEffectView (CCChain)

+ (__kindof UIVisualEffectView *(^)(__kindof UIVisualEffect *))common {
    return ^__kindof UIVisualEffectView *(UIVisualEffect *e) {
        return [[self alloc] initWithEffect:e];
    };
}

@end

#pragma mark - -----

@implementation UIVisualEffect (CCChain)

+ (instancetype) blurDark {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}
+ (instancetype) blurLight {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
}
+ (instancetype) blurExtraLight {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

@end

#pragma mark - -----

@implementation UIVibrancyEffect (CCChain)

+ (instancetype) vibrancyDark {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.blurDark];
}
+ (instancetype) vibrancyLight {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.blurLight];
}
+ (instancetype) vibrancyExtraLight {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.blurExtraLight];
}

@end
