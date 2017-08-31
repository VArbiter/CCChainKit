//
//  UILabel+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCChain)

@property (nonatomic , class , copy , readonly) UILabel *(^common)(CGRect frame);

@end
