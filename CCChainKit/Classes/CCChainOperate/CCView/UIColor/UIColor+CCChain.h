//
//  UIColor+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CCChain)

/// eg: 0xFFFFFF , 0x000000
@property (nonatomic , class , copy , readonly) UIColor *(^hex)(int value);
@property (nonatomic , class , copy , readonly) UIColor *(^hexA)(int value , double alpha);
@property (nonatomic , class , copy , readonly) UIColor *(^RGB)(double r , double g , double b);
@property (nonatomic , class , copy , readonly) UIColor *(^RGBA)(double r , double g , double b , double a);

/// eg: @"0xFFFFFF" , @"##FFFFFF" , @"#FFFFFF" , @"0XFFFFFF"
/// otherwise , returns clear color .
@property (nonatomic , class , copy , readonly) UIColor *(^sHex)(NSString *sHex);

@property (nonatomic , copy , readonly) UIColor *(^alphaS)(CGFloat alpha);
/// generate a image that size equals (CGSize){1.f , 1.f}
@property (nonatomic , copy , readonly) UIImage *(^image)();

@property (nonatomic , class , readonly) UIColor * random ;

@end

#pragma mark - -----

@interface UIImage (CCChain_Color)

/// generate a image with colors.
@property (nonatomic , class , copy , readonly) UIImage *(^colorS)(UIColor *color);
@property (nonatomic , class , copy , readonly) UIImage *(^colorC)(UIColor *color , CGSize size);

@end
