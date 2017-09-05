//
//  UILabel+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UILabel *(^common)(CGRect frame);

/// auto fit with text || attributed Text ,
/// params fEstimate that determins if the height after calculate ,  was lesser than original .
/// note: ignores text-indent , attributed text's level will be higher than others
@property (nonatomic , copy , readonly) __kindof UILabel *(^autoHeight)(CGFloat fEstimate);

@property (nonatomic , copy , readonly) __kindof UILabel *(^attributedTextHeight)(CGFloat fEstimate);
@property (nonatomic , copy , readonly) __kindof UILabel *(^textHeight)(CGFloat fEstimate);

@end
