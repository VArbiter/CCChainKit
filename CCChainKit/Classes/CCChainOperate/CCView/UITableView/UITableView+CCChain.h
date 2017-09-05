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
@property (nonatomic , class , copy , readonly) __kindof UITableView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) __kindof UITableView *(^commonC)(CGRect frame , UITableViewStyle style);

@property (nonatomic , copy , readonly) __kindof UITableView *(^delegateT)(id delegate);
@property (nonatomic , copy , readonly) __kindof UITableView *(^dataSourceT)(id dataSource);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching
@property (nonatomic , copy , readonly) __kindof UITableView *(^prefetchingT)(id prefetchDataSource);
#endif

/// requires that nib name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) __kindof UITableView *(^registNibS)(NSString *sNib); // default main bundle
@property (nonatomic , copy , readonly) __kindof UITableView *(^registNib)(NSString *sNib , NSBundle *bundle);
/// requires that class name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) __kindof UITableView *(^registCls)(Class clazz);

@property (nonatomic , copy , readonly) __kindof UITableView *(^registHeaderFooterNib)(NSString *sNib); // default main bundle
@property (nonatomic , copy , readonly) __kindof UITableView *(^registHeaderFooterNibS)(NSString *sNib , NSBundle *bundle);
@property (nonatomic , copy , readonly) __kindof UITableView *(^registHeaderFooterCls)(Class cls);

/// wrapper of "beginUpdates" && "endUpdates"
@property (nonatomic , copy , readonly) __kindof UITableView *(^updating)(void (^t)());

/// for non-animated , only section 0 was available.
/// note : UITableViewRowAnimationNone means reloading without hidden animations .
/// note : if animated is set to -1 , equals to reloadData.
/// note : if reloeded muti sections , using "reloadSections(NSIndexSet *, UITableViewRowAnimation)" down below
@property (nonatomic , copy , readonly) __kindof UITableView *(^reloading)(UITableViewRowAnimation animated);

/// note : if animated is set to -2 , UIView will close all animations during reloading.
@property (nonatomic , copy , readonly) __kindof UITableView *(^reloadSectionsT)(NSIndexSet *set , UITableViewRowAnimation animated);
@property (nonatomic , copy , readonly) __kindof UITableView *(^reloadItemsT)(NSArray <NSIndexPath *> *array , UITableViewRowAnimation animted);

@property (nonatomic , copy , readonly) __kindof UITableViewCell *(^deqCell)(NSString *sIdentifier);
/// for cell that register in tableView
@property (nonatomic , copy , readonly) __kindof UITableViewCell *(^deqCellS)(NSString *sIndetifier , NSIndexPath *indexPath);
@property (nonatomic , copy , readonly) __kindof UITableViewHeaderFooterView *(^deqReusableView)(NSString * sIdentifier) ;

@end

#pragma mark - -----

@interface CCTableChainDelegate : NSObject < UITableViewDelegate >

@property (nonatomic , class , copy , readonly) CCTableChainDelegate < UITableViewDelegate > *(^common)();

@property (nonatomic , copy , readonly) CCTableChainDelegate *(^cellHeight)(CGFloat (^)(UITableView * tableView , NSIndexPath *indexPath));
@property (nonatomic , copy , readonly) CCTableChainDelegate *(^sectionHeaderHeight)(CGFloat (^)(UITableView * tableView , NSInteger iSection));
@property (nonatomic , copy , readonly) CCTableChainDelegate *(^sectionHeader)(UIView *(^)(UITableView *tableView , NSInteger iSection));
@property (nonatomic , copy , readonly) CCTableChainDelegate *(^sectionFooterHeight)(CGFloat (^)(UITableView * tableView , NSInteger iSection));
@property (nonatomic , copy , readonly) CCTableChainDelegate *(^sectionFooter)(UIView *(^)(UITableView *tableView , NSInteger iSection));
@property (nonatomic , copy , readonly) CCTableChainDelegate *(^didSelect)(BOOL (^)(UITableView *tableView , NSIndexPath *indexPath));

@end

#pragma mark - -----

@interface CCTableChainDataSource : NSObject < UITableViewDataSource >

@property (nonatomic , class , copy , readonly) CCTableChainDataSource < UITableViewDataSource > *(^common)();

@property (nonatomic , copy , readonly) CCTableChainDataSource *(^sections)(NSInteger (^)(UITableView *tableView));
@property (nonatomic , copy , readonly) CCTableChainDataSource *(^rowsInSections)(NSInteger (^)(UITableView * tableView , NSInteger iSection));
@property (nonatomic , copy , readonly) CCTableChainDataSource *(^cellIdentifier)(NSString *(^)(UITableView *tableView , NSIndexPath *indexPath));
@property (nonatomic , copy , readonly) CCTableChainDataSource *(^configCell)(__kindof UITableViewCell *(^)(UITableView *tableView , UITableViewCell *tCell , NSIndexPath *indexPath));

@end

#pragma mark - -----

/// instructions && notes are the same with 'NSArray+CCChain_Collection_Refresh' in 'UICollectionView+CCChain'

@interface NSArray (CCChain_Table_Refresh)

@property (nonatomic , copy , readonly) NSArray *(^reload)(UITableView *tableView);
@property (nonatomic , copy , readonly) NSArray *(^reloadSection)(UITableView *tableView , NSIndexSet *set);

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// instructions && notes are the same with 'CCCollectionChainDataPrefetching' in 'UICollectionView+CCChain'

@interface CCTableChainDataPrefetching : NSObject < UITableViewDataSourcePrefetching >

/// auto enable prefetch in background thread
@property (nonatomic , class , copy , readonly) CCTableChainDataPrefetching < UITableViewDataSourcePrefetching > *(^common)();
@property (nonatomic , readonly) CCTableChainDataPrefetching *disableBackgroundMode;

@property (nonatomic , copy , readonly) CCTableChainDataPrefetching *(^prefetchAt)(void (^)(__kindof UITableView *collectionView , NSArray <NSIndexPath *> *array));
@property (nonatomic , copy , readonly) CCTableChainDataPrefetching *(^cancelPrefetchAt)(void (^)(__kindof UITableView *collectionView , NSArray <NSIndexPath *> *array));

@end

#endif
