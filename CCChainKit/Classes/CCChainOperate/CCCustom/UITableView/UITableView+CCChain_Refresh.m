//
//  UITableView+CCChain_Refresh.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITableView+CCChain_Refresh.h"

#if __has_include(<MJRefresh/MJRefresh.h>)

#import "CCChainCommon.h"
#import "NSObject+CCProtocol.h"

@implementation UITableView (CCChain_Refresh)

- (UITableView *) endLoading {
    CC(self).endRefresh.endLoading.endT();
    return self;
}

- (UITableView *)endRefresh {
    [self.mj_header endRefreshing];
    return self;
}

- (UITableView *)endLoadMore {
    [self.mj_footer endRefreshing];
    return self;
}

- (UITableView *)resetLoadingStatus {
    [self.mj_footer resetNoMoreData];
    return self;
}

- (UITableView *)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- (UITableView *(^)(void (^)()))refreshing {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(void (^t)()) {
        [pSelf.mj_header beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

- (UITableView *(^)(void (^)()))loadingMore {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(void (^t)()) {
        [pSelf.mj_footer beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

@end

#endif
