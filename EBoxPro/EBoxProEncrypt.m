//
//  EBoxProEncrypt.m
//  EBoxPro
//
//  Created by yxj on 5/29/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxProEncrypt.h"

@implementation EBoxProEncrypt


+ (NSDictionary *)encrypt:(NSData *)fileData forSuffixFile:(NSString *)fileSuffix{
    
    NSMutableData *afterFile = [[NSMutableData alloc] init];
    [afterFile appendData:fileData];
    
    NSMutableData *keyContainer = [[NSMutableData alloc] init];
    
    int PERCENTAGE = 1;
    int ex_location = 0;
    int ex_length = 0;
    ex_length = PERCENTAGE;
    
    int fileHeaderLength = 0;
    int fileTailLength = 0;
    int locationStepLength = 0;
    int fillBackByte = 1;
    NSArray *JPEGS =  @[@"jfi", @"jif", @"jfif", @"jpe", @"jpeg", @"jpg",@"JPG",@"JPEG"];
    NSArray *TEXT = @[@"txt", @"c", @"h", @"cpp", @"java", @"py", @"m"];
    if([JPEGS containsObject:fileSuffix]){
        fileHeaderLength = 16;
        locationStepLength = 250;
        fileTailLength = 2;
    }
    else if([TEXT containsObject:fileSuffix]){
        fileHeaderLength = 0;
        locationStepLength = 100;
        fileTailLength = 0;
    }else{
        locationStepLength = 300;
    }
    
    for(ex_location += fileHeaderLength; ex_location+ex_length < fileData.length-fileTailLength; ex_location += locationStepLength){
        [keyContainer appendData:[NSData dataWithBytes:&ex_location length:sizeof(ex_location)]];
        [keyContainer appendData:[NSData dataWithBytes:&ex_length length:sizeof(ex_length)]];
        [keyContainer appendData:[fileData subdataWithRange:NSMakeRange(ex_location, ex_length)]];
        fillBackByte = arc4random() % 256;
        [afterFile replaceBytesInRange:NSMakeRange(ex_location, ex_length) withBytes:&fillBackByte];
        
    }
    
    NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
    [myDict setValue:afterFile forKey:@"afterEncryptFileData"];
    [myDict setValue:keyContainer forKey:@"keyData"];
    return myDict;
}

+ (NSData *)decrypt:(NSData *)fileData withKey:(NSData *)keyContainer{
    
    NSMutableData *afterFile = [[NSMutableData alloc] init];
    [afterFile appendData:fileData];
    
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    for(int i=0;i<keyContainer.length;){
        int offset = 0;
        int snippetLen = 0;
        NSData *snippetContent = [[NSData alloc] init];
        NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
        
        offset = *(int*)[[keyContainer subdataWithRange:NSMakeRange(i, 4)] bytes];
        i+=4;
        snippetLen = *(int*)[[keyContainer subdataWithRange:NSMakeRange(i, 4)] bytes];
        i+=4;
        snippetContent = [keyContainer subdataWithRange:NSMakeRange(i, snippetLen)];
        i+=snippetLen;
        
        [myDict setValue:[[NSString alloc] initWithFormat:@"%d",offset] forKey:@"offset"];
        [myDict setValue:snippetContent forKey:@"snippetContent"];
        
        [myArray addObject:myDict];
    }
    
    for (NSDictionary *myDict in myArray) {
        int ex_loc = [[myDict valueForKey:@"offset"] intValue];
        NSMutableData *ex_data = [myDict valueForKey:@"snippetContent"];
        [afterFile replaceBytesInRange:NSMakeRange(ex_loc, ex_data.length) withBytes:[ex_data bytes] length:ex_data.length];
    }
    
    
    return afterFile;
}

@end
