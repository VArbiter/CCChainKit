//
//  UICollectionView+CCChain_Refresh.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UICollectionView+CCChain_Refresh.h"
#import "NSObject+CCProtocol.h"
#import "CCChainCommon.h"

#if __has_include(<MJRefresh/MJRefresh.h>)

@implementation UICollectionView (CCChain_Refresh)

- ( __kindof UICollectionView *) endLoading {
    CC(self).endRefresh.endLoading.endT();
    return self;
}

- ( __kindof UICollectionView *)endRefresh {
    [self.mj_header endRefreshing];
    return self;
}

- ( __kindof UICollectionView *)endLoadMore {
    [self.mj_footer endRefreshing];
    return self;
}

- ( __kindof UICollectionView *)resetLoadingStatus {
    [self.mj_footer resetNoMoreData];
    return self;
}

- ( __kindof UICollectionView *)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- ( __kindof UICollectionView *(^)(void (^)()))refreshing {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(void (^t)()) {
        [pSelf.mj_header beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(void (^)()))loadingMore {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(void (^t)()) {
        [pSelf.mj_footer beginRefreshingWithCompletionBlock:^{
            if (t) t();
        }];
        return pSelf;
    };
}

@end

#endif
