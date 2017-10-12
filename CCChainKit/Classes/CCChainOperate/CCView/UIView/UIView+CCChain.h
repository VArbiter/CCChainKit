//
//  UIView+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const _CC_DEFAULT_ANIMATION_COMMON_DURATION_;

typedef CGPoint CCPoint;
CCPoint CCPointMake(CGFloat x , CGFloat y);
CCPoint CCMakePointFrom(CGPoint point);
CGPoint CGMakePointFrom(CCPoint point);

typedef CGSize CCSize;
CCSize CCSizeMake(CGFloat width , CGFloat height);
CCSize CCMakeSizeFrom(CGSize size);
CGSize CGMakeSizeFrom(CCSize size);

typedef CGRect CCRect;
CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
CCRect CCMakeRectFrom(CGRect rect);
CGRect CGMakeRectFrom(CCRect rect);

CGRect CGRectFull(); // main screen bounds .

typedef UIEdgeInsets CCEdgeInsets;
CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets);
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets);

/// scaled width && height && origin && size
CGFloat CCScaleW(CGFloat w);
CGFloat CCScaleH(CGFloat h);
CGPoint CCScaleOrigin(CGPoint origin);
CGSize CCScaleSize(CGSize size);

/// length scale
CGFloat CCWScale(CGFloat w);
CGFloat CCHScale(CGFloat h);

@interface UIView (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIView *(^common)(CCRect frame);

/// set width && height for calculating , default : 750 , 1334
@property (nonatomic , class , copy , readonly) void(^scaleSet)(CGFloat w , CGFloat h);
@property (nonatomic , class , assign , readonly) CGFloat sWidth;
@property (nonatomic , class , assign , readonly) CGFloat sHeight;

/// close animation
@property (nonatomic , class , copy , readonly) void (^disableAnimation)(void (^)());

/// margin

@property (nonatomic , assign) CGSize size;
@property (nonatomic , assign) CGPoint origin;

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

@property (nonatomic , assign , readonly) CGFloat inCenterX ;
@property (nonatomic , assign , readonly) CGFloat inCenterY ;
@property (nonatomic , assign , readonly) CGPoint inCenter ;

@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat right;

@property (nonatomic , assign , readonly) CGFloat inTop;
@property (nonatomic , assign , readonly) CGFloat inLeft;
@property (nonatomic , assign , readonly) CGFloat inBottom;
@property (nonatomic , assign , readonly) CGFloat inRight;

/// an easy way to margin
@property (nonatomic , copy , readonly) __kindof UIView *(^frameS)(CGRect frame);
@property (nonatomic , copy , readonly) __kindof UIView *(^sizeS)(CGSize size);
@property (nonatomic , copy , readonly) __kindof UIView *(^originS)(CGPoint origin);

@property (nonatomic , copy , readonly) __kindof UIView *(^widthS)(CGFloat width);
@property (nonatomic , copy , readonly) __kindof UIView *(^heightS)(CGFloat height);

@property (nonatomic , copy , readonly) __kindof UIView *(^xS)(CGFloat x);
@property (nonatomic , copy , readonly) __kindof UIView *(^yS)(CGFloat y);

@property (nonatomic , copy , readonly) __kindof UIView *(^centerXs)(CGFloat centerX);
@property (nonatomic , copy , readonly) __kindof UIView *(^centerYs)(CGFloat centerY);
@property (nonatomic , copy , readonly) __kindof UIView *(^centerT)(CGPoint center);

@property (nonatomic , copy , readonly) __kindof UIView *(^topS)(CGFloat top);
@property (nonatomic , copy , readonly) __kindof UIView *(^leftS)(CGFloat left);
@property (nonatomic , copy , readonly) __kindof UIView *(^bottomS)(CGFloat bottom);
@property (nonatomic , copy , readonly) __kindof UIView *(^rightS)(CGFloat right);

/// for xibs
@property (nonatomic , class , copy , readonly) __kindof UIView *(^fromXib)();
@property (nonatomic , class , copy , readonly) __kindof UIView *(^fromXibC)(Class c);
@property (nonatomic , class , copy , readonly) __kindof UIView *(^fromXibB)(NSBundle *bundle);

/// add && remove (return itself)
@property (nonatomic , copy , readonly) __kindof UIView *(^addSub)( __kindof UIView *view);
@property (nonatomic , copy , readonly) void (^removeFrom)(void(^t)(__kindof UIView *viewSuper));
@property (nonatomic , copy , readonly) __kindof UIView *(^bringToFront)( __kindof UIView *view);
@property (nonatomic , copy , readonly) __kindof UIView *(^sendToBack)( __kindof UIView *view);
/// bring or send with it's self .
@property (nonatomic , copy , readonly) __kindof UIView *(^makeToFront)();
@property (nonatomic , copy , readonly) __kindof UIView *(^makeToBack)();

/// enable / disable userinteraction
@property (nonatomic , copy , readonly) __kindof UIView *(^enableT)();
@property (nonatomic , copy , readonly) __kindof UIView *(^disableT)();

/// color && cornerRadius && contentMode
@property (nonatomic , copy , readonly) __kindof UIView *(^color)(UIColor *color);
@property (nonatomic , copy , readonly) __kindof UIView *(^radius)(CGFloat radius , BOOL masks);
@property (nonatomic , copy , readonly) __kindof UIView *(^edgeRound)(UIRectCorner rc , CGFloat radius);
@property (nonatomic , copy , readonly) __kindof UIView *(^contentModeT)(UIViewContentMode mode);

@end

#pragma mark - -----
@class WKWebView;

@interface UIView (CCChain_Force)

// if it's not the same type for force transfer ,
// this property will return it self .

@property (nonatomic , readonly) __kindof UILabel * asUILabel;
@property (nonatomic , readonly) __kindof UIScrollView * asUIScrollView;
@property (nonatomic , readonly) __kindof UITableView * asUITableView;
@property (nonatomic , readonly) __kindof UICollectionView * asUICollectionView;
@property (nonatomic , readonly) __kindof UIImageView * asUIImageView;
@property (nonatomic , readonly) __kindof WKWebView * asWKWebView;
@property (nonatomic , readonly) __kindof UIButton * asUIButton;
@property (nonatomic , readonly) __kindof UIControl * asUIControl;
@property (nonatomic , readonly) __kindof UITextView * asUITextView;
@property (nonatomic , readonly) __kindof UITextField * asUITextField;
@property (nonatomic , readonly) __kindof UIProgressView * asUIProgressView;
@property (nonatomic , readonly) __kindof UIVisualEffectView * asUIVisualEffectView;

@end

#pragma mark - -----

@interface UIView (CCChain_FitHeight)

/// note: all the fit recalls ignores the text-indent .

/// system font size , default line break mode , system font size
CGFloat CC_TEXT_HEIGHT_S(CGFloat fWidth ,
                         CGFloat fEstimateHeight , // height that defualt to , if less than , return's it. (same below)
                         NSString *string);
CGFloat CC_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode);

/// for attributed string , Using system attributed auto fit
CGFloat CC_TEXT_HEIGHT_A(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSAttributedString *aString);

/// using default for NSString
CGFloat CC_TEXT_HEIGHT_AS(CGFloat fWidth ,
                          CGFloat fEstimateHeight ,
                          NSString *aString ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat fLineSpacing ,
                          CGFloat fCharacterSpacing);

@end
