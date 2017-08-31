//
//  CCAuthorize.m
//  CCChainKit
//
//  Created by Elwinfrederick on 18/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCAuthorize.h"

#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_9_0
    #import <Photos/Photos.h>
#else
    #import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface CCAuthorize () < NSCopying , NSMutableCopying >

@property (nonatomic , strong) NSDictionary *dictionaryGuide ;
@property (nonatomic , copy , readonly) CCAuthorize * (^guideTo)();

@end

static CCAuthorize *_instance = nil;

@implementation CCAuthorize

+ (CCAuthorize *)shared {
    if (_instance) return _instance;
    _instance = [[CCAuthorize alloc] init];
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_instance) return _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - -----
- (CCAuthorize *(^)(CCSupportType, void (^)(), BOOL (^)()))hasAuthorize {
    __weak typeof(self) pSelf = self;
    return ^CCAuthorize *(CCSupportType t , void (^s)(), BOOL (^f)()) {
        BOOL (^g)() = pSelf.dictionaryGuide[@(t).stringValue];
        if (g) {
            if (g()) {
                if (s) s();
            } else if (f) {
                if (f()) CCAuthorize.shared.guideTo();
            }
        }
        return pSelf;
    };
}

- (CCAuthorize * (^)())guideTo {
    __weak typeof(self) pSelf = self;
    return ^CCAuthorize * {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                [[UIApplication sharedApplication] openURL:url
                                                   options:NSDictionary.alloc.init
                                         completionHandler:nil];
            }
        }
        return pSelf;
    };
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSDictionary *)dictionaryGuide {
    if (_dictionaryGuide) return _dictionaryGuide;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setValue:^BOOL {
#ifdef __IPHONE_9_0
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        return !(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied);
#else
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
#endif
    } forKey:@(CCSupportTypePhotoLibrary).stringValue];
    
    [d setValue:^BOOL {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
    } forKey:@(CCSupportTypeVideo).stringValue];

    [d setValue:^BOOL {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
    } forKey:@(CCSupportTypeAudio).stringValue];
    
    _dictionaryGuide = d;
    return _dictionaryGuide;
}

#pragma clang diagnostic pop

@end
