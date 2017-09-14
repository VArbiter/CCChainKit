//
//  UIImagePickerController+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 18/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIImagePickerController+CCChain.h"

#import "CCChainCommon.h"

#import <objc/runtime.h>

@implementation UIImagePickerController (CCChain)

+ (UIImagePickerController *(^)())common {
    return ^UIImagePickerController * {
        UIImagePickerController *c = UIImagePickerController.alloc.init;
        CC_WEAK_INSTANCE(c);
        c.delegate = weakTc;
        return c;
    };
}

- (UIImagePickerController *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (id t) {
        if (t) pSelf.delegate = t;
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)()))cameraT {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)()) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (t) t();
            return pSelf;
        }
        if (_CC_IS_SIMULATOR_) {
            NSLog(@"\n \
                  Simulator is not support camera . \n \
                  UIImagePickerController will change \"sourceType\" \
                  \t from \"UIImagePickerControllerSourceTypeCamera\" \
                  \t to \"UIImagePickerControllerSourceTypePhotoLibrary\". \n");
            return pSelf.photoLibraryT(t);
        }
        else {
            pSelf.sourceType = UIImagePickerControllerSourceTypeCamera;
            pSelf.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            pSelf.showsCameraControls = YES;
            return pSelf;
        }
    };
}

- (UIImagePickerController *(^)(void (^)()))savedPhotosAlbumT {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)()) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            if (t) t();
            return pSelf;
        }
        pSelf.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)()))photoLibraryT {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)()) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            if (t) t();
            return pSelf;
        }
        pSelf.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        return pSelf;
    };
}

- (UIImagePickerController *(^)())enableEditing {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)()) {
        pSelf.allowsEditing = YES;
        return pSelf;
    };
}

- (UIImagePickerController *(^)(CCImageSaveType))save {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (CCImageSaveType type) {
        objc_setAssociatedObject(pSelf, "_CC_IMAGE_PICKER_SAVE_TYPE_", @(type), OBJC_ASSOCIATION_ASSIGN);
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)(UIImage *)))original {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)(UIImage *)) {
        objc_setAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_ORIGINAL_IMAGE_", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)(UIImage *, CGRect)))edited {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)(UIImage * , CGRect)) {
        objc_setAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_EDITED_IMAGE_", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)()))cancel {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)()){
        objc_setAssociatedObject(pSelf, "_CC_IMAGE_PICKER_USER_DID_CANCEL_", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (UIImagePickerController *(^)(void (^)(NSError *)))errorIn {
    __weak typeof(self) pSelf = self;
    return ^UIImagePickerController * (void (^t)(NSError *)){
        objc_setAssociatedObject(pSelf, "_CC_IMAGE_PICKER_SAVING_ERROR_", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    CCImageSaveType type = [objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_SAVE_TYPE_") intValue];
    if (type & CCImageSaveTypeNone) return ;
    __weak typeof(self) pSelf = self;
    void (^o)() = ^ {
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *) = objc_getAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_ORIGINAL_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerOriginalImage"]);
    };
    void (^e)() = ^ {
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *, CGRect) = objc_getAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_EDITED_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerEditedImage"] , [info[@"UIImagePickerControllerCropRect"] CGRectValue]);
    };
    
    if (type & CCImageSaveTypeAll) {
        if (o) o();
        if (e) e();
    }
    else if (type & CCImageSaveTypeOriginal) {
        if (o) o();
    }
    else if (type & CCImageSaveTypeEdited) {
        if (e) e();
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    void (^t)() = objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_USER_DID_CANCEL_");
    if (t) t();
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    void (^t)(NSError *) = objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_SAVING_ERROR_");
    if (t) t(error);
}

_CC_DETECT_DEALLOC_

@end
