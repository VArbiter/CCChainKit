//
//  CCCommon.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCCommon.h"

#import <UIKit/UIKit.h>

@implementation CCCommon

+ (void)load {
#if DEBUG
    _CC_DEBUG_MODE_ = 0;
#else
    _CC_DEBUG_MODE_ = 1;
#endif
    
    _CC_UUID_ = [UIDevice currentDevice].identifierForVendor.UUIDString;
}

void CC_SET_DEBUG_MODE(BOOL isOn) {
    _CC_DEBUG_MODE_ = (int) isOn;
}

@end
