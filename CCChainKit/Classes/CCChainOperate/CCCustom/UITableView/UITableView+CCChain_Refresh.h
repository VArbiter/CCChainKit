//
//  UITableView+CCChain_Refresh.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MJRefresh/MJRefresh.h>)

@import MJRefresh;

@interface UITableView (CCChain_Refresh)

/// equals : endRefresh + endLoadMore
@property (nonatomic , readonly) __kindof UITableView * endLoading ;
@property (nonatomic , readonly) __kindof UITableView * endRefresh ;
@property (nonatomic , readonly) __kindof UITableView * endLoadMore ;

@property (nonatomic , readonly) __kindof UITableView * resetLoadingStatus ;
@property (nonatomic , readonly) __kindof UITableView * noMoreData ;

@property (nonatomic , readonly) __kindof UITableView * (^refreshing)(void (^refresh)());
@property (nonatomic , readonly) __kindof UITableView * (^loadingMore)(void (^loadMore)());

@end

#endif
