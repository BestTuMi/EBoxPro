//
//  EBoxProEncrypt.h
//  EBoxPro
//
//  Created by yxj on 5/29/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBoxProEncrypt : NSObject

+ (NSDictionary *)encrypt:(NSData *)fileData forSuffixFile:(NSString *)fileSuffix;

+ (NSData *)decrypt:(NSData *)fileData withKey:(NSData *)keyContainer;

@end
