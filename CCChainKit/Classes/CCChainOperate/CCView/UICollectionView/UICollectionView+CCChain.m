//
//  UICollectionView+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UICollectionView+CCChain.h"

#ifndef _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_
    #define _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_ @"CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER"
#endif

@implementation UICollectionView (CCChain)

+ ( __kindof UICollectionView *(^)(CGRect, __kindof UICollectionViewFlowLayout *))commonC {
    return ^ __kindof UICollectionView *(CGRect r , __kindof UICollectionViewFlowLayout *l) {
        UICollectionView *c = [[UICollectionView alloc] initWithFrame:r
                                                 collectionViewLayout:l];
        c.backgroundColor = UIColor.clearColor;
        c.showsVerticalScrollIndicator = false;
        c.showsHorizontalScrollIndicator = false;
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            c.prefetchingEnabled = YES;
        }

        [c registerClass:UICollectionViewCell.class
forCellWithReuseIdentifier:_CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_];
        
        return c;
    };
}

- ( __kindof UICollectionView *(^)(id <UICollectionViewDelegateFlowLayout>))delegateT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(id <UICollectionViewDelegateFlowLayout> v) {
        if (v) pSelf.delegate = v;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(id <UICollectionViewDataSource>))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(id <UICollectionViewDataSource> v) {
        if (v) pSelf.dataSource = v;
        else pSelf.dataSource = nil;
        return pSelf;
    };
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- ( __kindof UICollectionView *(^)(id <UICollectionViewDataSourcePrefetching>))prefetchingT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(id <UICollectionViewDataSourcePrefetching> d) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            if (d) pSelf.prefetchDataSource = d;
            else pSelf.prefetchDataSource = nil;
        }
        return pSelf;
    };
}
#endif

- ( __kindof UICollectionView *(^)(NSString *))registNibS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(NSString *s) {
        return pSelf.registNib(s , nil);
    };
}

