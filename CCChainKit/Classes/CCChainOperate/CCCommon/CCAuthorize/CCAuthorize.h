//
//  CCAuthorize.h
//  CCChainKit
//
//  Created by Elwinfrederick on 18/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCSupportType) {
    CCSupportTypeNone = 0, // all access denied
    CCSupportTypeAll , // all
    CCSupportTypePhotoLibrary , // photos library
    CCSupportTypeVideo ,
    CCSupportTypeAudio
};

@interface CCAuthorize : NSObject

@property (nonatomic , class , readonly) CCAuthorize *shared;
/// has authorize to sepecific settings .
/// return value for fail , decide whether if need to guide to setting pages .
@property (nonatomic , copy , readonly) CCAuthorize *(^hasAuthorize)(CCSupportType type, void (^success)() , BOOL (^fail)());

@end
