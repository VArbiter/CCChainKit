//
//  CCRealmHandler.m
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#if __has_include(<Realm/Realm.h>)

#import "CCRealmHandler.h"

#import <objc/runtime.h>

@interface CCRealmHandler () < NSCopying , NSMutableCopying >

@property (nonatomic , readonly , copy) CCRealmHandler *(^defaultSettings)(dispatch_block_t);
@property (nonatomic , strong) RLMRealm *realm;
@property (nonatomic , strong) RLMNotificationToken *token; // must decorate with strong , otherwise it will release before useing

@end

static CCRealmHandler *_handler = nil;
static const char * _CC_RLM_ERROR_KEY_ = "_CC_RLM_ERROR_KEY_";
static const char * _CC_RLM_SUCCEED_KEY_ = "_CC_RLM_SUCCEED_KEY_";
static const char * _CC_RLM_NOTIFICATION_KEY_ = "_CC_RLM_NOTIFICATION_KEY_";

@implementation CCRealmHandler

+ (CCRealmHandler *)shared {
    if (_handler) return _handler;
    _handler = [[CCRealmHandler alloc] init];
    return _handler;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_handler) return _handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [super allocWithZone:zone];
    });
    return _handler;
}

- (id)copyWithZone:(NSZone *)zone {
    return _handler;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _handler;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.defaultSettings(^{
            
        });
    }
    return self;
}

- (CCRealmHandler *(^)())defaultT {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler * {
        return pSelf.specific(nil);
    };
}

- (CCRealmHandler *(^)(NSString *))specific {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(NSString * base) {
        if (pSelf.token) {
            [pSelf.token stop];
            pSelf.token = nil;
        }
        
        if (base.length > 0) {
            /// for now , using default folder and path .
            /// using user name to replace the default name .
            /// get configuration
            RLMRealmConfiguration *c = [RLMRealmConfiguration defaultConfiguration];
            c.fileURL = [[[c.fileURL URLByDeletingLastPathComponent]
                          URLByAppendingPathComponent:base]
                         URLByAppendingPathExtension:@"realm"];
            NSError *error = nil;
            // this below , will change the default realm 's configuration .
            [RLMRealmConfiguration setDefaultConfiguration:c];
            // c.readOnly = YES; // read only or not
            pSelf.realm = [RLMRealm realmWithConfiguration:c
                                                     error:&error];
            void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_);
            if (b) {b(error ? false : YES);}
            if (error) {
#if DEBUG
                @throw @"open database failed.";
#else
                void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_);
                if (e) {e(error);}
#endif
                return pSelf;
            }
        }
        else pSelf.realm = [RLMRealm defaultRealm];
        
        pSelf.token = [pSelf.realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
            void (^t)(RLMNotification n, RLMRealm *r) = objc_getAssociatedObject(pSelf, _CC_RLM_NOTIFICATION_KEY_);
            if (t) {
                t(notification , realm);
            }
        }];
        
        return pSelf;
    };
}

- (CCRealmHandler *(^)(dispatch_block_t))operate {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler * (dispatch_block_t t) {
        NSError *error = nil;
        if ([pSelf.realm inWriteTransaction]) {
#if DEBUG
            @throw @"Realm is already in transaction .";
#else
            void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_);
            if (e) {e([NSError errorWithDomain:@"Realm is already in transaction ."
                                          code:-101
                                      userInfo:nil]);}
#endif
        } else {
            [pSelf.realm transactionWithBlock:^{
                if (t) t();
            } error:&error];
        }
        void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_);
        if (b) {b(error ? false : YES);}
        if (error) {
            void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_);
            if (e) {e(error);}
        }
        return pSelf;
    };
}

