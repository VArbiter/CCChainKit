//
//  NSObject+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCChain)

@property (nonatomic , copy , readonly) NSString * toString ;
@property (nonatomic , copy , readonly) NSString * getClass ;

@property (nonatomic , copy , readonly) NSString * isStringValued ;
@property (nonatomic , strong , readonly) NSArray * isArrayValued ;
@property (nonatomic , strong , readonly) NSDictionary * isDictionaryValued ;
@property (nonatomic , strong , readonly) NSDecimalNumber * isDecimalValued ;
@property (nonatomic , assign , readonly) BOOL isNull ;

+ (instancetype) CC_Non_NULL : (id) value
                             : (void(^)(id value)) setting;

id CC_NON_NULL(Class clazz , void (^setting)(id value));

@end

@interface NSObject (CCChainBridge)

@property (nonatomic , copy) id (^bridge)() ;

@end
