//
//  EBoxNetwork.h
//  EBoxPro
//
//  Created by yxj on 5/24/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBoxNetwork : NSObject

+ (EBoxNetwork *)sharedInstance;

- (BOOL)isStayOnline;

@end
