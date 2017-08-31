//
//  UILabel+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UILabel+CCChain.h"

@implementation UILabel (CCChain)

+ (UILabel *(^)(CGRect))common {
    return ^UILabel *(CGRect r) {
        UILabel *label = [[UILabel alloc] initWithFrame:r];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        return label;
    };
}



@end
