//
//  NSFileManager+CCChain.m
//  CCChainKit
//
//  Created by Elwinfrederick on 05/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSFileManager+CCChain.h"

#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSInteger const _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_ = 1024 * 8;

@implementation NSFileManager (CCChain)

+ (NSString *)sHomeDirectory {
    return NSHomeDirectory();
}
+ (NSString *)sTempDirectory {
    return NSTemporaryDirectory();
}
+ (NSString *)sCacheDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES).firstObject;
}
+ (NSString *)sLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES).firstObject;
}

- (BOOL (^)(NSString *))isDirectoryT {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *s) {
        if (!s || !s.length) return false;
        BOOL isDir = false;
        [pSelf fileExistsAtPath:s
                    isDirectory:&isDir];
        return isDir;
    };
}
- (BOOL (^)(NSString *))existsT {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *s) {
        if (!s || !s.length) return false;
        if (pSelf.isDirectoryT(s)) return false;
        return [pSelf fileExistsAtPath:s];
    };
}
- (BOOL (^)(NSString *))removeT {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *s) {
        if (!s || !s.length) return YES;
        NSError *e;
        BOOL b = [pSelf removeItemAtPath:s
                                   error:&e];
        return e ? false : b;
    };
}
- (BOOL (^)(NSString *))createFolderT {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *s) {
        if (!s || !s.length) return false;
        if (pSelf.isDirectoryT(s)) return YES;
        NSError *e = nil;
        BOOL b = [pSelf createDirectoryAtPath:s
                  withIntermediateDirectories:YES // whether if create middle path
                                   attributes:nil
                                        error:&e];
        return e ? false : b;
    };
}
- (BOOL (^)(NSString *, NSString *))moveT {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *sFrom , NSString *sTo) {
        if (!sFrom || !sFrom.length
            || !sTo || sTo.length) return false;
        if (pSelf.isDirectoryT(sFrom)) return false;
        if (!pSelf.isDirectoryT(sTo)) return false;
        if (!pSelf.existsT(sFrom)) return false;
        NSError *e ;
        BOOL b = [pSelf moveItemAtPath:sFrom
                                toPath:sTo
                                 error:&e];
        return e ? false : b;
    };
}
- (unsigned long long (^)(NSString *))fileSizeT {
    __weak typeof(self) pSelf = self;
    return ^unsigned long long (NSString *s) {
        if (!s || !s.length) return 0;
        if (pSelf.isDirectoryT(s)) return 0;
        if (!pSelf.existsT(s)) return 0;
        NSError *e ;
        NSDictionary *dictionaryInfo = [pSelf attributesOfItemAtPath:s
                                                               error:&e];
        return e ? 0 : [dictionaryInfo[NSFileSize] longLongValue];
    };
}
- (unsigned long long (^)(NSString *))folderSizeT {
    __weak typeof(self) pSelf = self;
    return ^unsigned long long (NSString *s) {
        if (!s || !s.length) return 0;
        if (!pSelf.isDirectoryT(s)) return pSelf.fileSizeT(s);
        NSEnumerator * enumeratorFiles = [[pSelf subpathsAtPath:s] objectEnumerator];
        NSString * sFileName = nil;
        unsigned long long folderSize = 0;
        while ((sFileName = [enumeratorFiles nextObject]) != nil) {
            folderSize += pSelf.fileSizeT([s stringByAppendingPathComponent:sFileName]);
        }
        return folderSize;
    };
}

