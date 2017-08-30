//
//  CCRLMBaseModel.m
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRLMBaseModel.h"

@interface CCRLMBaseModel ()

// 即使是延展也会被储存
// 协议拓展的可读写也会被作为实例变量进行储存 ,
// 也需要在忽略中声明
@property (nonatomic , copy) NSString * specificBase ;

@end

static RLMNotificationToken *__ccToken = nil;

@implementation CCRLMBaseModel

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"specificBase",@"ccToken"]; // 忽略可存储属性
}

/*
+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    // 反向关系补充
    return @{@"这个类中哪个属性被声明为RLMLinkingObjects" : [RLMPropertyDescriptor descriptorWithClass:NSClassFromString(@"关联的类名")propertyName:@"关联类中哪个集合存放这个类的属性"]};
}

+ (NSString *)primaryKey {
    return @"主键";
}

+ (NSArray<NSString *> *)requiredProperties {
    // 设置这个 , 无值直接崩溃 , 所以要结合默认值一起使用
    // 后期赋值 为 nil / NULL 仍然会崩溃 .
    return @[@"非空属性集合"]; 
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"非空字段" : @"默认值"};
}
 */

+ (instancetype) ccCommon {
    return CCRealmHandler.shared.dictionary(self, nil);
}
+ (instancetype) ccCommonD : (NSDictionary *) dictionary {
    return CCRealmHandler.shared.dictionary(self, dictionary);
}
+ (instancetype) ccCommonA : (NSArray *) array {
    return CCRealmHandler.shared.array(self, array);
}
- (instancetype) ccSpecific : (NSString *) specificDataBase {
    if (specificDataBase.length > 0) self.specificBase = specificDataBase;
    return self;
}

+ (CCRealmHandler *) ccOperate : (void (^)()) transaction {
    return [self ccOperate:nil
               transaction:transaction];
}
+ (CCRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)()) transaction {
    return CCRealmHandler.shared.specific(specificDataBase).operate(^{
        if (transaction) transaction();
    });
}
- (CCRealmHandler *) ccSave {
    return CCRealmHandler.shared.specific(self.specificBase).save(self);
}

- (CCRealmHandler *) ccDeleteT {
    return CCRealmHandler.shared.specific(self.specificBase).deleteT(self);
}
- (CCRealmHandler *) ccDeleteS {
    return CCRealmHandler.shared.specific(self.specificBase).deleteS(self);
}
+ (CCRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <CCRLMBaseModel *> *) array {
    return CCRealmHandler.shared.specific(specificDataBase).deleteA(array);
}
+ (CCRealmHandler *) ccDeleteAll : (NSString *) specificDataBase {
    return CCRealmHandler.shared.specific(specificDataBase).deleteAC(self);
}

+ (RLMResults *) ccAll : (NSString *) specificDataBase {
    return CCRealmHandler.shared.specific(specificDataBase).all(self);
}
/// 针对这个类中所有元素添加通知
+ (CCRealmHandler *) ccNotification : (NSString *) specificDataBase
                             change : (void (^)(RLMResults * , RLMCollectionChange * , NSError * )) changeN {
    if (__ccToken) {
        [__ccToken stop];
        __ccToken = nil;
    }
    __ccToken = [[self ccAll:specificDataBase] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (changeN) {
            // change.insertions; // 插入
            // change.deletions; // 删除
            // change.modifications; // 更改
            changeN(results , change , error);
        }
    }];
    return CCRealmHandler.shared;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
