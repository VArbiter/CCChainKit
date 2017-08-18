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

typedef NS_ENUM(NSInteger , CCImageSaveType) {
    CCImageSaveTypeNone = 0 , // save nothing
    CCImageSaveTypeOriginal ,
    CCImageSaveTypeEdited ,
    CCImageSaveTypeAll // both original && edited
};

@interface UIImagePickerController (CCChain) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

@property (nonatomic , class , copy , readonly) UIImagePickerController *(^common)();
//@property (nonatomic , class , copy , readonly) NSArray *(^support)();
//@property (nonatomic , copy , readonly) UIImagePickerController *(^save)(CCImageSaveType type);

@end