- (NSString *(^)(NSString *))MD5Auto {
    __weak typeof(self) pSelf = self;
    return ^NSString *(NSString *s) {
        if (!s || !s.length) return @"";
        if (pSelf.isDirectoryT(s)) return @"";
        if (!pSelf.existsT(s)) return @"";
        
        if (pSelf.fileSizeT(s) >= 10 * pow(10, 6)) { // file limit 10 MB
            return pSelf.MD5Large(s) ;
        }
        return pSelf.MD5Normal(s);
    };
}
- (NSString *(^)(NSString *))MD5Normal {
    __weak typeof(self) pSelf = self;
    return ^NSString *(NSString *s) {
        if (!s || !s.length) return @"";
        if (pSelf.isDirectoryT(s)) return @"";
        if (!pSelf.existsT(s)) return @"";
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:s];
        if(!handle) return nil;
        
        CC_MD5_CTX md5;
        CC_MD5_Init(&md5);
        BOOL done = NO;
        while(!done)
        {
            NSData * dataFile = [handle readDataOfLength: 256 ];
            CC_MD5_Update(&md5, dataFile.bytes, (CC_LONG)dataFile.length);
            if( dataFile.length == 0 ) done = YES;
        }
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &md5);
        NSMutableString *string = @"".mutableCopy;
        for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [string appendString:[NSString stringWithFormat:@"%02x",digest[i]]];
        }
        return string;
    };
}
- (NSString *(^)(NSString *))MD5Large {
    __weak typeof(self) pSelf = self;
    return ^NSString *(NSString *s) {
        if (!s || !s.length) return @"";
        if (pSelf.isDirectoryT(s)) return @"";
        if (!pSelf.existsT(s)) return @"";
        NSString *(^t)(CFStringRef stringRefPath , size_t sizeChunk) = ^NSString *(CFStringRef stringRefPath , size_t sizeChunk) {
            // Declare needed variables
            CFStringRef result = NULL;
            CFReadStreamRef readStream = NULL;
            // Get the file URL
            CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                             (CFStringRef)stringRefPath,
                                                             kCFURLPOSIXPathStyle,
                                                             (Boolean)false);
            if (!fileURL) goto done;
            // Create and open the read stream
            readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                    (CFURLRef)fileURL);
            if (!readStream) goto done;
            bool didSucceed = (bool)CFReadStreamOpen(readStream);
            if (!didSucceed) goto done;
            // Initialize the hash object
            CC_MD5_CTX hashObject;
            CC_MD5_Init(&hashObject);
            // Make sure chunkSizeForReadingData is valid
            if (!sizeChunk) {
                sizeChunk = _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_;
            }
            // Feed the data to the hash object
            bool hasMoreData = true;
            while (hasMoreData) {
                uint8_t buffer[sizeChunk];
                CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
                if (readBytesCount == -1) break;
                if (readBytesCount == 0) {
                    hasMoreData = false;
                    continue;
                }
                CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
            }
            // Check if the read operation succeeded
            didSucceed = !hasMoreData;
            // Compute the hash digest
            unsigned char digest[CC_MD5_DIGEST_LENGTH];
            CC_MD5_Final(digest, &hashObject);
            // Abort if the read operation failed
            if (!didSucceed) goto done;
            // Compute the string result
            char hash[2 * sizeof(digest) + 1];
            for (size_t i = 0; i < sizeof(digest); ++i) {
                snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
            }
            result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
            
        done:
            if (readStream) {
                CFReadStreamClose(readStream);
                CFRelease(readStream);
            }
            if (fileURL) CFRelease(fileURL);
            return (__bridge_transfer NSString *) result;
        };
        return t ? t(((__bridge CFStringRef)s) , _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_) : @"";
    };
}
- (NSString *(^)(NSString *))mimeType {
    __weak typeof(self) pSelf = self;
    return ^NSString *(NSString *s) {
        if (!s || !s.length) return @"";
        if (pSelf.isDirectoryT(s)) return @"";
        if (!pSelf.existsT(s)) return @"";
        NSString *sExtension = s.pathExtension;
        CFStringRef sContentRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                        (__bridge CFStringRef)(sExtension),
                                                                        NULL);
        return CFBridgingRelease(sContentRef); // hanled to arc
    };
}


@end

#pragma mark - -----

@implementation NSString (CCChain_File_Extension)

- (BOOL)isDirectoryT {
    return NSFileManager.defaultManager.isDirectoryT(self);
}
- (BOOL)isExistsT {
    return NSFileManager.defaultManager.existsT(self);
}
- (BOOL)removeT {
    return NSFileManager.defaultManager.removeT(self);
}
- (BOOL)createFolderT {
    return NSFileManager.defaultManager.createFolderT(self);
}

- (unsigned long long)fileSizeT {
    return NSFileManager.defaultManager.fileSizeT(self);
}

- (BOOL (^)(NSString *))moveTo {
    __weak typeof(self) pSelf = self;
    return ^BOOL (NSString *sPath) {
        return NSFileManager.defaultManager.moveT(pSelf, sPath);
    };
}

- (NSString *)mimeType {
    return NSFileManager.defaultManager.mimeType(self);
}
- (NSString *)fileAutoMD5 {
    return NSFileManager.defaultManager.MD5Auto(self);
}
- (NSString *)fileMD5 {
    return NSFileManager.defaultManager.MD5Normal(self);
}
- (NSString *)largeFileMD5 {
    return NSFileManager.defaultManager.MD5Large(self);
}

@end
