//
//  UITextField+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UITextField *(^common)(CGRect frame);
@property (nonatomic , copy , readonly) __kindof UITextField *(^delegateT)(id <UITextFieldDelegate> delegete);

@property (nonatomic , copy , readonly) __kindof UITextField *(^placeHolder)(NSDictionary <NSString * , id> *dAttributes , NSString * string);

/// default with a image View that already size-to-fit with original image .
@property (nonatomic , copy , readonly) __kindof UITextField *(^rightViewT)(UIImage *image , UITextFieldViewMode mode);
@property (nonatomic , copy , readonly) __kindof UITextField *(^leftViewT)(UIImage *image , UITextFieldViewMode mode);

@property (nonatomic , readonly) BOOL resignFirstResponderT;

@end
