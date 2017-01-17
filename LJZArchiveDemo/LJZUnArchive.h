//
//  LJZUnArchive.h
//  LJZArchiveDemo
//
//  Created by DBOX on 2017/1/16.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#define UNIQUE_KEY( x ) NSString * const x = @#x

enum{
    LJZFileTypeZIP,
    LJZFileTypeRAR
};
static UNIQUE_KEY( rar );
static UNIQUE_KEY( zip );

typedef void(^Completion)(NSArray *filePaths);
typedef void(^Failure)();

@interface LJZUnArchive : NSObject<SSZipArchiveDelegate>{
    SSZipArchive *_zipArchive;
    NSString *_fileType;
}
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *destinationPath;
@property (nonatomic, copy) Completion completionBlock;
@property (nonatomic, copy) Failure failureBlock;

- (id)initWithPath:(NSString *)path;
- (void)decompress;


@end