- (id(^)(__unsafe_unretained Class, NSDictionary *))dictionary {
    return ^CCRealmHandler *(Class clazz , NSDictionary *dictionary) {
        if ([clazz isSubclassOfClass:[RLMObject class]]) {
            id v = nil;
            if (dictionary.allKeys.count > 0) {
                v = [[clazz alloc] initWithValue:dictionary];
                // eqlals with above
//                [clazz createInRealm:pSelf.realm
//                           withValue:dictionary];
            }
            else v = [[clazz alloc] init];
            return v;
        }
        return nil;
    };
}

- (id(^)(__unsafe_unretained Class, NSArray *))array {
    return ^CCRealmHandler *(Class clazz , NSArray * array) {
        if ([clazz isSubclassOfClass:[RLMObject class]]) {
            id v = nil;
            if (array.count > 0) {
                v = [[clazz alloc] initWithValue:array];
            }
            else v = [[clazz alloc] init];
            return v;
        };
        return nil;
    };
}

- (CCRealmHandler *(^)(id))save {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(id model) {
        if (![[model class] isSubclassOfClass:[RLMObject class]]) return pSelf;
        return pSelf.operate(^{
            void (^t)() = ^ {
                [pSelf.realm addObject:model]; // if not , insert only
            };
            if ([[model class] respondsToSelector:@selector(primaryKey)]) {
                id value = [[model class] performSelector:@selector(primaryKey)];
                if (value) [pSelf.realm addOrUpdateObject:model]; // if has a primaryKey , it will be insert or update
                else t();
            }
            else t();
        });
    };
}

- (CCRealmHandler *(^)(id))deleteT {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(id model) {
        if (![[model class] isSubclassOfClass:[RLMObject class]]) return pSelf;
        return CCRealmHandler.shared.operate(^{
            [pSelf.realm deleteObject:model];
        });
    };
}

- (CCRealmHandler *(^)(id))deleteS {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(id model) {
        if (![[model class] isSubclassOfClass:[RLMObject class]]) return pSelf;
        if ([[model class] respondsToSelector:@selector(primaryKey)]) {
            NSString *pk = [[model class] performSelector:@selector(primaryKey)];
            RLMResults *r = [[model class] objectsWhere:[NSString stringWithFormat:@"%@ = %@" ,pk , [model valueForKeyPath:pk]]];
            if (r.count > 0) {
                return CCRealmHandler.shared.operate(^{
                    [pSelf.realm deleteObjects:r];
                });
            }
        }
        return pSelf;
    };
}

- (CCRealmHandler *(^)(NSArray<__kindof RLMObject *> *))deleteA {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(NSArray<__kindof RLMObject *> *a) {
        return CCRealmHandler.shared.operate(^{
            [pSelf.realm deleteObjects:a];
        });
    };
}

- (CCRealmHandler *(^)(__unsafe_unretained Class))deleteAC {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(Class clazz) {
        if (![clazz isKindOfClass:[RLMObject class]]) return pSelf;
        return CCRealmHandler.shared.operate(^{
            [pSelf.realm deleteObjects:[clazz allObjects]];
        });
    };
}

- (CCRealmHandler *(^)())deleteAll {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler * {
        return CCRealmHandler.shared.operate(^{
            [pSelf.realm deleteAllObjects];
        });
    };
}

- (CCRealmHandler *(^)(NSString *))destory {
#if !DEBUG
    __weak typeof(self) pSelf = self;
#endif
    return ^CCRealmHandler * (NSString *base){
        // still default configuration
        RLMRealmConfiguration *c = [RLMRealmConfiguration defaultConfiguration];
        c.fileURL = [[[c.fileURL URLByDeletingLastPathComponent]
                      URLByAppendingPathComponent:base]
                     URLByAppendingPathExtension:@"realm"];
        // the org. gave out this path .
        // not entirely delete ...
        NSArray <NSURL *> *a = @[c.fileURL,
                                 [c.fileURL URLByAppendingPathExtension:@"lock"],
                                 [c.fileURL URLByAppendingPathExtension:@"log_a"],
                                 [c.fileURL URLByAppendingPathExtension:@"log_b"],
                                 [c.fileURL URLByAppendingPathExtension:@"note"]];
        NSFileManager *m = NSFileManager.defaultManager;
        [a enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error = nil;
            if (![m removeItemAtURL:obj
                              error:&error]) {
#if DEBUG
                @throw @"delete Error .";
#else
                void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_);
                if (b) {b(error ? false : YES);}
                if (error) {
                    void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_);
                    if (e) {e(error);}
                }
#endif
            }
        }];
        return CCRealmHandler.shared;
    };
}

