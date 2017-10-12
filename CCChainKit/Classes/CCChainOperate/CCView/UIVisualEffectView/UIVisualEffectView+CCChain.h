//
//  UIVisualEffectView+CCChain.h
//  CCChainKit
//
//  Created by 冯明庆 on 12/10/2017.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIVisualEffectView *(^common)(__kindof UIVisualEffect *effect);

@end

#pragma mark - -----

@interface UIVisualEffect (CCChain)

+ (instancetype) blurDark ;
+ (instancetype) blurLight ;
+ (instancetype) blurExtraLight ;

@end

#pragma mark - -----

@interface UIVibrancyEffect (CCChain)

+ (instancetype) vibrancyDark ;
+ (instancetype) vibrancyLight ;
+ (instancetype) vibrancyExtraLight ;

@end
