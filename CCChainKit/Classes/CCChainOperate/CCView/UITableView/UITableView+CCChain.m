//
//  UITableView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITableView+CCChain.h"

#ifndef _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_
    #define _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_ @"CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER"
#endif

@implementation UITableView (CCChain)

+ ( __kindof UITableView *(^)(CGRect))common {
    return ^ __kindof UITableView * (CGRect r) {
        return self.commonC(r, UITableViewStylePlain);
    };
}

+ ( __kindof UITableView *(^)(CGRect, UITableViewStyle))commonC {
    return ^ __kindof UITableView * (CGRect r , UITableViewStyle st) {
        UITableView *v  = [[UITableView alloc] initWithFrame:r
                                                       style:st];
        v.showsVerticalScrollIndicator = false;
        v.showsHorizontalScrollIndicator = false;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.backgroundColor = UIColor.clearColor;
        [v registerClass:UITableViewCell.class
  forCellReuseIdentifier:_CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_];
        return v;
    };
}

- ( __kindof UITableView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView * (id d) {
        if (d) pSelf.delegate = d;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(id))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(id d) {
        if (d) pSelf.dataSource = d;
        else pSelf.dataSource = nil;
        return pSelf;
    };
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- ( __kindof UITableView *(^)(id))prefetchingT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(id d) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            if (d) pSelf.prefetchDataSource = d;
            else pSelf.prefetchDataSource = nil;
        }
        return pSelf;
    };
}
#endif

- ( __kindof UITableView *(^)(NSString *))registNibS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView * (NSString *s) {
        return pSelf.registNib(s , nil);
    };
}

