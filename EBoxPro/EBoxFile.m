//
//  EBoxFile.m
//  EBoxPro
//
//  Created by yxj on 5/29/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxFile.h"

@implementation EBoxFile

- (EBoxFile *)initWithResultJson:(NSDictionary *)theResult
{
    self = [super init];
    
    [self updateWithResultJson:theResult];
    
    return self;
}

- (void)updateWithResultJson:(NSDictionary *)theResult
{
    _email          = theResult[@"email"]       ? :_email;
    _fileKey        = theResult[@"key"]         ? :_fileKey;
    _filePath       = theResult[@"filepath"]    ? :_filePath;
    _fileID         = theResult[@"fileid"]     ? :_fileID;
    
    _fileContent    = theResult[@"content"]     ? :_fileContent;
    
    _fileType = [[_filePath componentsSeparatedByString:@"."] lastObject];
}

- (NSDictionary *)fileInfoDict
{
    NSMutableDictionary * fileInfo = [[NSMutableDictionary alloc] init];
    
    [fileInfo setValue:_email forKey:@"email"];
    [fileInfo setValue:_fileKey forKey:@"key"];
    [fileInfo setValue:_filePath forKey:@"filepath"];
    [fileInfo setValue:_fileID forKey:@"fileid"];
    [fileInfo setValue:_fileContent forKey:@"content"];
    
    return fileInfo;
}

@end
