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

/// generate a image with colors.
@property (nonatomic , class , copy , readonly) UIImage *(^colorS)(UIColor *color);
@property (nonatomic , class , copy , readonly) UIImage *(^colorC)(UIColor *color , CGSize size);

/// class , imageName
@property (nonatomic , class , copy , readonly) UIImage *(^bundle)(Class clazz, NSString *sImage);
@property (nonatomic , class , copy , readonly) UIImage *(^named)(NSString *sImageName);
@property (nonatomic , class , copy , readonly) UIImage *(^namedB)(NSString *sImageName , NSBundle *bundle);
@property (nonatomic , class , copy , readonly) UIImage *(^file)(NSString *sPath);

@end

#pragma mark - -----

@interface UIImage (CCChain_Gaussian)

extern CGFloat _CC_GAUSSIAN_BLUR_VALUE_ ;
extern CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ ;

// for gaussian issues

/// using <Accelerate/Accelerate.h>
@property (nonatomic , copy , readonly) UIImage *(^gaussianAcc)();
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccS)(CGFloat fRadius);
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccC)(CGFloat fRadius , NSInteger iteration , UIColor *tint);
@property (nonatomic , copy , readonly) UIImage *(^gaussianAccA)(CGFloat fRadius , NSInteger iteration , UIColor *tint , void(^)(UIImage *origin , UIImage *processed));

/// using <CoreImage/CoreImage.h>
@property (nonatomic , copy , readonly) UIImage *(^gaussianCI)(); // sync , not recommended
@property (nonatomic , copy , readonly) UIImage *(^gaussianCIS)(CGFloat fRadius); // sync , not recommended
@property (nonatomic , copy , readonly) UIImage *(^gaussianCIA)(CGFloat fRadius , void(^)(UIImage *origin , UIImage *processed)); // async

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger , CCImageType) {
    CCImageTypeUnknow = 0 ,
    CCImageTypeJPEG ,
    CCImageTypePNG ,
    CCImageTypeGif ,
    CCImageTypeTiff
};

@interface UIImage (CCChain_Data)

extern CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ ; // 400 kb

// available for PNG && JPEG

@property (nonatomic , readonly) NSData *toData ;
/// compress and limit it with in a fitable range .
@property (nonatomic , copy , readonly) NSData *(^compresssJPEG)(CGFloat fQuility);
@property (nonatomic , copy , readonly) BOOL (^isOverLimitFor)(CGFloat fMBytes); // arguments with Mbytes .

@end

@interface NSData (CCChain_UIImage)

@property (nonatomic , readonly) CCImageType type ;

@end
