//
//  UIColor+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIColor+CCChain.h"

@implementation UIColor (CCChain)

+ (UIColor *(^)(int))hex {
    return ^UIColor * (int i) {
        return self.hexA(i, 1.f);
    };
}

+ (UIColor *(^)(int, double))hexA {
    return ^UIColor *(int i , double a) {
        return [UIColor colorWithRed:( (double) ( (i & 0xFF0000) >> 16) ) / 255.f
                               green:( (double) ( (i & 0xFF00) >> 8) ) / 255.f
                                blue:( (double) (i & 0xFF) ) / 255.f
                               alpha:a];
    };
}

+ (UIColor *(^)(double, double, double))RGB {
    return ^UIColor *(double R, double G, double B) {
        return self.RGBA(R, G, B, 1.f);
    };
}

+ (UIColor *(^)(double, double, double, double))RGBA {
    return ^UIColor *(double R, double G, double B , double A) {
        return [UIColor colorWithRed:R / 255.0f
                               green:G / 255.0f
                                blue:B / 255.0f
                               alpha:A];
    };
}

+ (UIColor *(^)(NSString *))sHex {
    return ^UIColor *(NSString *sHex) {
        if (!sHex || ![sHex isKindOfClass:NSString.class] || sHex.length < 6) {
            return self.clearColor;
        }
        if ([sHex hasPrefix:@"##"] || [sHex hasPrefix:@"0x"] || [sHex hasPrefix:@"0X"]) {
            sHex = [sHex substringFromIndex:2];
        }
        else if ([sHex hasPrefix:@"#"]) sHex = [sHex substringFromIndex:1];
        
        if (sHex.length < 6) return self.clearColor;
        sHex = sHex.uppercaseString;
        
        unsigned int r , g , b ;
        
        NSRange range = NSMakeRange(0, 2);
        [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&r];
        range.location = 2 ;
        [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&g];
        range.location = 4 ;
        [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&b];
        
        return self.RGB(r, g, b);
    };
}

- (UIColor *(^)(CGFloat))alphaS {
    __weak typeof(self) pSelf = self;
    return ^UIColor *(CGFloat a) {
        return [pSelf colorWithAlphaComponent:a];
    };
}

- (UIImage *(^)())image {
    __weak typeof(self) pSelf = self;
    return ^UIImage * {
        return UIImage.colorS(pSelf);
    };
}

+ (UIColor *)random {
    CGFloat (^t)() = ^CGFloat {
        return arc4random_uniform(256) / 255.0f;
    };
    
    UIColor *c = [UIColor colorWithRed:t()
                                 green:t()
                                  blue:t()
                                 alpha:1.f];
    return c;
}

@end

#pragma mark - -----

@implementation UIImage (CCChain_Color)

+ (UIImage *(^)(UIColor *))colorS {
    return ^UIImage *(UIColor *c) {
        return self.colorC(c, CGSizeZero);
    };
}

+ (UIImage *(^)(UIColor *, CGSize))colorC {
    return ^UIImage *(UIColor *c , CGSize s) {
        if (s.width <= .0f) s.width = 1.f;
        if (s.height <= .0f) s.height = 1.f;
        
        CGRect rect = (CGRect){CGPointZero, s};
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, c.CGColor);
        CGContextFillRect(context, rect);
        UIImage *imageGenerate = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageGenerate;
    };
}

@end
