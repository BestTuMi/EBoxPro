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

@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,assign)BOOL isRegister;
@property (nonatomic,assign)BOOL isGetList;
@property (nonatomic,assign)BOOL isUploadFile;
@property (nonatomic,assign)BOOL isDownloading;
@end

@implementation EBoxNetwork

- (instancetype)init{
    self = [super init];
    if(self){
        self.isLogin = NO;
        self.isRegister = NO;
        self.isGetList = NO;
        self.isUploadFile = NO;
        self.isDownloading = NO;
        
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.session = [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
    }
    return self;
}

- (void)login{
    if (self.session.length && self.userName.length) {
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.session forKey:@"session"];
    }
}

- (void)logout{
    self.userName = nil;
    self.session = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
}

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

- (NSString *)loginUserName{
    return self.userName;
}

- (void)loginWithUserName:(NSString *)theUserName password:(NSString *)thePassword completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    if (self.isLogin) {
        return;
    }
    
    self.isLogin = YES;
    NSDictionary *postDict = @{@"cmd":@"login",
                               @"email":theUserName ? :@"",
                               @"password":thePassword ? :@""};
    __weak EBoxNetwork *weakSelf = self;
    
    [self sendPostRequestWithBody:postDict postUrl:USER_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson){
        weakSelf.userName = (responseJson[@"result"])[@"email"];
        weakSelf.session = (responseJson[@"result"])[@"session"];
        [weakSelf login];
        
        weakSelf.isLogin = NO;
        successBlock(responseJson);
    }completeFailed:^(NSString *failedStr){
        weakSelf.isLogin = NO;
        failedBlock(failedStr);
    }];
}

- (void)registerWithUserName:(NSString *)theUserName password:(NSString *)thePassword completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    if(self.isRegister){
        return;
    }
    
    self.isRegister = YES;
    
    NSDictionary *postDict = @{@"cmd"     :@"signup",
                               @"email"   :theUserName ? :@"",
                               @"password":thePassword ? :@""};
    __weak EBoxNetwork *weakSelf = self;
    [self sendPostRequestWithBody:postDict postUrl:USER_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        weakSelf.userName = (responseJson[@"result"])[@"email"];
        weakSelf.session = (responseJson[@"result"])[@"session"];
        
        [weakSelf login];
        
        weakSelf.isRegister = NO;
        successBlock(responseJson);
    } completeFailed:^(NSString *failedStr) {
        weakSelf.isRegister = NO;
        failedBlock(failedStr);
    }];
}

- (void)sendPostRequestWithBody:(NSDictionary *)theBodyDict postUrl:(NSString *)postUrl completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:theBodyDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSURL *url = [NSURL URLWithString:postUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"response: %@", response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] < 300) {
            NSError *error = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"response Json: %@",jsonObject);
            NSInteger msg_id = [jsonObject[@"msg_id"] integerValue];
            if(msg_id == 0){
                successBlock(jsonObject);
            }
            else{
                failedBlock(jsonObject[@"msg"]);
            }
        }else{
            failedBlock(@"Network Error");
        }
    }];
}
@end
