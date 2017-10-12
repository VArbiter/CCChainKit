//
//  UIButton+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UIButton (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIButton *(^common)();
@property (nonatomic , class , copy , readonly) __kindof UIButton *(^commonS)(UIButtonType type);

/// titles && images
@property (nonatomic , copy , readonly) __kindof UIButton *(^titleS)(NSString * sTitle , UIControlState state);
@property (nonatomic , copy , readonly) __kindof UIButton *(^imageS)(UIImage * image , UIControlState state);

/// actions , default is touchUpInside
@property (nonatomic , copy , readonly) __kindof UIButton *(^actionS)(void (^)( __kindof UIButton *sender));
@property (nonatomic , copy , readonly) __kindof UIButton *(^targetS)(id target , void (^)( __kindof UIButton *sender));

/// custom actions .
@property (nonatomic , copy , readonly) __kindof UIButton *(^custom)(id target , SEL selector , UIControlEvents events);

@end
