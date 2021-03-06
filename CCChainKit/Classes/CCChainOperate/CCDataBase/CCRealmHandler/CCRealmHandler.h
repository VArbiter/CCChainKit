//
//  CCRealmHandler.h
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#if __has_include(<Realm/Realm.h>)

#import <Foundation/Foundation.h>
@import Realm;

// dependency : pod 'Realm', '~> 2.10.0'

@interface CCRealmHandler : NSObject

// ----- open -----

/// absolute singleton . (realm do all the actions async && atomic)
@property (nonatomic , class , copy , readonly) CCRealmHandler *shared ;
@property (nonatomic , copy , readonly) CCRealmHandler *(^defaultT)(); // equal : specific(nil)
@property (nonatomic , copy , readonly) CCRealmHandler *(^specific)(NSString *) ; // open a specific realm
@property (nonatomic , copy , readonly) CCRealmHandler *(^operate)(dispatch_block_t) ; // do actions in transaction

// ----- insert -----

/// use a dictionary as intializer , a key must compare a value , but not neccessary to include all the keys
/// if dictioanry == nil , realm will continue to create an object
@property (nonatomic , copy , readonly) id (^dictionary)(Class , NSDictionary *) ;
// use an array as intializer , values must have the same order with keys , not much , not less
/// if array == nil , realm will continue to create an object
@property (nonatomic , copy , readonly) id (^array)(Class , NSArray *) ;
/// if object has a primary key , then insert or update , otherwise , insert only
@property (nonatomic , copy , readonly) CCRealmHandler *(^save)(id);

// ----- delete -----

/// delete an object according to object , might goes error
@property (nonatomic , copy , readonly) CCRealmHandler *(^deleteT)(id);
/// delete an object according to a primary key .
@property (nonatomic , copy , readonly) CCRealmHandler *(^deleteS)(id);
/// delete an array in realm
@property (nonatomic , copy , readonly) CCRealmHandler *(^deleteA)(NSArray <__kindof RLMObject *>*);
/// delete all the data in class
@property (nonatomic , copy , readonly) CCRealmHandler *(^deleteAC)(Class);
/// not it self , but the data in it
@property (nonatomic , copy , readonly) CCRealmHandler *(^deleteAll)();
/// delete it self
@property (nonatomic , copy , readonly) CCRealmHandler *(^destory)(NSString *);

// ----- search -----

/// RLMResults
/// note : insert / delete will cause the change of this collection .
/// note : cause this collection was mirrored in local disk
@property (nonatomic , copy , readonly) RLMResults *(^all)(Class);

// ----- sort -----

/// class that need sorted , property , ascending or not (have to use this action after sorting)
@property (nonatomic , copy , readonly) RLMResults *(^sorted)(Class , NSString * , BOOL) ;

// ----- migration -----
@property (nonatomic , copy , readonly) CCRealmHandler *(^migration)(uint64_t , void (^t)(RLMRealmConfiguration *c , RLMMigration *m , uint64_t vOld));
@property (nonatomic , copy , readonly) CCRealmHandler *(^migrationT)(RLMRealmConfiguration *(^m)() , void (^t)(RLMMigration *m , uint64_t vOld));

// ----- status -----
// use them before every actions
@property (nonatomic , copy , readonly) CCRealmHandler *(^error)(void (^t)(NSError *e)) ;
@property (nonatomic , copy , readonly) CCRealmHandler *(^succeed)(void (^s)(BOOL b)) ;

// ----- notification -----
@property (nonatomic , copy , readonly) CCRealmHandler *(^notification)(void (^t)(RLMNotification n, RLMRealm *r));

@end

#endif
