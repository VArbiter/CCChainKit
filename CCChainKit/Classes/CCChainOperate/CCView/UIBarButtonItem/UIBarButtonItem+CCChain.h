//
//  UIBarButtonItem+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UIBarButtonItem *(^common)();
@property (nonatomic , copy , readonly) __kindof UIBarButtonItem *(^titleS)(NSString *sTitle);
@property (nonatomic , copy , readonly) __kindof UIBarButtonItem *(^imageS)(UIImage *image);
@property (nonatomic , copy , readonly) __kindof UIBarButtonItem *(^actionS)(void (^)( __kindof UIBarButtonItem *sender));
@property (nonatomic , copy , readonly) __kindof UIBarButtonItem *(^targetS)(id target , void (^)( __kindof UIBarButtonItem *sender));

@end
