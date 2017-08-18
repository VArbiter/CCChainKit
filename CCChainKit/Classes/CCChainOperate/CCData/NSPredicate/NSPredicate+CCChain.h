//
//  NSPredicate+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (CCChain)

@property (nonatomic , class , copy , readonly) NSPredicate *(^common)(NSString *regex);
@property (nonatomic , class , copy , readonly) NSPredicate *(^time)(); // YYYY-MM-DD HH:mm:ss
@property (nonatomic , class , copy , readonly) NSPredicate *(^macAddress)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^webURL)();

// only in china
@property (nonatomic , class , copy , readonly) NSPredicate *(^cellphone)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^chinaMobile)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^chinaUnicom)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^chinaTelecom)();

@property (nonatomic , class , copy , readonly) NSPredicate *(^telephone)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^email)();

@property (nonatomic , class , copy , readonly) NSPredicate *(^chineseIdentityNumber)() ;
@property (nonatomic , class , copy , readonly) NSPredicate *(^chineseCarNumber)() ; //eg 湘K-DE829 , 粤Z-J499港
@property (nonatomic , class , copy , readonly) NSPredicate *(^chineseCharacter)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^chinesePostalCode)();
@property (nonatomic , class , copy , readonly) NSPredicate *(^chineseTaxNumber)();

@property (nonatomic , copy , readonly) id (^evaluate)(id object) ;

@end

#pragma mark - -----

@interface NSString (CCChain_Regex)

@property (nonatomic , class , copy , readonly) BOOL (^accurateVerifyID)(NSString * sID);

@property (nonatomic , readonly) NSString * isAccurateIdentity ;
@property (nonatomic , readonly) NSString * isTime ; // YYYY-MM-DD HH:mm:ss
@property (nonatomic , readonly) NSString * isMacAddress ;
@property (nonatomic , readonly) NSString * isWebURL ;
@property (nonatomic , readonly) NSString * isCellPhone ;
@property (nonatomic , readonly) NSString * isChinaMobile ;
@property (nonatomic , readonly) NSString * isChinaUnicom ;
@property (nonatomic , readonly) NSString * isChinaTelecom ;
@property (nonatomic , readonly) NSString * isTelephone ;
@property (nonatomic , readonly) NSString * isEmail ;
@property (nonatomic , readonly) NSString * isChineseIdentityNumber ;
@property (nonatomic , readonly) NSString * isChineseCarNumber ;
@property (nonatomic , readonly) NSString * isChineseCharacter ;
@property (nonatomic , readonly) NSString * isChinesePostalCode ;
@property (nonatomic , readonly) NSString * isChineseTaxNumber ;

@end
