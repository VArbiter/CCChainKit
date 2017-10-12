//
//  UICollectionView+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UICollectionView (CCChain)

/// auto enable prefetchiong if support
@property (nonatomic , class , copy , readonly) __kindof UICollectionView *(^commonC)(CGRect frame, __kindof UICollectionViewFlowLayout *layout);

@property (nonatomic , copy , readonly) __kindof UICollectionView *(^delegateT)(id <UICollectionViewDelegateFlowLayout> delegate);
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^dataSourceT)(id <UICollectionViewDataSource> dataSource);

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^prefetchingT)(id <UICollectionViewDataSourcePrefetching> prefetchDataSource);
#endif

/// requires that nib name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^registNibS)(NSString *sNib); // default main bundle
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^registNib)(NSString *sNib , NSBundle *bundle);
/// requires that class name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^registCls)(Class clazz);

/// for non-animated , only section 0 was available.
/// note : false means reloading without hidden animations .
/// note : if animated is setting to YES , only section 0 will be reloaded .
/// note : if reloeded muti sections , using "reloadSections(NSIndexSet *, BOOL)" down below
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^reloading)(BOOL animated);
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^reloadSections)(NSIndexSet *set , BOOL animated);
@property (nonatomic , copy , readonly) __kindof UICollectionView *(^reloadItems)(NSArray <NSIndexPath *> *array);

/// for cell that register in collection
@property (nonatomic , copy , readonly) __kindof UICollectionViewCell *(^deqCell)(NSString *sIdentifier , NSIndexPath *indexPath);
/// for reusable view
@property (nonatomic , copy , readonly) __kindof UICollectionReusableView *(^deqReuseableView)(NSString *sElementKind , NSString *sIndentifier , NSIndexPath *indexPath);

@end

#pragma mark - -----

@interface UICollectionViewFlowLayout (CCChain)

@property (nonatomic , class , copy , readonly) __kindof UICollectionViewFlowLayout *(^common)();

/// for default sizes
@property (nonatomic , copy , readonly) __kindof UICollectionViewFlowLayout *(^itemSizeC)(CGSize size);
@property (nonatomic , copy , readonly) __kindof UICollectionViewFlowLayout *(^sectionInsetC)(UIEdgeInsets insets);
@property (nonatomic , copy , readonly) __kindof UICollectionViewFlowLayout *(^headerSizeC)(CGSize insets);

@end

#pragma mark - -----

@interface CCCollectionChainDelegate : NSObject < UICollectionViewDelegateFlowLayout >

@property (nonatomic , class , copy , readonly) CCCollectionChainDelegate < UICollectionViewDelegateFlowLayout > *(^common)();

@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didSelect)(BOOL (^)(UICollectionView *collectionView , NSIndexPath *indexPath)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didHighlight)(void(^)(UICollectionView *collectionView , NSIndexPath *indexPath)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didUnHighlight)(void(^)(UICollectionView *collectionView , NSIndexPath *indexPath)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^minimumLineSpacingInSection)(CGFloat (^)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger iSection)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^minimumInterItemSpacingInSection)(CGFloat (^)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger iSection)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^spacingBetweenSections)(UIEdgeInsets (^)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger iSection)) ;

@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didScroll)(void (^)(__kindof UIScrollView *scrollView));
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^willBeginDecelerating)(void (^)(__kindof UIScrollView *scrollView));
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didEndDecelerating)(void (^)(__kindof UIScrollView *scrollView));
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^shouldScrollToTop)(BOOL (^)(__kindof UIScrollView *scrollView));
@property (nonatomic , copy , readonly) CCCollectionChainDelegate *(^didScrollToTop)(void (^)(__kindof UIScrollView *scrollView));

@end

#pragma mark - -----

@interface CCCollectionChainDataSource : NSObject < UICollectionViewDataSource >

@property (nonatomic , class , copy , readonly) CCCollectionChainDataSource < UICollectionViewDataSource > *(^common)();

@property (nonatomic , copy , readonly) CCCollectionChainDataSource *(^sections)(NSInteger (^)(UICollectionView *collectionView)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDataSource *(^itemsInSections)(NSInteger(^)(UICollectionView * collectionView , NSInteger iSections)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDataSource *(^identifierS)(NSString *(^)(UICollectionView * collectionView , NSIndexPath * indexPath)) ;
@property (nonatomic , copy , readonly) CCCollectionChainDataSource *(^configCell)(__kindof UICollectionViewCell *(^)(UICollectionView * collectionView , __kindof UICollectionViewCell * tCell , NSIndexPath * indexPath));

@end

#pragma mark - -----

@interface NSArray (CCChain_Collection_Refresh)

// for using dataSource to reload .
/// if count > 0 , reload section 0 , else reloadData . if dataSource valued , reload with Animate , otherwise NOT .
@property (nonatomic , copy , readonly) NSArray *(^reload)(UICollectionView *collectionView);
@property (nonatomic , copy , readonly) NSArray *(^reloadSection)(UICollectionView *collectionView , NSIndexSet *set);

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// pre-fetching
/// note: highly recommended to put prefetching in background thread , in other word , must
/// note: pre-fetch is sort-of auto fit technics , therefore , these method (for dellegate it self)
///     will not recalls for every time the collection view shows it cells .
/// note: that is , if users scrolling slowly or stop to scroll , it will goes pre-fetch
///     if fast , goes not .
/// note: for canceling , when users interested in sth , or reverse it scroll directions ,
///     or press to make system reponse an event , then , canceling was active .
/// note: sometimes canceling was not used in actual.
/// note: when canceling has recall values , maybe it's a subset of 'prefetchAt(void(^)(UICollectionView * , NSArray <NSIndexPath *> *))'

@interface CCCollectionChainDataPrefetching : NSObject < UICollectionViewDataSourcePrefetching >

/// auto enable prefetch in background thread
@property (nonatomic , class , copy , readonly) CCCollectionChainDataPrefetching < UICollectionViewDataSourcePrefetching > *(^common)();
@property (nonatomic , readonly) CCCollectionChainDataPrefetching *disableBackgroundMode;

@property (nonatomic , copy , readonly) CCCollectionChainDataPrefetching *(^prefetchAt)(void (^)(__kindof UICollectionView *collectionView , NSArray <NSIndexPath *> *array));
@property (nonatomic , copy , readonly) CCCollectionChainDataPrefetching *(^cancelPrefetchAt)(void (^)(__kindof UICollectionView *collectionView , NSArray <NSIndexPath *> *array));

@end

#endif
