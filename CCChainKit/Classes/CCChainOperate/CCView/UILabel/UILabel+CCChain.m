//
//  UILabel+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 31/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UILabel+CCChain.h"

#import "UIView+CCChain.h"

@implementation UILabel (CCChain)

+ ( __kindof UILabel *(^)(CGRect))common {
    return ^ __kindof UILabel *(CGRect r) {
        UILabel *label = [[UILabel alloc] initWithFrame:r];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        return label;
    };
}

- ( __kindof UILabel *(^)(CGFloat))autoHeight {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UILabel * (CGFloat fE){
        if (pSelf.attributedText
            && pSelf.attributedText.length) return pSelf.attributedTextHeight(fE);
        if (pSelf.text && pSelf.text.length) return pSelf.textHeight(fE);
        return pSelf;
    };
}

- ( __kindof UILabel *(^)(CGFloat))attributedTextHeight {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UILabel *(CGFloat fE) {
        pSelf.height = CC_TEXT_HEIGHT_A(pSelf.width,
                                        fE,
                                        pSelf.attributedText);
        return pSelf;
    };
}

- ( __kindof UILabel *(^)(CGFloat))textHeight {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UILabel *(CGFloat fE) {
        pSelf.height = CC_TEXT_HEIGHT_C(pSelf.width,
                                        fE,
                                        pSelf.text,
                                        pSelf.font,
                                        pSelf.lineBreakMode);
        return pSelf;
    };
}

@end
