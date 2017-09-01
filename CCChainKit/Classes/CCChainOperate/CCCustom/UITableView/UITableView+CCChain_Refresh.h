//
//  UITableView+CCChain_Refresh.h
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MJRefresh;

@interface UITableView (CCChain_Refresh)

/// equals : endRefresh + endLoadMore
@property (nonatomic , readonly) UITableView * endLoading ;
@property (nonatomic , readonly) UITableView * endRefresh ;
@property (nonatomic , readonly) UITableView * endLoadMore ;

@property (nonatomic , readonly) UITableView * resetLoadingStatus ;
@property (nonatomic , readonly) UITableView * noMoreData ;

@property (nonatomic , readonly) UITableView * (^refreshing)(void (^refresh)());
@property (nonatomic , readonly) UITableView * (^loadingMore)(void (^loadMore)());

@end
