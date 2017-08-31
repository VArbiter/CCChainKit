//
//  UIFont+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CCChain)

/// when you determin to make a font that auto adjust it self for different screens
/// note: fill in with CCScaleH(_value_) , and if you're not sure it is .
/// use label's (also available on others) height and decrease 2 (for pixels) .

@property (nonatomic , copy , readonly) UIFont *(^sizeT)(CGFloat fSize);
@property (nonatomic , class , copy , readonly) UIFont *(^system)(CGFloat fSize);
@property (nonatomic , class , copy , readonly) UIFont *(^bold)(CGFloat fSize);
@property (nonatomic , class , copy , readonly) UIFont *(^names)(NSString * sFontName , CGFloat fSize);

@end
