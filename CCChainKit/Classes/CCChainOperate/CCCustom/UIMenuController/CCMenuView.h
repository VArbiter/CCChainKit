//
//  CCMenuView.h
//  CCChainKit
//
//  Created by 冯明庆 on 03/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

/// this file that makes UIMenuController's item can be manage && sorted .

@class CCMenuView;

@protocol CCMenuViewProtocol <NSObject>

@optional
- (void) ccMenuViewDidClose : (CCMenuView *) menuView ;

@end

@interface CCMenuView : UIView < CCMenuViewProtocol >

/// show for frame , @[@{@"methodName" : @"showingTitle"}] ,
/// note : it will show exclusive with same order that given by array .
@property (nonatomic , copy , readonly) CCMenuView *(^showT)(CGRect frame , NSArray <NSDictionary <NSString * , NSString *> *> * aTitles);

/// dTotal : all methods and titles , sKey , sValue , index : current selected
@property (nonatomic , copy , readonly) CCMenuView *(^clickT)(void (^)(NSDictionary *dTotal ,
                                                                        NSString *sKey ,
                                                                        NSString *sValue ,
                                                                        NSInteger index));
@property (nonatomic , copy , readonly) CCMenuView *(^delegateT)(id delegate);

/// remove form super view && destory (set to nil) .
void CC_DESTORY_MENU_ITEM(CCMenuView *view);

@end
