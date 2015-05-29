//
//  EBoxFile.h
//  EBoxPro
//
//  Created by yxj on 5/29/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBoxFile : NSObject

@property (nonatomic, readonly) NSString * email;
@property (nonatomic, readonly) NSString * fileKey;
@property (nonatomic, readonly) NSString * filePath;
@property (nonatomic, readonly) NSString * fileID;
@property (nonatomic, readonly) NSString * fileType;
@property (nonatomic, readonly) NSData * fileContent;
@property (nonatomic, strong) NSDictionary * fileInfoDict;

- (EBoxFile *)initWithResultJson:(NSDictionary *)theResult;

- (void)updateWithResultJson:(NSDictionary *)theResult;

@end
