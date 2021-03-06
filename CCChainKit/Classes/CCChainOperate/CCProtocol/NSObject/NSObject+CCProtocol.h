//
//  NSObject+CCProtocol.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCChainOperateProtocol < NSObject >

- (instancetype) cc ; // provide for macro (prevent crash)
+ (Class) cc; // provide for macro

/// make sure that when blocks is deploy ,
/// the object in blocks , was never can't be nil
/// use CC_TYPE(_type_ , sameObject) to start a chain action .
/// also , as a reslution for some blocks can be run as params .
- (instancetype) cc : (id (^)(id sameObject)) sameObject;

/// just make it a pare with 'end' ......
- (instancetype) begin ;
/// if you don't want a return value and can't ignore unused warning ,
/// and don't know how to silent a unused warning with clang ignore ,
/// use the property to make sure that returns nothing .
@property (nonatomic , copy , readonly) void (^endT)();

/// intialize a value that definitly can't be nil
+ (instancetype) CC_Non_NULL : (void(^)(id value)) setting;
/// c function type , same as + (instancetype)CC_Non_NULL:
id CC_NON_NULL(Class clazz , void (^setting)(id value));

@end

@interface NSObject (CCProtocol) < CCChainOperateProtocol >
@end

