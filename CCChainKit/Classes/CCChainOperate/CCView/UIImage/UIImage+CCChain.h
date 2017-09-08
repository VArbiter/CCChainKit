//
//  UIImage+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCChain)

/// for image size && width
@property (nonatomic , assign , readonly) CGFloat width ;
@property (nonatomic , assign , readonly) CGFloat height ;

/// scale size with radius
@property (nonatomic , copy , readonly) CGSize (^zoom)(CGFloat radius);

@property (nonatomic , copy , readonly) UIImage *(^resizable)(UIEdgeInsets insets);
@property (nonatomic , copy , readonly) UIImage *(^rendering)(UIImageRenderingMode);
@property (nonatomic , copy , readonly) UIImage *(^alwaysOriginal)();

/// class , imageName
@property (nonatomic , class , copy , readonly) UIImage *(^bundle)(Class clazz, NSString *sImage);
@property (nonatomic , class , copy , readonly) UIImage *(^named)(NSString *sImageName);
@property (nonatomic , class , copy , readonly) UIImage *(^namedB)(NSString *sImageName , NSBundle *bundle);
@property (nonatomic , class , copy , readonly) UIImage *(^file)(NSString *sPath);

@end

#pragma mark - -----

@interface UIImage (CCChain_Gaussian)

FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_VALUE_ ;
FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ ;

// for gaussian issues

/// using Accelerate
@property (nonatomic , copy , readonly) UIImage *(^gaussianAcc)();
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccS)(CGFloat fRadius);
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccC)(CGFloat fRadius , NSInteger iteration , UIColor *tint);
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccA)(CGFloat fRadius , NSInteger iteration , UIColor *tint , void(^)(UIImage *origin , UIImage *processed));

/// using CoreImage
@property (nonatomic , copy , readonly) UIImage *(^gaussianCI)(); // sync , not recommended
@property (nonatomic , copy , readonly) UIImage *(^gaussianCIS)(CGFloat fRadius); // sync , not recommended
@property (nonatomic , copy , readonly) UIImage *(^gaussianCIA)(CGFloat fRadius , void(^)(UIImage *origin , UIImage *processed)); // async

@end

#pragma mark - -----

@interface UIImage (CCChain_Data)

FOUNDATION_EXPORT CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ ; // 400 kb

// available for PNG && JPEG

@property (nonatomic , readonly) NSData *toData ;
/// compress and limit it with in a fitable range .
@property (nonatomic , copy , readonly) NSData *(^compresssJPEG)(CGFloat fQuility);
@property (nonatomic , copy , readonly) BOOL (^isOverLimitFor)(CGFloat fMBytes); // arguments with Mbytes .

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger , CCImageType) {
    CCImageType_Unknow = 0 ,
    CCImageType_JPEG ,
    CCImageType_PNG ,
    CCImageType_Gif ,
    CCImageType_Tiff ,
    CCImageType_WebP
};

@interface NSData (CCChain_UIImage)

/// technically , you have to read all 8-Bytes length to specific an imageType .
/// for now , i just use the first to decide is type . (borrowed from SDWebImage) .
@property (nonatomic , readonly) CCImageType type ;

@end

#pragma mark - -----

@interface UIImageView (CCChain_Gaussian)

/// using Accelerate
@property (nonatomic , copy , readonly) __kindof UIImageView *(^gussian)();
@property (nonatomic , copy , readonly) __kindof UIImageView *(^gussianT)(CGFloat fBlur);

@end

#pragma mark - -----

@interface UIImageView (CCChain_Image)

@property (nonatomic , copy , readonly) __kindof UIImageView *(^rendaring)(UIImageRenderingMode mode);
@property (nonatomic , copy , readonly) __kindof UIImageView *(^capInsets)(UIEdgeInsets insets);

/// equals to rendaring(UIImageRenderingModeAlwaysOriginal)
@property (nonatomic , copy , readonly) __kindof UIImageView *(^alwaysOriginal)();

@end
