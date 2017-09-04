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

+ (UICollectionView *(^)(CGRect, UICollectionViewFlowLayout *))commonC {
    return ^UICollectionView *(CGRect r , UICollectionViewFlowLayout *l) {
        UICollectionView *c = [[UICollectionView alloc] initWithFrame:r
                                                 collectionViewLayout:l];
        c.backgroundColor = UIColor.clearColor;
        c.showsVerticalScrollIndicator = false;
        c.showsHorizontalScrollIndicator = false;
        c.prefetchingEnabled = YES;
        
        [c registerClass:UICollectionViewCell.class
forCellWithReuseIdentifier:_CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_];
        
        return c;
    };
}

- (UICollectionView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.delegate = v;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- (UICollectionView *(^)(id))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.dataSource = v;
        else pSelf.dataSource = nil;
        return pSelf;
    };
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (UICollectionView *(^)(id))prefetchingT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id d) {
        if (d) pSelf.prefetchDataSource = d;
        else pSelf.prefetchDataSource = nil;
        return pSelf;
    };
}
#endif

- (UICollectionView *(^)(NSString *))registNibS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSString *s) {
        return pSelf.registNib(s , nil);
    };
}

- (UICollectionView *(^)(NSString *, NSBundle *))registNib {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
forCellWithReuseIdentifier:s];
        return pSelf;
    };
}

- (UICollectionView *(^)(__unsafe_unretained Class))registCls {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(Class c) {
        [pSelf registerClass:c
  forCellWithReuseIdentifier:NSStringFromClass(c)];
        return pSelf;
    };
}

- (UICollectionView *(^)(BOOL))reloading {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(BOOL b) {
        if (b) {
            pSelf.reloadSections([NSIndexSet indexSetWithIndex:0], b);
        } else [pSelf reloadData];
        return pSelf;
    };
}

- (UICollectionView *(^)(NSIndexSet *, BOOL))reloadSections {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSIndexSet *s , BOOL b) {
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

- (UICollectionView *(^)(NSArray<NSIndexPath *> *))reloadItems {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSArray<NSIndexPath *> *a) {
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

+ (UICollectionViewFlowLayout *(^)())common {
    return ^UICollectionViewFlowLayout * {
        return UICollectionViewFlowLayout.alloc.init;
    };
}

- (UICollectionViewFlowLayout *(^)(CGSize))itemSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.itemSize = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(UIEdgeInsets))sectionInsetC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(UIEdgeInsets s) {
        pSelf.sectionInset = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(CGSize))headerSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.headerReferenceSize = s;
        return pSelf;
    };
}

@end

#pragma mark - -----

@interface CCCollectionChainDelegate ()

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^blockDidHightedCell)(UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^blockDidUnhigntedCell)(UICollectionView * , NSIndexPath *) ;
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

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didHightedCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidHightedCell = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didUnhigntedCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidUnhigntedCell = [t copy];
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
    if (self.blockDidHightedCell)
        self.blockDidHightedCell(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidUnhigntedCell)
        self.blockDidUnhigntedCell(collectionView, indexPath);
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
@property (nonatomic , copy) UICollectionViewCell *(^blockConfigCell)(UICollectionView *  , UICollectionViewCell *  , NSIndexPath * );

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

- (CCCollectionChainDataSource *(^)(__kindof UICollectionViewCell *(^)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)))configCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(__kindof UICollectionViewCell *(^t)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)) {
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
