//
//  UIViewController+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CCChain)

/// remove all animated for pushing && presenting .
@property (nonatomic , copy , readonly) __kindof UIViewController *disableAnimated;
@property (nonatomic , copy , readonly) __kindof UIViewController *enableAnimated;

/// first detect if nagvigation pop back enable ,
/// then detect if dismiss enable .
/// respose the first findout .
@property (nonatomic , copy , readonly) void (^goBack)();

@property (nonatomic , copy , readonly) void (^dismiss)();
@property (nonatomic , copy , readonly) void (^dismissS)(CGFloat fDelay);
@property (nonatomic , copy , readonly) void (^dismissT)(CGFloat fDelay , void (^complete)());

@property (nonatomic , copy , readonly) void (^pop)();
@property (nonatomic , copy , readonly) void (^popTo)(__kindof UIViewController *vc);
@property (nonatomic , copy , readonly) void (^popToRoot)();

/// default enable animated && Hide bottom bar
@property (nonatomic , copy , readonly) __kindof UIViewController *(^push)(__kindof UIViewController *vc);
@property (nonatomic , copy , readonly) __kindof UIViewController *(^pushS)(__kindof UIViewController *vc , BOOL isHideBottom);

@property (nonatomic , copy , readonly) __kindof UIViewController *(^present)(__kindof UIViewController *vc);
@property (nonatomic , copy , readonly) __kindof UIViewController *(^presentT)(__kindof UIViewController *vc , void(^complete)());

/// deafult enable animated , fade in , fade out .
@property (nonatomic , copy , readonly) __kindof UIViewController *(^addViewFrom)(__kindof UIViewController *vc , CGFloat fAnimatedDuration);

/// note : [UIApplication sharedApplication].delegate.window is the super view
@property (nonatomic , class , copy , readonly) void (^coverViewWith)(__kindof UIViewController *vc , BOOL isAnimated , CGFloat fAnimatedDuration);

/// current controller that shows on screen .
@property (nonatomic , class , copy , readonly) __kindof UIViewController *(^currentT)();

@end
