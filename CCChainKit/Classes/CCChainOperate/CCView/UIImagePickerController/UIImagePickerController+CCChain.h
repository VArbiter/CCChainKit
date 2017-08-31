//
//  UIImagePickerController+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 18/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CCImagePickerShowType) {
    CCImagePickerShowTypeNone = 0 ,
    CCImagePickerShowTypeCamera ,
    CCImagePickerShowTypeLibrary ,
    CCImagePickerShowTypeAlbum
};

typedef NS_OPTIONS(NSInteger , CCImageSaveType) {
    CCImageSaveTypeNone = 1 << 0 , // 1 save nothing , if options contains none , will ignore other save types
    CCImageSaveTypeOriginal = 1 << 1, // 2
    CCImageSaveTypeEdited = 1 << 2, // 4
    CCImageSaveTypeAll = 1 << 3 // 8 both original && edited
};

@interface UIImagePickerController (CCChain) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

/// default : allowEditing = false;
@property (nonatomic , class , copy , readonly) UIImagePickerController *(^common)();
/// default is itself .
/// note : if specific , reload method to get images will be handled by developers , chain kit will do nothing
@property (nonatomic , copy , readonly) UIImagePickerController *(^delegateT)(id delegate);

/// default present camera , allowEditing = false;
@property (nonatomic , copy , readonly) UIImagePickerController *(^cameraT)(void (^unsupport)());
/// default present savedPhotosAlbum , allowEditing = false;
@property (nonatomic , copy , readonly) UIImagePickerController *(^savedPhotosAlbumT)(void (^unsupport)());
/// default present photoLibrary , allowEditing = false;
@property (nonatomic , copy , readonly) UIImagePickerController *(^photoLibraryT)(void (^unsupport)());
/// allowEditing = YES ;
@property (nonatomic , copy , readonly) UIImagePickerController *(^enableEditing)();
/// save specific type of images
@property (nonatomic , copy , readonly) UIImagePickerController *(^save)(CCImageSaveType type);
/// if user cancelled
@property (nonatomic , copy , readonly) UIImagePickerController *(^cancel)();
/// if an error on saving process
@property (nonatomic , copy , readonly) UIImagePickerController *(^errorIn)(void (^)(NSError *error));

/// original iamge
@property (nonatomic , copy , readonly) UIImagePickerController *(^original)(void (^)(UIImage *image));
/// edited image
/// note : only enableEditing
@property (nonatomic , copy , readonly) UIImagePickerController *(^edited)(void (^)(UIImage *image , CGRect cropRect));

@end
