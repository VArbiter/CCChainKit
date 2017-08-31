//
//  UIImageView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CCChain)

@property (nonatomic , class , copy , readonly) UIImageView *(^common)(CGRect frame);
@property (nonatomic , copy , readonly) UIImageView *(^imageT)(UIImage *image);

@property (nonatomic , copy , readonly) UIImageView *(^rendaring)(UIImageRenderingMode mode);
@property (nonatomic , copy , readonly) UIImageView *(^capInsets)(UIEdgeInsets insets);

/// equals to rendaring(UIImageRenderingModeAlwaysOriginal)
@property (nonatomic , copy , readonly) UIImageView *(^alwaysOriginal)();

@property (nonatomic , copy , readonly) UIImageView *(^gussian)();
@property (nonatomic , copy , readonly) UIImageView *(^gussianT)(CGFloat fBlur);

@end
