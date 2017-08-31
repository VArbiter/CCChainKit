//
//  UIImageView+CCChain_WeakNetwork.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CCChain_WeakNetwork)

/// if network was not strong enough , stop loading web image .
@property (nonatomic , copy , readonly) UIImageView *(^weakImage)(NSURL * url , UIImage *imageHolder);

/// if set NO , this function will stop all loading for images
/// default is YES;
@property (nonatomic , class , copy , readonly) void (^enableLoading)(BOOL isEnable);

@end
