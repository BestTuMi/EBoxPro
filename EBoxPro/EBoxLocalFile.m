//
//  EBoxLocalFile.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxLocalFile.h"
#import "EBoxFile.h"

@implementation EBoxLocalFile

+ (EBoxLocalFile *)sharedInstance{
    static EBoxLocalFile *sharedLocalFile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedLocalFile = [[EBoxLocalFile alloc] init];
    });
    return sharedLocalFile;
}

- (NSArray *)getLocalFilesPathList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filePaths = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[self localFilePathWithName:@""] error:nil]];
    return filePaths;
}

- (NSString *)localFilePathWithName:(NSString *)theFileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    if (theFileName.length == 0) {
        NSMutableString *savedPath = [documentsDirectory mutableCopy];
        [savedPath appendString:@"/"];
        return savedPath;
    }
    
    if ([theFileName characterAtIndex:0] == '/') {
        NSMutableString *mutableFileName = [theFileName mutableCopy];
        [mutableFileName deleteCharactersInRange:NSMakeRange(0, 1)];
        theFileName = [[NSString alloc] initWithString:mutableFileName];
    }
    
    NSString *savedPath = [documentsDirectory stringByAppendingPathComponent:theFileName];
    return savedPath;
}

- (EBoxFile *)localFileWithFileName:(NSString *)theFileName{
    NSString *filePath = [self localFilePathWithName:theFileName];
    NSData *fileContent = [NSData dataWithContentsOfFile:filePath];
    if (filePath && fileContent) {
        NSDictionary *theDict = @{@"filepath":filePath, @"content":fileContent};
        EBoxFile *theFile = [[EBoxFile alloc] initWithResultJson:theDict];
        return theFile;
    }
    return nil;
}

- (void)saveFile:(EBoxFile *)theFile{
    NSData *fileContent = theFile.fileContent;
    [fileContent writeToFile:[self localFilePathWithName:theFile.filePath] atomically:YES];
}

- (void)logoutAndDeleteFiles{
    //TODO: delete need improved
    
    return;
}

- (BOOL)isLocalFileExistWithFileName:(NSString *)theFileName{
    if ([theFileName characterAtIndex:0] == '/') {
        NSMutableString *mutableFileName = [theFileName mutableCopy];
        [mutableFileName deleteCharactersInRange:NSMakeRange(0, 1)];
        theFileName = [[NSString alloc] initWithString:mutableFileName];
    }
    
    NSArray *fileList = [self getLocalFilesPathList];
    for (NSString *filePath in fileList) {
        if ([filePath isEqualToString:theFileName]) {
            return YES;
        }
    }
    return NO;
}

@end
