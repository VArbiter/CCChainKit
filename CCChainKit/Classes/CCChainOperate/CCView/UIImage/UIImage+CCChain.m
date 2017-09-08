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

- (UIImage *(^)())alwaysOriginal {
    __weak typeof(self) pSelf = self;
    return ^UIImage * {
        return pSelf.rendering(UIImageRenderingModeAlwaysOriginal);
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
@import Accelerate;
@import CoreImage;

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
    return ^UIImage *(CGFloat f, NSInteger i, UIColor *c, void (^t)(UIImage *, UIImage *)) {
        void (^tp)() = ^ {
            UIImage *m = pSelf.gaussianAccC(f, i, c);
            if (NSThread.isMainThread) {
                if (t) t(pSelf , m);
            } else dispatch_sync(dispatch_get_main_queue(), ^{
                if (t) t(pSelf , m);
            });
        };
        
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                if (tp) tp();
            });
        } else {
            dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
                if (tp) tp();
            });
        }
        return pSelf;
    };
}

- (UIImage *(^)())gaussianCI {
    __weak typeof(self) pSelf = self;
    return ^UIImage * {
        return pSelf.gaussianCIS(_CC_GAUSSIAN_BLUR_VALUE_);
    };
}

- (UIImage *(^)(CGFloat))gaussianCIS {
    __weak typeof(self) pSelf = self;
    return ^UIImage * (CGFloat f) {
        UIImage *image = [pSelf copy];
        if (!image) return pSelf;
        
        CIContext *context = [CIContext contextWithOptions:@{kCIContextPriorityRequestLow : @(YES)}];
        CIImage *imageInput= [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:imageInput forKey:kCIInputImageKey];
        [filter setValue:@(f) forKey: @"inputRadius"];
        
        CIImage *imageResult = [filter valueForKey:kCIOutputImageKey];
        CGImageRef imageOutput = [context createCGImage:imageResult
                                               fromRect:[imageResult extent]];
        UIImage *imageBlur = [UIImage imageWithCGImage:imageOutput];
        CGImageRelease(imageOutput);
        
        return imageBlur;
    };
}

- (UIImage *(^)(CGFloat, void (^)(UIImage *, UIImage *)))gaussianCIA {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(CGFloat f , void (^t)(UIImage *, UIImage *)) {
        void (^tp)() = ^ {
            UIImage *m = pSelf.gaussianCIS(f);
            if (NSThread.isMainThread) {
                if (t) t(pSelf , m);
            } else dispatch_sync(dispatch_get_main_queue(), ^{
                if (t) t(pSelf , m);
            });
        };
        
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                if (tp) tp();
            });
        } else {
            dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
                if (tp) tp();
            });
        }
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UIImage (CCChain_Data)

CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ = 400.f;

- (NSData *)toData {
    NSData *d = nil;
    if ((d = UIImagePNGRepresentation(self))) return d;
    if ((d = UIImageJPEGRepresentation(self, .0f))) return d;
    return d;
}

- (NSData *(^)(CGFloat))compresssJPEG {
    __weak typeof(self) pSelf = self;
    return ^NSData *(CGFloat f) {
        NSData *dO = UIImageJPEGRepresentation(pSelf, .0f); // dataOrigin
        if (!dO) return nil;
        NSData *dC = dO ; // dataCompress
        NSData *dR = dO; // dataResult
        
        long long lengthData = dC.length;
        NSInteger i = 0;
        for (NSInteger j = 0 ; j < 10; j ++) {
            if (lengthData / 1024.f > f) {
                NSData *dataTemp = UIImageJPEGRepresentation(self , 1.f - (++ i) * .1f);
                dR = dataTemp;
                lengthData = dR.length;
                continue;
            }
            break;
        }
        return dR;
    };
}

- (BOOL (^)(CGFloat))isOverLimitFor {
    __weak typeof(self) pSelf = self;
    return ^BOOL (CGFloat f) {
        return pSelf.toData.length / powl(1024, 2) > f ;
    };
}

@end

#pragma mark - -----

@implementation NSData (CCChain_UIImage)

- (CCImageType)type {
    NSData *data = [self copy];
    if (!data) return CCImageType_Unknow;
    
    UInt8 c = 0;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF: return CCImageType_JPEG;
        case 0x89: return CCImageType_PNG;
        case 0x47: return CCImageType_Gif;
        case 0x49:
        case 0x4D: return CCImageType_Tiff;
        case 0x52:{
            if (data.length < 12) {
                return CCImageType_Unknow;
            }
            // 0x52 == 'R' , and R is Riff for WEBP
            NSString *s = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)]
                                                encoding:NSASCIIStringEncoding];
            if ([s hasPrefix:@"RIFF"] && [s hasSuffix:@"WEBP"]) {
                return CCImageType_WebP;
            }
        }
            
        default:
            return CCImageType_Unknow;
            break;
    }
    return CCImageType_Unknow;
}

@end

#pragma mark - -----
#import "CCCommon.h"
#import "NSObject+CCProtocol.h"

@implementation UIImageView (CCChain_Gaussian)

- ( __kindof UIImageView *(^)())gussian {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * {
        pSelf.image = [pSelf.image cc:^id(id sameObject) {
            return CC_TYPE(UIImage *, sameObject).gaussianAcc();
        }];
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)(CGFloat))gussianT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * (CGFloat f){
        pSelf.image = [pSelf.image cc:^id(id sameObject) {
            return CC_TYPE(UIImage *, sameObject).gaussianAccS(f);
        }];
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UIImageView (CCChain_Image)

- ( __kindof UIImageView *(^)(UIImageRenderingMode))rendaring {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView *(UIImageRenderingMode mode) {
        pSelf.image = [pSelf.image cc:^id(id sameObject) {
            return CC_TYPE(UIImage *, sameObject).rendering(mode);
        }];
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)(UIEdgeInsets))capInsets {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * (UIEdgeInsets insets) {
        pSelf.image = [pSelf.image cc:^id(id sameObject) {
            return CC_TYPE(UIImage *, sameObject).resizable(insets);
        }];
        return pSelf;
    };
}

- ( __kindof UIImageView *(^)())alwaysOriginal {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIImageView * {
        return pSelf.rendaring(UIImageRenderingModeAlwaysOriginal);
    };
}


@end