- ( __kindof UICollectionView *(^)(NSString *, NSBundle *))registNib {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
forCellWithReuseIdentifier:s];
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(__unsafe_unretained Class))registCls {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(Class c) {
        [pSelf registerClass:c
  forCellWithReuseIdentifier:NSStringFromClass(c)];
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(BOOL))reloading {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(BOOL b) {
        if (b) {
            pSelf.reloadSections([NSIndexSet indexSetWithIndex:0], b);
        } else [pSelf reloadData];
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(NSIndexSet *, BOOL))reloadSections {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(NSIndexSet *s , BOOL b) {
        if (b) {
            [pSelf reloadSections:s];
        } else {
            void (^t)() = ^ {
                [UIView setAnimationsEnabled:false];
                [pSelf performBatchUpdates:^{
                    [pSelf reloadSections:s];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
            };
            if (NSThread.isMainThread) t();
            else dispatch_sync(dispatch_get_main_queue(), ^{
                t();
            });
        }
        return pSelf;
    };
}

- ( __kindof UICollectionView *(^)(NSArray<NSIndexPath *> *))reloadItems {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UICollectionView *(NSArray<NSIndexPath *> *a) {
        [pSelf reloadItemsAtIndexPaths:(a ? a : @[])];
        return pSelf;
    };
}

- (__kindof UICollectionViewCell *(^)(NSString *, NSIndexPath *))deqCell {
    __weak typeof(self) pSelf = self;
    return ^__kindof UICollectionViewCell * (NSString *s , NSIndexPath *indexP) {
        return [pSelf dequeueReusableCellWithReuseIdentifier:s
                                                forIndexPath:indexP];
    };
}

- (__kindof UICollectionReusableView *(^)(NSString *, NSString *, NSIndexPath *))deqReuseableView {
    __weak typeof(self) pSelf = self;
    return ^__kindof UICollectionReusableView *(NSString *reuse , NSString *sId , NSIndexPath *indexP) {
        return [pSelf dequeueReusableSupplementaryViewOfKind:reuse
                                         withReuseIdentifier:sId
                                                forIndexPath:indexP];
    };
}

@end

#pragma mark - -----

@implementation UICollectionViewFlowLayout (CCChain)

+ (__kindof UICollectionViewFlowLayout *(^)())common {
    return ^__kindof UICollectionViewFlowLayout * {
        return UICollectionViewFlowLayout.alloc.init;
    };
}

- (__kindof UICollectionViewFlowLayout *(^)(CGSize))itemSizeC {
    __weak typeof(self) pSelf = self;
    return ^__kindof UICollectionViewFlowLayout *(CGSize s) {
        pSelf.itemSize = s;
        return pSelf;
    };
}

- (__kindof UICollectionViewFlowLayout *(^)(UIEdgeInsets))sectionInsetC {
    __weak typeof(self) pSelf = self;
    return ^__kindof UICollectionViewFlowLayout *(UIEdgeInsets s) {
        pSelf.sectionInset = s;
        return pSelf;
    };
}

- (__kindof UICollectionViewFlowLayout *(^)(CGSize))headerSizeC {
    __weak typeof(self) pSelf = self;
    return ^__kindof UICollectionViewFlowLayout *(CGSize s) {
        pSelf.headerReferenceSize = s;
        return pSelf;
    };
}

@end

#pragma mark - -----

@interface CCCollectionChainDelegate ()

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^blockDidHighlight)(UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^blockDidUnHighlight)(UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) CGFloat (^blockMinimumLineSpacingInSection)(UICollectionView * , UICollectionViewLayout * , NSInteger ) ;
@property (nonatomic , copy) CGFloat (^blockMinimumInterItemSpacingInSection)(UICollectionView * , UICollectionViewLayout * , NSInteger ) ;
@property (nonatomic , copy) UIEdgeInsets (^blockSpacingBetweenSections)(UICollectionView * , UICollectionViewLayout * , NSInteger ) ;

@end

@implementation CCCollectionChainDelegate

+ (CCCollectionChainDelegate<UICollectionViewDelegateFlowLayout> *(^)())common {
    return ^ CCCollectionChainDelegate<UICollectionViewDelegateFlowLayout> * {
        CCCollectionChainDelegate <UICollectionViewDelegateFlowLayout> * t = CCCollectionChainDelegate.alloc.init;
        return t;
    };
}

- (CCCollectionChainDelegate *(^)(BOOL (^)(UICollectionView *, NSIndexPath *)))didSelect {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(BOOL (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidSelect = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didHighlight {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidHighlight  = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didUnHighlight {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidUnHighlight = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))minimumLineSpacingInSection {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(CGFloat (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.blockMinimumLineSpacingInSection = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))minimumInterItemSpacingInSection {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(CGFloat (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.blockMinimumInterItemSpacingInSection = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(UIEdgeInsets (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))spacingBetweenSections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(UIEdgeInsets (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.blockSpacingBetweenSections = [t copy];
        return pSelf;
    };
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(collectionView , indexPath)) {
            [collectionView deselectItemAtIndexPath:indexPath animated:false];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidHighlight)
        self.blockDidHighlight(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidUnHighlight)
        self.blockDidUnHighlight(collectionView, indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.blockMinimumLineSpacingInSection ? self.blockMinimumLineSpacingInSection(collectionView , collectionViewLayout , section) : .0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.blockMinimumInterItemSpacingInSection ? self.blockMinimumInterItemSpacingInSection (collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.blockSpacingBetweenSections ? self.blockSpacingBetweenSections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@interface CCCollectionChainDataSource ()

@property (nonatomic , copy) NSInteger (^blockSections)(UICollectionView *) ;
@property (nonatomic , copy) NSInteger (^blockItemsInSections)(UICollectionView *  , NSInteger ) ;
@property (nonatomic , copy) NSString *(^blockCellIdentifier)(UICollectionView *  , NSIndexPath * ) ;
@property (nonatomic , copy) __kindof UICollectionViewCell *(^blockConfigCell)(UICollectionView *  , __kindof UICollectionViewCell *  , NSIndexPath * );

@end

@implementation CCCollectionChainDataSource

+ (CCCollectionChainDataSource<UICollectionViewDataSource> *(^)())common {
    return ^ CCCollectionChainDataSource<UICollectionViewDataSource> * {
        CCCollectionChainDataSource < UICollectionViewDataSource > * t = CCCollectionChainDataSource.alloc.init;
        return t;
    };
}

- (CCCollectionChainDataSource *(^)(NSInteger (^)(UICollectionView *)))sections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSInteger (^t)(UICollectionView *)) {
        if (t) pSelf.blockSections = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(NSInteger (^)(UICollectionView *, NSInteger)))itemsInSections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSInteger (^t)(UICollectionView *, NSInteger)) {
        if (t) pSelf.blockItemsInSections = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(NSString *(^)(UICollectionView *, NSIndexPath *)))identifierS {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSString *(^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockCellIdentifier = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(__kindof UICollectionViewCell *(^)(UICollectionView *, __kindof UICollectionViewCell *, NSIndexPath *)))configCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(__kindof UICollectionViewCell *(^t)(UICollectionView *, __kindof UICollectionViewCell *, NSIndexPath *)) {
        if (t) pSelf.blockConfigCell = [t copy];
        return pSelf;
    };
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.blockSections ? self.blockSections(collectionView) : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.blockItemsInSections ? self.blockItemsInSections(collectionView , section) : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sCellIdentifier = self.blockCellIdentifier ? self.blockCellIdentifier(collectionView , indexPath) : _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sCellIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell) cell = [[UICollectionViewCell alloc] init];
    
    return self.blockConfigCell ? self.blockConfigCell(collectionView , cell , indexPath) : cell;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@implementation NSArray (CCChain_Collection_Refresh)

- (NSArray *(^)(UICollectionView *))reload {
    __weak typeof(self) pSelf = self;
    return ^NSArray *(UICollectionView *c) {
        if (pSelf.count) c.reloading(YES);
        else [c reloadData];
        return pSelf;
    };
}

- (NSArray *(^)(UICollectionView *, NSIndexSet *))reloadSection {
    __weak typeof(self) pSelf = self;
    return ^NSArray *(UICollectionView *c , NSIndexSet *s) {
        if (pSelf.count) c.reloadSections(s, YES);
        else c.reloadSections(s, false);
        return pSelf;
    };
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <objc/runtime.h>

@interface CCCollectionChainDataPrefetching ()

@property (nonatomic , assign) BOOL isDisableBackground ;
@property (nonatomic , copy) void (^prefetching)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation CCCollectionChainDataPrefetching

+ (CCCollectionChainDataPrefetching<UICollectionViewDataSourcePrefetching> *(^)())common {
    return ^CCCollectionChainDataPrefetching<UICollectionViewDataSourcePrefetching> * {
        CCCollectionChainDataPrefetching  <UICollectionViewDataSourcePrefetching> * v = [[CCCollectionChainDataPrefetching alloc] init];
        v.isDisableBackground = false;
        return v;
    };
}

- (CCCollectionChainDataPrefetching *)disableBackgroundMode {
    self.isDisableBackground = YES;
    return self;
}

- (CCCollectionChainDataPrefetching *(^)(void (^)(__kindof UICollectionView *, NSArray<NSIndexPath *> *)))prefetchAt {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataPrefetching *(void (^t)(__kindof UICollectionView *, NSArray<NSIndexPath *> *)) {
        pSelf.prefetching = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataPrefetching *(^)(void (^)(__kindof UICollectionView *, NSArray<NSIndexPath *> *)))cancelPrefetchAt {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataPrefetching *(void (^t)(__kindof UICollectionView *, NSArray<NSIndexPath *> *)) {
        pSelf.canceling = [t copy];
        return pSelf;
    };
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
    if (!self.queue && !self.isDisableBackground) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.isDisableBackground) {
        __weak typeof(self) pSelf = self;
        dispatch_async(self.queue, ^{
            if (pSelf.prefetching) pSelf.prefetching(collectionView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(collectionView, indexPaths);
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  NS_AVAILABLE_IOS(10_0) {
    if (self.canceling) self.canceling(collectionView , indexPaths);
}

@end

#endif
