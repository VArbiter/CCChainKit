//
//  UINavigationItem+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (CCChain)

@end

#pragma mark - -----

@interface UINavigationItem (CCChain_FixedSpace)

@property (nonatomic , copy , readonly) void (^leftOffset)(CGFloat fOffset , UIBarButtonItem *item);
@property (nonatomic , copy , readonly) void (^rightOffset)(CGFloat fOffset , UIBarButtonItem *item);

@end
