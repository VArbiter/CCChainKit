//
//  UIScrollView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCChain)

@property (nonatomic , class , copy , readonly) UIScrollView *(^common)(CGRect frame);

@property (nonatomic , copy , readonly) UIScrollView *(^contentSizeT)(CGSize size);
@property (nonatomic , copy , readonly) UIScrollView *(^delegateT)(id delegate);

@property (nonatomic , copy , readonly) UIScrollView *(^animatedOffset)(CGPoint pOffset); // animated is YES .
@property (nonatomic , copy , readonly) UIScrollView *(^animatedOffsetT)(CGPoint pOffset , BOOL isAnimated);

@property (nonatomic , readonly) UIScrollView * hideVerticalIndicator ;
@property (nonatomic , readonly) UIScrollView * hideHorizontalIndicator ;
@property (nonatomic , readonly) UIScrollView * disableBounces ;
@property (nonatomic , readonly) UIScrollView * disableScroll ;
@property (nonatomic , readonly) UIScrollView * disableScrollsToTop ;

@property (nonatomic , readonly) UIScrollView * enablePaging ;
@property (nonatomic , readonly) UIScrollView * enableDirectionLock ;

@end
