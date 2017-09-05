//
//  UIScrollView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIScrollView *(^common)(CGRect frame);

@property (nonatomic , copy , readonly) __kindof UIScrollView *(^contentSizeT)(CGSize size);
@property (nonatomic , copy , readonly) __kindof UIScrollView *(^delegateT)(id delegate);

@property (nonatomic , copy , readonly) __kindof UIScrollView *(^animatedOffset)(CGPoint pOffset); // animated is YES .
@property (nonatomic , copy , readonly) __kindof UIScrollView *(^animatedOffsetT)(CGPoint pOffset , BOOL isAnimated);

@property (nonatomic , readonly) __kindof UIScrollView * hideVerticalIndicator ;
@property (nonatomic , readonly) __kindof UIScrollView * hideHorizontalIndicator ;
@property (nonatomic , readonly) __kindof UIScrollView * disableBounces ;
@property (nonatomic , readonly) __kindof UIScrollView * disableScroll ;
@property (nonatomic , readonly) __kindof UIScrollView * disableScrollsToTop ;

@property (nonatomic , readonly) __kindof UIScrollView * enablePaging ;
@property (nonatomic , readonly) __kindof UIScrollView * enableDirectionLock ;

@end
