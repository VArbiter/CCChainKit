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

@interface CCRLMBaseModel : RLMObject

+ (instancetype) ccCommon ;
+ (instancetype) ccCommonD : (NSDictionary *) dictionary ;
+ (instancetype) ccCommonA : (NSArray *) array ;

- (instancetype) ccSpecific : (NSString *) specificDataBase ; //  default : defalut
+ (CCRealmHandler *) ccOperate : (void (^)()) transaction ; // in transaction
+ (CCRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)()) transaction ; // specific database in transaction
- (CCRealmHandler *) ccSave ;

// when a delete complete , do sth more like reloading data (prevent crash)

- (CCRealmHandler *) ccDeleteT ; // delete an object according to object
- (CCRealmHandler *) ccDeleteS ; // delete an object according to primarykey
+ (CCRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <CCRLMBaseModel *> *) array ;
+ (CCRealmHandler *) ccDeleteAll : (NSString *) specificDataBase ; /// delete all data in a class

+ (RLMResults *) ccAll : (NSString *) specificDataBase ; // all results
/// add a notification to all objects in this class
+ (CCRealmHandler *) ccNotification : (NSString *) specificDataBase
                             change : (void (^)(RLMResults * results,
                                                RLMCollectionChange * change,
                                                NSError * error)) changeN ;
@end
