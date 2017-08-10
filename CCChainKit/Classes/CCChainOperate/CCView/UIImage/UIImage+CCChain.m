//
//  UIImage+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIImage+CCChain.h"

@implementation UIImage (CCChain)

- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
}

- (CGSize (^)(CGFloat))zoom {
    __weak typeof(self) pSelf = self;
    return ^CGSize (CGFloat f) {
        if (f > .0f) {
            CGFloat ratio = pSelf.height / pSelf.width;
            CGFloat ratioWidth = pSelf.width * f;
            CGFloat ratioHeight = ratioWidth * ratio;
            return CGSizeMake(ratioWidth, ratioHeight);
        }
        return pSelf.size;
    };
}

- (UIImage *(^)(UIEdgeInsets))resizable {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(UIEdgeInsets s) {
        return [pSelf resizableImageWithCapInsets:s];
    };
}

- (UIImage *(^)(UIImageRenderingMode))rendering {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(UIImageRenderingMode m) {
        return [pSelf imageWithRenderingMode:m];
    };
}

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

+ (UIImage *(^)(__unsafe_unretained Class, NSString *))bundle {
    return ^UIImage *(Class c , NSString *s) {
        NSBundle *b = [NSBundle bundleForClass:c];
        NSString *bName = b.infoDictionary[@"CFBundleName"];
        NSString *sc = [NSString stringWithFormat:@"%ld",(NSInteger)UIScreen.mainScreen.scale];
        NSString *temp = [[[s stringByAppendingString:@"@"] stringByAppendingString:sc] stringByAppendingString:@"x"];
        NSString *p = [b pathForResource:temp
                                  ofType:@"png"
                             inDirectory:[bName stringByAppendingString:@".bundle"]];
        return [UIImage imageWithContentsOfFile:p];
    };
}

+ (UIImage *(^)(NSString *))named {
    return ^UIImage *(NSString *s) {
        return [self imageNamed:s];
    };
}

+ (UIImage *(^)(NSString *, NSBundle *))namedB {
    return ^UIImage *(NSString *s , NSBundle *b) {
        return [self imageNamed:s
                       inBundle:b
  compatibleWithTraitCollection:nil];
    };
}

+ (UIImage *(^)(NSString *))file {
    return ^UIImage *(NSString * sP) {
        return [UIImage imageWithContentsOfFile:sP];
    };
}

@end

#pragma mark - -----
#import <Accelerate/Accelerate.h>

CGFloat _CC_GAUSSIAN_BLUR_VALUE_ = .1f;
CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ = .25f;

@implementation UIImage (CCChain_Gaussian)

- (UIImage *(^)())gaussianAcc {
    __weak typeof(self) pSelf = self;
    return ^UIImage * {
        return pSelf.gaussianAccS(_CC_GAUSSIAN_BLUR_VALUE_);
    };
}

- (UIImage *(^)(CGFloat))gaussianAccS {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(CGFloat f) {
        return pSelf.gaussianAccC(f, 0, UIColor.whiteColor);
    };
}

- (UIImage *(^)(CGFloat, NSInteger, UIColor *))gaussianAccC {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(CGFloat floatValue, NSInteger iCount, UIColor *color) {
        UIImage *image = [self copy];
        if (!image) return pSelf;
        
        if (floatValue < 0.f || floatValue > 1.f) {
            floatValue = 0.5f;
        }
        
        if (floor(pSelf.width) * floor(pSelf.height) <= 0) {
            return pSelf;
        }
        
        UInt32 boxSize = (UInt32)(floatValue * pSelf.scale);
        boxSize = boxSize - (boxSize % 2) + 1;
        
        CGImageRef imageRef = image.CGImage;
        
        CGBitmapInfo bitMapInfo = CGImageGetBitmapInfo(imageRef);
        if (CGImageGetBitsPerPixel(imageRef) != 32
            || CGImageGetBitsPerComponent(imageRef) != 8
            || ((bitMapInfo & kCGBitmapAlphaInfoMask) != kCGBitmapAlphaInfoMask)) {
#warning TODO >>>
            /// 这里的重绘出问题了 ? 色彩失真严重
            UIGraphicsBeginImageContextWithOptions(pSelf.size, false, pSelf.scale);
            [pSelf drawAtPoint:CGPointZero];
            imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
            UIGraphicsEndImageContext();
        }
        
        if (!imageRef) return pSelf;
        
        vImage_Buffer inBuffer, outBuffer;
        
        inBuffer.width = CGImageGetWidth(imageRef);
        inBuffer.height = CGImageGetHeight(imageRef);
        inBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
        
        outBuffer.width = CGImageGetWidth(imageRef);
        outBuffer.height = CGImageGetHeight(imageRef);
        outBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
        
        CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        NSUInteger bytes = outBuffer.rowBytes * outBuffer.height;
        inBuffer.data = malloc(bytes);
        outBuffer.data = malloc(bytes);
        
        if (!inBuffer.data || !outBuffer.data) {
            free(inBuffer.data);
            free(outBuffer.data);
            return pSelf;
        }
        
        void * tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&outBuffer,
                                                              &inBuffer,
                                                              NULL,
                                                              0,
                                                              0,
                                                              boxSize,
                                                              boxSize,
                                                              NULL,
                                                              kvImageEdgeExtend | kvImageGetTempBufferSize));
        
        CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
        CFDataRef dataInBitMap = CGDataProviderCopyData(providerRef);
        if (!dataInBitMap) return pSelf;
        
        memcpy(outBuffer.data, CFDataGetBytePtr(dataInBitMap), MIN(bytes, CFDataGetLength(dataInBitMap)));
        
        for (NSInteger i = 0; i < iCount; i ++) {
            vImage_Error error = vImageBoxConvolve_ARGB8888(&outBuffer,
                                                            &inBuffer,
                                                            tempBuffer,
                                                            0,
                                                            0,
                                                            boxSize,
                                                            boxSize,
                                                            NULL,
                                                            kvImageEdgeExtend);
            if (error != kvImageNoError) {
                free(tempBuffer);
                free(inBuffer.data);
                free(outBuffer.data);
                return pSelf;
            }
#warning TODO >>>
            /// 这里的交换出问题了 ? 模糊不起效 .
            
            void * temp = inBuffer.data;
            inBuffer.data = outBuffer.data;
            outBuffer.data = temp;
        }
        
        free(inBuffer.data);
        free(tempBuffer);
        
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
        if (!colorSpace) return pSelf;
        
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 bitMapInfo);
        if (color && CGColorGetAlpha(color.CGColor) > 0.0) {
            CGColorRef colorRef = CGColorCreateCopyWithAlpha(color.CGColor, _CC_GAUSSIAN_BLUR_TINT_ALPHA_);
            CGContextSetFillColor(ctx, CGColorGetComponents(colorRef));
            CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
            CGContextFillRect(ctx, (CGRect){CGPointZero , outBuffer.width , outBuffer.height});
        }
        imageRef = CGBitmapContextCreateImage(ctx);
        UIImage * imageProcessed = [UIImage imageWithCGImage:imageRef];
        
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        CFRelease(inBitmapData);
        
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);
        
        return imageProcessed;
    };
}

- (UIImage *(^)(CGFloat, NSInteger, UIColor *, void (^)(UIImage *, UIImage *)))gaussianAccA {
    __weak typeof(self) pSelf = self;

}

@end
