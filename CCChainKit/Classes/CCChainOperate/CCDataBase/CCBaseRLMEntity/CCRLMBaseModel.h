//
//  CCRLMBaseModel.h
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRealmHandler.h"

/// WHY I use methods in ChainKit ?
/// 1. all realm objects was lazy loaded .
/// 2. sending nil to blocks will cause crash , 100 % , no exception
/// 3. if an object deleted , and then do sth more , went crash .
/// 4. that's why.

#if __has_include(<Realm/Realm.h>)

@interface CCRLMBaseModel : RLMObject

+ (instancetype) ccCommon ;
+ (instancetype) ccCommonD : (NSDictionary *) dictionary ;
+ (instancetype) ccCommonA : (NSArray *) array ;

///  default : defalut
- (instancetype) ccSpecific : (NSString *) specificDataBase ;
/// in transaction
+ (CCRealmHandler *) ccOperate : (void (^)()) transaction ;
/// specific database in transaction
+ (CCRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)()) transaction ;
- (CCRealmHandler *) ccSave ;

// when a delete complete , do sth more like reloading data (prevent crash)

/// delete an object according to object
- (CCRealmHandler *) ccDeleteT ;
/// delete an object according to primarykey
- (CCRealmHandler *) ccDeleteS ;
+ (CCRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <CCRLMBaseModel *> *) array ;
/// delete all data in a class
+ (CCRealmHandler *) ccDeleteAll : (NSString *) specificDataBase ;

/// all results
+ (RLMResults *) ccAll : (NSString *) specificDataBase ;
/// add a notification to all objects in this class
+ (CCRealmHandler *) ccNotification : (NSString *) specificDataBase
                             change : (void (^)(RLMResults * results,
                                                RLMCollectionChange * change,
                                                NSError * error)) changeN ;
@end

#endif
