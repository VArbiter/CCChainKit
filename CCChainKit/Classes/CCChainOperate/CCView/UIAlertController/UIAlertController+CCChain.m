//
//  UIAlertController+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIAlertController+CCChain.h"
#import <objc/runtime.h>

@implementation UIAlertController (CCChain)

+ ( __kindof UIAlertController *(^)())common {
    return ^ __kindof UIAlertController * {
        return self.commonS(UIAlertControllerStyleAlert);
    };
}
+ ( __kindof UIAlertController *(^)(UIAlertControllerStyle))commonS {
    return ^ __kindof UIAlertController *(UIAlertControllerStyle s) {
        return [UIAlertController alertControllerWithTitle:nil
                                                   message:nil
                                            preferredStyle:s];
    };
}

- ( __kindof UIAlertController *(^)(NSString *))titleS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIAlertController *(NSString *s) {
        pSelf.title = s;
        return pSelf;
    };
}
- ( __kindof UIAlertController *(^)(NSString *))messageS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIAlertController *(NSString *s) {
        pSelf.message = s;
        return pSelf;
    };
}

- ( __kindof UIAlertController *(^)(CCAlertActionInfo *, void (^)( __kindof UIAlertAction *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIAlertController *(CCAlertActionInfo *d, void (^t)( __kindof UIAlertAction *)) {
        CCAlertActionEntity *m = [[CCAlertActionEntity alloc] init];
        m.sTitle = d[@"title"];
        m.style = (UIAlertActionStyle)[d[@"style"] integerValue];
        
        UIAlertAction *a = [UIAlertAction actionWithTitle:m.sTitle
                                                    style:m.style
                                                  handler:t];
        a.actionM = m;
        if (a) [pSelf addAction:a];
        return pSelf;
    };
}
- ( __kindof UIAlertController *(^)(NSArray<CCAlertActionInfo *> *, void (^)( __kindof UIAlertAction *, NSUInteger)))actionA {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIAlertController *(NSArray<CCAlertActionInfo *> *a, void (^t)( __kindof UIAlertAction *, NSUInteger)) {
        [a enumerateObjectsUsingBlock:^(CCAlertActionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCAlertActionEntity *m = [[CCAlertActionEntity alloc] init];
            m.sTitle = obj[@"title"];
            m.style = (UIAlertActionStyle)[obj[@"style"] integerValue];
            
            UIAlertAction *a = [UIAlertAction actionWithTitle:m.sTitle
                                                        style:m.style
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if (t) t(action , idx);
                                                      }];
            a.actionM = m;
            if (a) [pSelf addAction:a];
        }];
        return pSelf;
    };
}


CCAlertActionInfo * CCAlertActionInfoMake(NSString * sTitle, UIAlertActionStyle style) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:sTitle forKey:@"title"];
    [d setValue:@(style) forKey:@"style"];
    return d;
}

@end

#pragma mark - -----

@implementation CCAlertActionEntity
@end

#pragma mark - -----

@implementation UIAlertAction (CCExtension)

- (void)setActionM:(CCAlertActionEntity *)actionM {
    objc_setAssociatedObject(self, @selector(actionM), actionM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CCAlertActionEntity *)actionM {
    return objc_getAssociatedObject(self, _cmd);
}

@end
