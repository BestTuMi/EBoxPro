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

- (NSString *)localFilePathWithName:(NSString *)theFileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
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

- (void)saveFile:(EBoxFile *)theFile{
    NSData *fileContent = theFile.fileContent;
    [fileContent writeToFile:[self localFilePathWithName:theFile.filePath] atomically:YES];
}

- (void)logoutAndDeleteFiles{
    //TODO: delete need improved
    
    return;
}

@end
