//
//  EBoxNetwork.m
//  EBoxPro
//
//  Created by yxj on 5/24/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxNetwork.h"

@interface EBoxNetwork()

@property (nonatomic,copy)NSString *session;
@property (nonatomic,copy)NSString *userName;
@end

@implementation EBoxNetwork

+ (EBoxNetwork *)sharedInstance{
    static EBoxNetwork *sharedNetwork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[EBoxNetwork alloc] init];
    });
    
    return sharedNetwork;
}

- (BOOL)isStayOnline{
    if (self.session.length && self.userName.length) {
        return YES;
    }
    return NO;
}
@end
