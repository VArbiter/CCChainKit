//
//  MBProgressHUD+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

@import MBProgressHUD;

typedef NS_ENUM(NSInteger , CCHudChainType) {
    CCHudChainTypeNone = 0 ,
    CCHudChainTypeLight ,
    CCHudChainTypeDark ,
    CCHudChainTypeDarkDeep
};

@interface MBProgressHUD (CCChain)

/// init ,  default showing after chain complete , no need to deploy showing action "show()".
@property (nonatomic , class , copy , readonly) __kindof MBProgressHUD *(^initC)();
@property (nonatomic , class , copy , readonly) __kindof MBProgressHUD *(^initS)(UIView *v);

/// generate a hud with its bounds . default with application window .
/// also , you have to add it after generate compete , and deploy showing action "show()" .
@property (nonatomic , class , copy , readonly) __kindof MBProgressHUD *(^generate)();
@property (nonatomic , class , copy , readonly) __kindof MBProgressHUD *(^generateS)(UIView *v);

/// for block interact for user operate action .
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^enable)() ;
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^disableT)() ;

@property (nonatomic , class , copy , readonly) BOOL (^hasHud)();
@property (nonatomic , class , copy , readonly) BOOL (^hasHudS)(UIView *view);

/// for showing action
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^show)(); // if needed , default showing after chain complete
@property (nonatomic , copy , readonly) void (^hide)(); // default 2 seconds . and hide will trigger dealloc . last step .
@property (nonatomic , copy , readonly) void (^hideS)(NSTimeInterval interval);

/// messages && indicator
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^indicatorD)();
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^simple)(); // default
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^title)(NSString *sTitle);
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^message)(NSString *sMessage);
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^type)(CCHudChainType type);
/// if deploy , make sure you DO NOT delpoied "show()";
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^delay)(CGFloat delay);
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^grace)(NSTimeInterval interval); // same as MBProgressHud
@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^min)(NSTimeInterval interval); // same as MBProgressHud

@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^complete)(void(^)());

@end

#pragma mark - -----

@interface UIView (CCChain_Hud)

@property (nonatomic , copy , readonly) __kindof MBProgressHUD *(^hud)();
@property (nonatomic , class , copy , readonly) __kindof MBProgressHUD *(^hudC)(UIView *view);
@property (nonatomic , readonly) __kindof MBProgressHUD *asMBProgressHUD;

@end

#endif
