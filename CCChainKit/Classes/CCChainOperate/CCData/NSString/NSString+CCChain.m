//
//  NSString+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSString+CCChain.h"

#import "NSObject+CCChain.h"
#import "NSPredicate+CCChain.h"
#import "NSAttributedString+CCChain.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CCChain)

- (NSString *(^)(id))s {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [pSelf stringByAppendingString:(NSString *)value] : pSelf;
        }
        return [pSelf stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
    };
}

- (NSString *(^)(id))p {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [pSelf stringByAppendingPathComponent:(NSString *)value] : pSelf;
        }
        return [pSelf stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",value]];
    };
}

- (NSMutableAttributedString *(^)(UIColor *))colorAttribute {
    __weak typeof(self) pSelf = self;
    return ^NSMutableAttributedString *(UIColor *color) {
        return pSelf.toAttribute.color(color);
    };
}

+ (NSString *(^)(BOOL, BOOL, NSArray<NSString *> *))mergeC {
    return ^NSString *(BOOL isBreak , BOOL isSpace , NSArray <NSString *> * array){
        __block NSString *stringResult = @"";
        if (isBreak) {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj).isStringValued.s(@"\n");
            }];
        }
        else if (isSpace) {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj).isStringValued.s(@" ");
            }];
        }
        else {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj);
            }];
        }
        return stringResult;
    };
}

+ (NSString *(^)(BOOL, BOOL, NSString *, ...))mergeR {
    return ^NSString *(BOOL isBreak , BOOL isSpace , NSString * string , ...) {
        if (!string || !string.length) return nil;
        
        NSMutableArray < NSString * > * arrayStrings = [NSMutableArray array];
        NSString *stringTemp;
        va_list argumentList;
        if (string) {
            [arrayStrings addObject:string];
            va_start(argumentList, string);
            while ((stringTemp = va_arg(argumentList, id))) {
                [arrayStrings addObject:stringTemp];
            }
            va_end(argumentList);
        }
        return self.mergeC(isBreak, isSpace, arrayStrings);
    };
}

+ (NSString *(^)(NSString *, NSString *))localize {
    return ^NSString *(NSString *sKey , NSString *s) {
        return self.localizeB(sKey , NSBundle.mainBundle , nil);
    };
}

+ (NSString *(^)(NSString *, NSBundle *, NSString *))localizeB {
    return ^NSString *(NSString *sKey , NSBundle *bundle , NSString * s) {
        if (!bundle) bundle = NSBundle.mainBundle;
        return self.localizeS(sKey, @"Localizable", bundle, nil);
    };
}

+ (NSString *(^)(NSString *, NSString *, NSBundle *, NSString *))localizeS {
    return ^NSString *(NSString *sKey, NSString *sStrings, NSBundle *bundle, NSString *s) {
        if (!bundle) bundle = NSBundle.mainBundle;
        if (!sStrings) sStrings = @"Localizable";
        return NSLocalizedStringFromTableInBundle(sKey, sStrings, bundle, nil);
    };
}

- (NSInteger)toInteger {
    return self.integerValue;
}
- (long long)toLonglong {
    return self.longLongValue;
}
- (int)toInt {
    return self.intValue;
}
- (BOOL)toBool {
    return self.boolValue;
}
- (float)toFloat {
    return self.floatValue;
}
- (double)toDouble {
    return self.doubleValue;
}

- (NSDecimalNumber *)toDecimal {
    return [NSDecimalNumber decimalNumberWithString:self];
}
- (NSMutableAttributedString *)toAttribute {
    return [[NSMutableAttributedString alloc] initWithString:self.isStringValued];
}
- (NSDate *)toDate {
    NSString * string = NSPredicate.time().evaluate(self);
    if (!string.isStringValued) {
        return [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:string];
}

- (NSString *(^)(BOOL))timeStick {
    __weak typeof(self) pSelf = self;
    return ^NSString *(BOOL isNeedSpace) {
        if (isNeedSpace) {
            return pSelf.s(@" ").s(pSelf.timeStickP);
        }
        return pSelf.s(pSelf.timeStickP);
    };
}
- (NSString *)timeStickP {
    NSDate *date = self.toDate;
    if (!date) {
        return @"";
    }
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    long interval = (long) timeInterval;
    if (timeInterval / (60 * 60 * 24 * 30) >= 1 ) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:date];
    }
    else if (timeInterval / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60 * 24) , NSString.localize(@"_CC_DAYS_AGO_", @"天前")];
    }
    else if (timeInterval / (60 * 60) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60) , NSString.localize(@"_CC_HOURS_AGO_", @"小时前")];
    }
    else if (timeInterval / 60 >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / 60 , NSString.localize(@"_CC_MINUTES_AGO_", @"分钟前")];
    }
    else {
        return NSString.localize(@"_CC_AGO_", @"刚刚");
    }
}
- (NSString *)md5 {
    if (!self.length) return @"";
    const char *cStr = [self.isStringValued UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}

@end
