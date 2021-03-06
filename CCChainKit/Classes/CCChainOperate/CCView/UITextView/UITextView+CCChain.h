//
//  UITextView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (CCChain)

/// default , selectable = false
@property (nonatomic , class , copy , readonly) __kindof UITextView *(^common)(CGRect r);
@property (nonatomic , copy , readonly) __kindof UITextView *(^delegateT)(id <UITextViewDelegate> delegate) ;
@property (nonatomic , copy , readonly) __kindof UITextView *(^containerInsets)(UIEdgeInsets insets);

@end
