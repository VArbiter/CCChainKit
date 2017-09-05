//
//  NSFileManager+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSInteger const _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_;

@interface NSFileManager (CCChain)

@property (nonatomic , class , readonly) NSString *sHomeDirectory;
@property (nonatomic , class , readonly) NSString *sTempDirectory;
@property (nonatomic , class , readonly) NSString *sCacheDirectory;
@property (nonatomic , class , readonly) NSString *sLibraryDirectory;

@property (nonatomic , copy , readonly) BOOL (^isDirectoryT)(NSString *sPath);
@property (nonatomic , copy , readonly) BOOL (^existsT)(NSString *sPath);
@property (nonatomic , copy , readonly) BOOL (^removeT)(NSString *sPath);
/// create if not exists .
@property (nonatomic , copy , readonly) BOOL (^createFolderT)(NSString *sPath);
@property (nonatomic , copy , readonly) BOOL (^moveT)(NSString *sFrom , NSString *sTo);

/// note : in iOS , 1G == 1000Mb == 1000 * 1000kb == 1000 * 1000 * 1000b
/// note : in iOS (for bytes) , 1G = pow(10, 9) , 1Mb = pow(10, 6) , 1Kb = pow(10, 3)
/// note : highly recommend put it in a sub thread . (if sPath point at a directory)
@property (nonatomic , copy , readonly) unsigned long long (^fileSizeT)(NSString *sPath);

/// note : if self is a folder or not valued path at all , returns @"" 
@property (nonatomic , copy , readonly) NSString *(^MD5Auto)(NSString *sPath);
@property (nonatomic , copy , readonly) NSString *(^MD5Normal)(NSString *sPath);
@property (nonatomic , copy , readonly) NSString *(^MD5Large)(NSString *sPath);
@property (nonatomic , copy , readonly) NSString *(^mimeType)(NSString *sPath);

@end

#pragma mark - -----

@interface NSString (CCChain_File_Extension)

@property (nonatomic , readonly) BOOL isDirectoryT ;
@property (nonatomic , readonly) BOOL isExistsT ;
@property (nonatomic , readonly) BOOL removeT ;
@property (nonatomic , readonly) BOOL createFolderT ;

/// note : highly recommend put it in a sub thread . (if self point at a directory)
@property (nonatomic , readonly) unsigned long long fileSizeT ;

@property (nonatomic , copy , readonly) BOOL (^moveTo)(NSString *sDestination);

/// note : if self is a folder or not valued path at all , returns @"" rather than it self .
@property (nonatomic , readonly) NSString *mimeType ;
@property (nonatomic , readonly) NSString *fileAutoMD5 ;
@property (nonatomic , readonly) NSString *fileMD5 ;
@property (nonatomic , readonly) NSString *largeFileMD5 ;

@end
