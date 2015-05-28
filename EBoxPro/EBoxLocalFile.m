//
//  EBoxLocalFile.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxLocalFile.h"

@implementation EBoxLocalFile

+ (EBoxLocalFile *)sharedInstance{
    static EBoxLocalFile *sharedLocalFile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedLocalFile = [[EBoxLocalFile alloc] init];
    });
    return sharedLocalFile;
}

- (void)logoutAndDeleteFiles{
    //TODO: delete need improved
    
    return;
}

@end