- ( __kindof UITableView *(^)(NSString *, NSBundle *))registNib {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
    forCellReuseIdentifier:s];
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(__unsafe_unretained Class))registCls {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(Class cls) {
        [pSelf registerClass:cls
      forCellReuseIdentifier:NSStringFromClass(cls)];
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(NSString *))registHeaderFooterNib {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView * (NSString *s) {
        return pSelf.registHeaderFooterNibS(s , nil);
    };
}

- ( __kindof UITableView *(^)(NSString *, NSBundle *))registHeaderFooterNibS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(NSString *s , NSBundle *b) {
        if (NSClassFromString(s) == UITableViewHeaderFooterView.class
            || [NSClassFromString(s) isSubclassOfClass:UITableViewHeaderFooterView.class]) {
            if (!b) b = NSBundle.mainBundle;
            [pSelf registerNib:[UINib nibWithNibName:s
                                              bundle:b]
                    forHeaderFooterViewReuseIdentifier:s];
        }
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(__unsafe_unretained Class))registHeaderFooterCls {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(Class cls) {
        if (cls == UITableViewHeaderFooterView.class
            || [cls isSubclassOfClass:UITableViewHeaderFooterView.class]){
            [pSelf registerClass:cls forHeaderFooterViewReuseIdentifier:NSStringFromClass(cls)];
        }
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(void (^)()))updating {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(void (^t)()) {
        if (t) {
            [pSelf beginUpdates];
            t();
            [pSelf endUpdates];
        }
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(UITableViewRowAnimation))reloading {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView * (UITableViewRowAnimation anim) {
        if ((NSInteger)anim > 0 && anim != UITableViewRowAnimationNone) {
            return pSelf.reloadSectionsT([NSIndexSet indexSetWithIndex:0] , anim);
        }
        else [pSelf reloadData];
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(NSIndexSet *, UITableViewRowAnimation))reloadSectionsT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(NSIndexSet *set, UITableViewRowAnimation anim) {
        if (!set) return pSelf;
        if ((NSInteger)anim > 0 && anim != UITableViewRowAnimationNone) {
            [pSelf reloadSections:set
                 withRowAnimation:anim];
        } else {
            
            void (^t)(void (^)()) = ^(void (^e)()) {
                if (e) {
                    [UIView setAnimationsEnabled:false];
                    e();
                    [UIView setAnimationsEnabled:YES];
                }
            };
            
            if ((NSInteger)anim == -2) {
                t(^{
                    [pSelf reloadSections:set
                         withRowAnimation:UITableViewRowAnimationNone];
                });
            } else [pSelf reloadSections:set
                        withRowAnimation:UITableViewRowAnimationNone];
        }
        return pSelf;
    };
}

- ( __kindof UITableView *(^)(NSArray<NSIndexPath *> *, UITableViewRowAnimation))reloadItemsT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UITableView *(NSArray <NSIndexPath *> *a , UITableViewRowAnimation anim) {
        if (a && a.count) {
            if ((NSInteger)anim > 0 && anim != UITableViewRowAnimationNone) {
                [pSelf reloadRowsAtIndexPaths:a
                             withRowAnimation:anim];
            } else {
                
                void (^t)(void (^)()) = ^(void (^e)()) {
                    if (e) {
                        [UIView setAnimationsEnabled:false];
                        e();
                        [UIView setAnimationsEnabled:YES];
                    }
                };
                
                if ((NSInteger)anim == -2) {
                    t(^{
                        [pSelf reloadRowsAtIndexPaths:a
                                     withRowAnimation:UITableViewRowAnimationNone];
                    });
                } else [pSelf reloadRowsAtIndexPaths:a
                                    withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else [pSelf reloadData];
        return pSelf;
    };
}

- (__kindof UITableViewCell *(^)(NSString *))deqCell {
    __weak typeof(self) pSelf = self;
    return ^__kindof UITableViewCell *(NSString *s) {
        return [pSelf dequeueReusableCellWithIdentifier:s];
    };
}

- (__kindof UITableViewCell *(^)(NSString *, NSIndexPath *))deqCellS {
    __weak typeof(self) pSelf = self;
    return ^__kindof UITableViewCell *(NSString *s , NSIndexPath *indexP) {
        return [pSelf dequeueReusableCellWithIdentifier:s
                                           forIndexPath:indexP];
    };
}

- (__kindof UITableViewHeaderFooterView *(^)(NSString *))deqReusableView {
    __weak typeof(self) pSelf = self;
    return ^__kindof UITableViewHeaderFooterView *(NSString *s) {
        return [pSelf dequeueReusableHeaderFooterViewWithIdentifier:s];
    };
}

@end

#pragma mark - -----

@interface CCTableChainDelegate ()

@property (nonatomic , copy) CGFloat (^blockCellHeight)(UITableView *  , NSIndexPath *) ;
@property (nonatomic , copy) CGFloat (^blockSectionHeaderHeight)(UITableView *  , NSInteger ) ;
@property (nonatomic , copy) UIView *(^blockSectionHeader)(UITableView * , NSInteger ) ;
@property (nonatomic , copy) CGFloat (^blockSectionFooterHeight)(UITableView *  , NSInteger ) ;
@property (nonatomic , copy) UIView *(^blockSectionFooter)(UITableView * , NSInteger ) ;
@property (nonatomic , copy) BOOL (^blockDidSelect)(UITableView * , NSIndexPath *) ;

@end

@implementation CCTableChainDelegate

+ (CCTableChainDelegate<UITableViewDelegate> *(^)())common {
    return ^CCTableChainDelegate < UITableViewDelegate > * {
        CCTableChainDelegate < UITableViewDelegate > * t = CCTableChainDelegate.alloc.init;
        return t;
    };
}

- (CCTableChainDelegate *(^)(CGFloat (^)(UITableView *, NSIndexPath *)))cellHeight {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(CGFloat (^t)(UITableView *, NSIndexPath *)) {
        pSelf.blockCellHeight = [t copy];
        return pSelf;
    };
}

- (CCTableChainDelegate *(^)(CGFloat (^)(UITableView *, NSInteger)))sectionHeaderHeight {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(CGFloat (^t)(UITableView *, NSInteger)) {
        pSelf.blockSectionHeaderHeight = [t copy];
        return pSelf;
    };
}

- (CCTableChainDelegate *(^)(UIView *(^)(UITableView *, NSInteger)))sectionHeader {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(UIView *(^t)(UITableView *, NSInteger)) {
        pSelf.blockSectionHeader = [t copy];
        return pSelf;
    };
}

- (CCTableChainDelegate *(^)(CGFloat (^)(UITableView *, NSInteger)))sectionFooterHeight {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(CGFloat (^t)(UITableView *, NSInteger)) {
        pSelf.blockSectionFooterHeight = [t copy];
        return pSelf;
    };
}

- (CCTableChainDelegate *(^)(UIView *(^)(UITableView *, NSInteger)))sectionFooter {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(UIView *(^t)(UITableView *, NSInteger)) {
        pSelf.blockSectionFooter = [t copy];
        return pSelf;
    };
}

- (CCTableChainDelegate *(^)(BOOL (^)(UITableView *, NSIndexPath *)))didSelect {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDelegate *(BOOL (^t)(UITableView *, NSIndexPath *)) {
        pSelf.blockDidSelect = [t copy];
        return pSelf;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.blockCellHeight ? self.blockCellHeight(tableView , indexPath) : 45.f ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeaderHeight ? self.blockSectionHeaderHeight(tableView , section) : .0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeader ? self.blockSectionHeader(tableView , section) : nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.blockSectionFooter ? self.blockSectionFooter(tableView , section) : nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.blockSectionFooterHeight ? self.blockSectionFooterHeight(tableView , section) : .01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(tableView , indexPath)) {
            [tableView deselectRowAtIndexPath:indexPath animated:false];
        }
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@interface CCTableChainDataSource ()

@property (nonatomic , copy) NSInteger (^blockSections)(UITableView *);
@property (nonatomic , copy) NSInteger (^blockRowsInSections)(UITableView *  , NSInteger );
@property (nonatomic , copy) NSString * (^blockCellIdentifier)(UITableView * , NSIndexPath *) ;
@property (nonatomic , copy) __kindof UITableViewCell * (^blockConfigCell)(UITableView * , __kindof UITableViewCell * , NSIndexPath *) ;

@end

@implementation CCTableChainDataSource

+ (CCTableChainDataSource<UITableViewDataSource> *(^)())common {
    return ^CCTableChainDataSource<UITableViewDataSource> * {
        CCTableChainDataSource < UITableViewDataSource > *t = CCTableChainDataSource.alloc.init;
        return t;
    };
}

- (CCTableChainDataSource *(^)(NSInteger (^)(UITableView *)))sections {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataSource *(NSInteger (^t)(UITableView *)) {
        pSelf.blockSections = [t copy];
        return pSelf;
    };
}
- (CCTableChainDataSource *(^)(NSInteger (^)(UITableView *, NSInteger)))rowsInSections {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataSource *(NSInteger (^t)(UITableView *, NSInteger)) {
        pSelf.blockRowsInSections = [t copy];
        return pSelf;
    };
}
- (CCTableChainDataSource *(^)(NSString *(^)(UITableView *, NSIndexPath *)))cellIdentifier {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataSource *(NSString *(^t)(UITableView *, NSIndexPath *)) {
        pSelf.blockCellIdentifier = [t copy];
        return pSelf;
    };
}
- (CCTableChainDataSource *(^)(__kindof UITableViewCell *(^)(UITableView *, __kindof UITableViewCell *, NSIndexPath *)))configCell {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataSource *(__kindof UITableViewCell *(^t)(UITableView *, __kindof UITableViewCell *, NSIndexPath *)) {
        pSelf.blockConfigCell = [t copy];
        return pSelf;
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.blockSections ? self.blockSections(tableView) : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blockRowsInSections ? self.blockRowsInSections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sCellIdentifer = self.blockCellIdentifier ? self.blockCellIdentifier(tableView , indexPath) : _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_;
    
    UITableViewCell *cell = nil;
    if (self.blockCellIdentifier) cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifer
                                                                         forIndexPath:indexPath];
    else cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifer];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:sCellIdentifer];
    
    return self.blockConfigCell ? self.blockConfigCell(tableView , cell , indexPath) : cell;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@implementation NSArray (CCChain_Table_Refresh)

- (NSArray *(^)(UITableView *))reload {
    __weak typeof(self) pSelf = self;
    return ^NSArray *(UITableView *v) {
        if (pSelf.count) v.reloading(UITableViewRowAnimationFade);
        else [v reloadData];
        return pSelf;
    };
}

- (NSArray *(^)(UITableView *, NSIndexSet *))reloadSection {
    __weak typeof(self) pSelf = self;
    return ^NSArray *(UITableView *v , NSIndexSet *s) {
        if (pSelf.count) v.reloadSectionsT(s, UITableViewRowAnimationFade);
        else v.reloadSectionsT(s, UITableViewRowAnimationNone);
        return pSelf;
    };
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@interface CCTableChainDataPrefetching ()

@property (nonatomic , assign) BOOL isDisableBackground ;
@property (nonatomic , copy) void (^prefetching)(__kindof UITableView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UITableView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation CCTableChainDataPrefetching

+ (CCTableChainDataPrefetching<UITableViewDataSourcePrefetching> *(^)())common {
    return ^CCTableChainDataPrefetching<UITableViewDataSourcePrefetching> * {
        CCTableChainDataPrefetching < UITableViewDataSourcePrefetching > * t = CCTableChainDataPrefetching.alloc.init;
        return t;
    };
}

- (CCTableChainDataPrefetching *)disableBackgroundMode {
    self.isDisableBackground = YES;
    return self;
}

- (CCTableChainDataPrefetching *(^)(void (^)(__kindof UITableView *, NSArray<NSIndexPath *> *)))prefetchAt {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataPrefetching *(void (^t)(__kindof UITableView *, NSArray<NSIndexPath *> *)) {
        pSelf.prefetching = [t copy];
        return pSelf;
    };
}

- (CCTableChainDataPrefetching *(^)(void (^)(__kindof UITableView *, NSArray<NSIndexPath *> *)))cancelPrefetchAt {
    __weak typeof(self) pSelf = self;
    return ^CCTableChainDataPrefetching *(void (^t)(__kindof UITableView *, NSArray<NSIndexPath *> *)) {
        pSelf.canceling = [t copy];
        return pSelf;
    };
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.queue && !self.isDisableBackground) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.isDisableBackground) {
        __weak typeof(self) pSelf = self;
        dispatch_async(self.queue, ^{
            if (pSelf.prefetching) pSelf.prefetching(tableView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(tableView, indexPaths);
}
- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.canceling) self.canceling(tableView, indexPaths);
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#endif
