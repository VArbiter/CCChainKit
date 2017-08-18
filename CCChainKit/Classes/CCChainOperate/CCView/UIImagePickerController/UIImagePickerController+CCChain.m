//
//  UIImagePickerController+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 18/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UIImagePickerController+CCChain.h"

@implementation UIImagePickerController (CCChain)

+ (UIImagePickerController *(^)())common {
    return ^UIImagePickerController * {
        return UIImagePickerController.alloc.init;
    };
}

@end
