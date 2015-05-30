//
//  EBoxLocalFile.h
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBoxFile;

@interface EBoxLocalFile : NSObject

+ (EBoxLocalFile *)sharedInstance;

- (NSArray *)getLocalFilesPathList;

- (void)logoutAndDeleteFiles;
- (void)saveFile:(EBoxFile *)theFile;

@end
