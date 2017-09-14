//
//  UITableView+CCChain_Refresh.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITableView+CCChain_Refresh.h"

#import "CCChainCommon.h"
#import "NSObject+CCProtocol.h"

#if __has_include(<MJRefresh/MJRefresh.h>)

@implementation UITableView (CCChain_Refresh)

- ( __kindof UITableView *) endLoading {
    CC(self).endRefresh.endLoading.endT();
    return self;
}

- ( __kindof UITableView *)endRefresh {
    [self.mj_header endRefreshing];
    return self;
}

- ( __kindof UITableView *)endLoadMore {
    [self.mj_footer endRefreshing];
    return self;
}

- ( __kindof UITableView *)resetLoadingStatus {
    [self.mj_footer resetNoMoreData];
    return self;
}

- ( __kindof UITableView *)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- ( __kindof UITableView *(^)(void (^)()))refreshing {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(void (^t)()) {
        [pSelf.mj_header beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(void (^)()))loadingMore {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(void (^t)()) {
        [pSelf.mj_footer beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

@end

#endif
