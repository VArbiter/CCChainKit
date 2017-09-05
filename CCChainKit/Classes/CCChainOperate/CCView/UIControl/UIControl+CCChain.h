//
//  UIControl+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UIControl (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIControl *(^commonC)(CGRect frame);

/// actions , default is touchUpInside
@property (nonatomic , copy , readonly) __kindof UIControl *(^actionS)(void (^)( __kindof UIControl *sender));
@property (nonatomic , copy , readonly) __kindof UIControl *(^targetS)(id target , void (^)( __kindof UIControl *sender));

/// custom actions .
@property (nonatomic , copy , readonly) __kindof UIControl *(^custom)(id target , SEL selector , UIControlEvents events);

/// increase trigger rect .
@property (nonatomic , copy , readonly) __kindof UIControl *(^increaseC)(UIEdgeInsets insets);

@end