-(RLMResults *(^)(__unsafe_unretained Class))all {
    __weak typeof(self) pSelf = self;
    return ^RLMResults * (Class clazz){
        if (![clazz isSubclassOfClass:[RLMObject class]]) return nil;
        id value = [clazz allObjectsInRealm:pSelf.realm];
        return value;
    };
}

- (RLMResults *(^)(__unsafe_unretained Class , NSString *, BOOL))sorted {
    __weak typeof(self) pSelf = self;
    return ^RLMResults *(Class c, NSString * p , BOOL b) {
        RLMResults *r = pSelf.all(c);
        if ([r isKindOfClass:[RLMResults class]]) {
            RLMResults *t = [r sortedResultsUsingKeyPath:p
                                               ascending:b];
            return t;
        }
        return nil;
    };
}

- (CCRealmHandler *(^)(uint64_t , void (^)(RLMRealmConfiguration *, RLMMigration *, uint64_t)))migration {
    /// increase the version number to trigger migration .
    /// default is 0.
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(uint64_t vNew, void (^t)(RLMRealmConfiguration *c , RLMMigration *m , uint64_t vOld)) {
        if (!t) return pSelf;
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        // config.deleteRealmIfMigrationNeeded = YES; // if needed , delete realm , currently , not need .         config.schemaVersion = vNew;
        __unsafe_unretained typeof(config) pConfig = config;
        config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
            /// Realm will automatic do the migration actions (including structure && data)
            t(pConfig , migration , oldSchemaVersion);
        };
        [RLMRealmConfiguration setDefaultConfiguration:config]; // change the default configuration , it will be effective on next access (for defaultRealm)
        
        /// migration will do actions on first access
        /// want it immediately , access the realm
        [RLMRealm defaultRealm];
        return pSelf;
    };
}

- (CCRealmHandler *(^)(RLMRealmConfiguration *(^)(), void (^)(RLMMigration *, uint64_t)))migrationT {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(RLMRealmConfiguration *(^m)() , void (^t)(RLMMigration *m , uint64_t vOld)) {
        if (!m || !t) return pSelf;
        void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_);
        RLMRealmConfiguration *config = m();
        config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
            t(migration , oldSchemaVersion);
        };
        [RLMRealmConfiguration setDefaultConfiguration:config];
        [RLMRealm defaultRealm];
        if (b) b(YES);
        return pSelf;
    };
}

- (CCRealmHandler *(^)(void (^)(NSError *)))error {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(void (^e)(NSError *)) {
        if (e) {
            objc_setAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_, e, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return pSelf;
    };;
}

- (CCRealmHandler *(^)(void (^)(RLMNotification, RLMRealm *)))notification {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(void (^t)(RLMNotification, RLMRealm *)) {
        if (t) {
            objc_setAssociatedObject(pSelf, _CC_RLM_NOTIFICATION_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return pSelf;
    };
}

- (CCRealmHandler *(^)(void (^)(BOOL)))succeed {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(void (^s)(BOOL b)) {
        if (s) {
            objc_setAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_, s, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return pSelf;
    };
}

#pragma mark - Private

- (CCRealmHandler *(^)(dispatch_block_t))defaultSettings {
    __weak typeof(self) pSelf = self;
    return ^CCRealmHandler *(dispatch_block_t block) {
        if (block) block();
        return pSelf;
    };
}

@end

#endif
