//
//  UIGestureRecognizer+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (CCChain)

@property (nonatomic , copy , readonly) __kindof UIGestureRecognizer *(^action)(void(^t)( __kindof UIGestureRecognizer *gr));
@property (nonatomic , copy , readonly) __kindof UIGestureRecognizer *(^target)(id target , void(^action)( __kindof UIGestureRecognizer *gr));

@end

#pragma mark - -----

@interface UITapGestureRecognizer (CCChain)

/// default 1 tap
@property (nonatomic , class , copy , readonly) UITapGestureRecognizer *(^common)();
@property (nonatomic , copy , readonly) UITapGestureRecognizer *(^tap)(void(^)(UIGestureRecognizer *tapGR));
@property (nonatomic , copy , readonly) UITapGestureRecognizer *(^tapC)(NSInteger iCount , void(^)(UIGestureRecognizer *tapGR));

@end

#pragma mark - -----

@interface UILongPressGestureRecognizer (CCChain)

/// default .5f seconds with 1 tap
@property (nonatomic , class , copy , readonly) UILongPressGestureRecognizer *(^common)();
@property (nonatomic , copy , readonly) UILongPressGestureRecognizer *(^press)(void(^)(UIGestureRecognizer *pressGR));
@property (nonatomic , copy , readonly) UILongPressGestureRecognizer *(^pressC)(CGFloat fSeconds , void(^)(UIGestureRecognizer *pressGR));

@end

#pragma mark - -----

@interface UIView (CCChain_Gesture_Actions)

/// for gesture actions
@property (nonatomic , copy , readonly) __kindof UIView *(^gesture)( __kindof UIGestureRecognizer *gr);
@property (nonatomic , copy , readonly) __kindof UIView *(^tap)(void(^t)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) __kindof UIView *(^tapC)(NSInteger iCount , void(^t)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) __kindof UIView *(^press)(void(^t)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr));
@property (nonatomic , copy , readonly) __kindof UIView *(^pressC)(CGFloat fSeconds , void(^t)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr));

@end
