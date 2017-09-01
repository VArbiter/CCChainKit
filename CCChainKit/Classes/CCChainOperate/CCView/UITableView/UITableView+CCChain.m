//
//  UITableView+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 01/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "UITableView+CCChain.h"

@implementation UITableView (CCChain)

+ (UITableView *(^)(CGRect))common {
    return ^UITableView * (CGRect r) {
        return self.commonC(r, UITableViewStylePlain);
    };
}

+ (UITableView *(^)(CGRect, UITableViewStyle))commonC {
    return ^UITableView * (CGRect r , UITableViewStyle st) {
        UITableView *v  = [[UITableView alloc] initWithFrame:r
                                                       style:st];
        v.showsVerticalScrollIndicator = false;
        v.showsHorizontalScrollIndicator = false;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.backgroundColor = UIColor.clearColor;
        return v;
    };
}

- (UITableView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UITableView * (id d) {
        if (d) pSelf.delegate = d;
        else pSelf.delegate = nil;
        return pSelf;
    };
}

- (UITableView *(^)(id))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(id d) {
        if (d) pSelf.dataSource = d;
        else pSelf.dataSource = nil;
        return pSelf;
    };
}

- (UITableView *(^)(NSString *))registNibS {
    __weak typeof(self) pSelf = self;
    return ^UITableView * (NSString *s) {
        return pSelf.registNib(s , nil);
    };
}

- (UITableView *(^)(NSString *, NSBundle *))registNib {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
    forCellReuseIdentifier:s];
        return pSelf;
    };
}

- (UITableView *(^)(__unsafe_unretained Class))registCls {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(Class cls) {
        [pSelf registerClass:cls
      forCellReuseIdentifier:NSStringFromClass(cls)];
        return pSelf;
    };
}

- (UITableView *(^)(NSString *))registHeaderFooterNib {
    __weak typeof(self) pSelf = self;
    return ^UITableView * (NSString *s) {
        return pSelf.registHeaderFooterNibS(s , nil);
    };
}

- (UITableView *(^)(NSString *, NSBundle *))registHeaderFooterNibS {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(NSString *s , NSBundle *b) {
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

- (UITableView *(^)(__unsafe_unretained Class))registHeaderFooterCls {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(Class cls) {
        if (cls == UITableViewHeaderFooterView.class
            || [cls isSubclassOfClass:UITableViewHeaderFooterView.class]){
            [pSelf registerClass:cls forHeaderFooterViewReuseIdentifier:NSStringFromClass(cls)];
        }
        return pSelf;
    };
}

- (UITableView *(^)(void (^)()))updating {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(void (^t)()) {
        if (t) {
            [pSelf beginUpdates];
            t();
            [pSelf endUpdates];
        }
        return pSelf;
    };
}

- (UITableView *(^)(UITableViewRowAnimation))reloading {
    __weak typeof(self) pSelf = self;
    return ^UITableView * (UITableViewRowAnimation anim) {
        if ((NSInteger)anim > 0 && anim != UITableViewRowAnimationNone) {
            return pSelf.reloadSectionsT([NSIndexSet indexSetWithIndex:0] , anim);
        }
        else [pSelf reloadData];
        return pSelf;
    };
}

- (UITableView *(^)(NSIndexSet *, UITableViewRowAnimation))reloadSectionsT {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(NSIndexSet *set, UITableViewRowAnimation anim) {
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

- (UITableView *(^)(NSArray<NSIndexPath *> *, UITableViewRowAnimation))reloadItemsT {
    __weak typeof(self) pSelf = self;
    return ^UITableView *(NSArray <NSIndexPath *> *a , UITableViewRowAnimation anim) {
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
