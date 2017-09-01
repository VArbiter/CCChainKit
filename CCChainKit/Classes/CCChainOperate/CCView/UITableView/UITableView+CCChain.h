//
//  UITableView+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CCChain)

/// default plain.
@property (nonatomic , class , copy , readonly) UITableView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) UITableView *(^commonC)(CGRect frame , UITableViewStyle style);

@property (nonatomic , copy , readonly) UITableView *(^delegateT)(id delegate);
@property (nonatomic , copy , readonly) UITableView *(^dataSourceT)(id dataSource);

/// requires that nib name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) UITableView *(^registNibS)(NSString *sNib); // default main bundle
@property (nonatomic , copy , readonly) UITableView *(^registNib)(NSString *sNib , NSBundle *bundle);
/// requires that class name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) UITableView *(^registCls)(Class clazz);

@property (nonatomic , copy , readonly) UITableView *(^registHeaderFooterNib)(NSString *sNib); // default main bundle
@property (nonatomic , copy , readonly) UITableView *(^registHeaderFooterNibS)(NSString *sNib , NSBundle *bundle);
@property (nonatomic , copy , readonly) UITableView *(^registHeaderFooterCls)(Class cls);

/// wrapper of "beginUpdates" && "endUpdates"
@property (nonatomic , copy , readonly) UITableView *(^updating)(void (^t)());

/// for non-animated , only section 0 was available.
/// note : false means reloading without hidden animations .
/// note : if animated is set to -1 , equals to reloadData.
/// note : if reloeded muti sections , using "reloadSections(NSIndexSet *, UITableViewRowAnimation)" down below
@property (nonatomic , copy , readonly) UITableView *(^reloading)(UITableViewRowAnimation animated);

/// note : if animated is set to -2 , UIView will close all animations during reloading.
@property (nonatomic , copy , readonly) UITableView *(^reloadSectionsT)(NSIndexSet *set , UITableViewRowAnimation animated);
@property (nonatomic , copy , readonly) UITableView *(^reloadItemsT)(NSArray <NSIndexPath *> *array , UITableViewRowAnimation animted);

@property (nonatomic , copy , readonly) __kindof UITableViewCell *(^deqCell)(NSString *sIdentifier);
/// for cell that register in tableView
@property (nonatomic , copy , readonly) __kindof UITableViewCell *(^deqCellS)(NSString *sIndetifier , NSIndexPath *indexPath);
@property (nonatomic , copy , readonly) __kindof UITableViewHeaderFooterView *(^deqReusableView)(NSString * sIdentifier) ;

@end
