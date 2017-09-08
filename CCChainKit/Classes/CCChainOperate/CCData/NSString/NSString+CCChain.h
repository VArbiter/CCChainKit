//
//  NSString+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface NSString (CCChain)

@property (nonatomic , copy , readonly) NSString *(^s)(id value) ; // append string
@property (nonatomic , copy , readonly) NSString *(^p)(id value) ; // append path

/// break has the topest priority .
@property (nonatomic , class , copy , readonly) NSString *(^mergeC)(BOOL isBreak , BOOL isSpace , NSArray <NSString *> * array) ;
@property (nonatomic , class , copy , readonly) NSString *(^mergeR)(BOOL isBreak , BOOL isSpace , NSString * string , ...);

/// for localizedString
@property (nonatomic , class , copy , readonly) NSString *(^localize)(NSString *sKey , NSString *sComment);
@property (nonatomic , class , copy , readonly) NSString *(^localizeB)(NSString * sKey , NSBundle * bundle , NSString *sComment );
/// key , strings file , bundle , comment
@property (nonatomic , class , copy , readonly) NSString *(^localizeS)(NSString * sKey , NSString * sStrings , NSBundle * bundle , NSString *sComment );

@property (nonatomic , readonly) NSInteger toInteger ;
@property (nonatomic , readonly) long long toLonglong ;
@property (nonatomic , readonly) int toInt;
@property (nonatomic , readonly) BOOL toBool ;
@property (nonatomic , readonly) float toFloat ;
@property (nonatomic , readonly) double toDouble ;

@property (nonatomic , readonly) NSDecimalNumber * toDecimal; // only numbers .
@property (nonatomic , readonly) NSDate * toDate; // yyyy-MM-dd HH:mm

@property (nonatomic , copy , readonly) NSString *(^timeStick)(BOOL isNeedSpace) ;
@property (nonatomic , readonly) NSString *timeStickP ; // yyyy-MM-dd HH:mm
@property (nonatomic , readonly) NSString *md5 ;

@end
