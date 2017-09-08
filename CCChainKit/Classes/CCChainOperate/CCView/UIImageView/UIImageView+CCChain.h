//
//  UIImageView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIImageView *(^common)(CGRect frame);
@property (nonatomic , copy , readonly) __kindof UIImageView *(^imageT)(UIImage *image);

@end
