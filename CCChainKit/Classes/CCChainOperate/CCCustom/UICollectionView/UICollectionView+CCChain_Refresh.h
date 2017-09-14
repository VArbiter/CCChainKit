//
//  UICollectionView+CCChain_Refresh.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MJRefresh/MJRefresh.h>)

@import MJRefresh;

@interface UICollectionView (CCChain_Refresh)

/// equals : endRefresh + endLoadMore
@property (nonatomic , readonly) __kindof UICollectionView * endLoading ;
@property (nonatomic , readonly) __kindof UICollectionView * endRefresh ;
@property (nonatomic , readonly) __kindof UICollectionView * endLoadMore ;

@property (nonatomic , readonly) __kindof UICollectionView * resetLoadingStatus ;
@property (nonatomic , readonly) __kindof UICollectionView * noMoreData ;

@property (nonatomic , readonly) __kindof UICollectionView * (^refreshing)(void (^refresh)());
@property (nonatomic , readonly) __kindof UICollectionView * (^loadingMore)(void (^loadMore)());

@end

#endif
