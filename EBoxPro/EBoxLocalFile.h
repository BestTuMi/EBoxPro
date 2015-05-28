//
//  EBoxLocalFile.h
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBoxLocalFile : NSObject

+ (EBoxLocalFile *)sharedInstance;

- (void)logoutAndDeleteFiles;

@end
