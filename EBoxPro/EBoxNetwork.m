//
//  EBoxNetwork.m
//  EBoxPro
//
//  Created by yxj on 5/24/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "EBoxNetwork.h"
#import "EBoxProEncrypt.h"

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

- (void)uploadFileWithName:(NSString *)theName contentData:(NSData *)theContentData completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    if (self.isUploadFile) {
        return;
    }
    self.isUploadFile = YES;
    
    __block NSString *filePath = [NSString stringWithFormat:@"/%@",theName];
    NSString *fileLength = [NSString stringWithFormat:@"%lu", (unsigned long)[theContentData length]];
    
    NSDictionary *postDict = @{@"cmd":@"upload_file",
                               @"email":self.userName ? :@"",
                               @"session":self.session ? :@"",
                               @"filepath":filePath ? :@"",
                               @"filemd5":theName ? :@"",
                               @"filesize":fileLength ?:@""};
    
    __weak EBoxNetwork *weakSelf = self;
    [self sendPostRequestWithBody:postDict postUrl:FILE_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        NSString *fileID = ((NSDictionary *)responseJson[@"result"])[@"fileid"];
        NSDictionary *afterEncryptDict = [EBoxProEncrypt encrypt:theContentData forSuffixFile:[[theName componentsSeparatedByString:@"."] lastObject]];
        NSData *keyData = afterEncryptDict[@"keyData"];
        NSData *afterEncryptFileData = afterEncryptDict[@"afterEncryptFileData"];
        [weakSelf uploadKeyWithFileID:fileID key:keyData completeSuccessed:^(NSDictionary *responseJson) {
            
            [weakSelf uploadFileContentWithFileID:fileID contentData:afterEncryptFileData completeSuccessed:^(NSDictionary *responseJson) {
                successBlock(responseJson);
                weakSelf.isUploadFile = NO;
            } completeFailed:^(NSString *failedStr) {
                failedBlock(failedStr);
                weakSelf.isUploadFile = NO;
            }];
        } completeFailed:^(NSString *failedStr) {
            failedBlock(failedStr);
            weakSelf.isUploadFile = NO;
        }];
    } completeFailed:^(NSString *failedStr) {
        failedBlock(failedStr);
        weakSelf.isUploadFile = NO;
    }];
}

- (void)uploadFileContentWithFileID:(NSString *)theFileID contentData:(NSData *)theContentData completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
//    NSString *keyString = [keyContainer base64EncodedStringWithOptions:0];
//    NSData *keyContainer = [[NSData alloc] initWithBase64EncodedString:keyString options:0];
    NSString *base64File = [theContentData base64EncodedStringWithOptions:0];
    NSDictionary * postDict = @{@"cmd"          :@"upload_file_data",
                                @"fileid"       :theFileID ? :@"",
                                @"offset"       :@"0",
                                @"data"         :base64File ? :@""};
    
    [self sendPostRequestWithBody:postDict postUrl:FILE_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        successBlock(responseJson);
    } completeFailed:^(NSString *failedStr) {
        failedBlock(failedStr);
    }];
}

- (void)uploadKeyWithFileID:(NSString *)theFileID key:(NSData *)theKeyData completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    NSString *base64Key = [theKeyData base64EncodedStringWithOptions:0];
    NSDictionary * postDict = @{@"cmd"          :@"save_file_key",
                                @"email"        :self.userName ? :@"",
                                @"session"      :self.session ? :@"",
                                @"fileid"       :theFileID ? :@"",
                                @"key"          :base64Key ? :@"",
                                @"encrypt_type" :@"extract"};
    [self sendPostRequestWithBody:postDict postUrl:KEY_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        successBlock(responseJson);
    } completeFailed:^(NSString *failedStr) {
        failedBlock(failedStr);
    }];
}

- (void)getFileListWithCompleteSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    if (self.isGetList) {
        return;
    }
    self.isGetList = YES;
    NSDictionary * postDict = @{@"cmd"          :@"get_file_list",
                                @"email"        :self.userName ? :@"",
                                @"session"      :self.session ? :@"",
                                @"filepath"     :@"/",
                                @"is_recursive" :@"1"};
    
    __weak EBoxNetwork *weakSelf = self;
    [self sendPostRequestWithBody:postDict postUrl:FILE_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        weakSelf.isGetList = NO;
        successBlock(responseJson);
    } completeFailed:^(NSString *failedStr) {
        weakSelf.isGetList = NO;
        failedBlock(failedStr);
    }];
}

- (void)downloadFileWithFileID:(NSString *)theFileID completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    if (self.isDownloading) {
        return;
    }
    self.isDownloading = YES;
    
    NSDictionary * postDict = @{@"cmd"          :@"download_file",
                                @"fileid"       :theFileID ? :@"",
                                @"email"        :self.userName ? :@"",
                                @"session"      :self.session ? :@""};
    
    __weak EBoxNetwork *weakSelf = self;
    [self sendPostRequestWithBody:postDict postUrl:FILE_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        
        __block NSMutableDictionary *fileResponseJson = [responseJson[@"result"] mutableCopy];
        NSData *contentData = [[NSData alloc] initWithBase64EncodedString:fileResponseJson[@"content"] options:0];
        [fileResponseJson setValue:contentData forKey:@"content"];
        [weakSelf downloadKeyWithFileID:theFileID completeSuccessed:^(NSDictionary *responseJson) {
            NSDictionary *resultJson = responseJson[@"result"];
            [fileResponseJson setValue:resultJson[@"key"] forKey:@"key"];
            [fileResponseJson setValue:resultJson[@"encrypt_type"] forKey:@"encrypt_type"];
            successBlock(fileResponseJson);
            weakSelf.isDownloading = NO;
        } completeFailed:^(NSString *failedStr) {
            failedBlock(failedStr);
            weakSelf.isDownloading = NO;
        }];
        
    } completeFailed:^(NSString *failedStr) {
        failedBlock(failedStr);
        weakSelf.isDownloading = NO;
    }];
}

- (void)downloadKeyWithFileID:(NSString *)theFileID completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    NSDictionary * postDict = @{@"cmd"          :@"get_file_key",
                                @"email"        :self.userName ? :@"",
                                @"session"      :self.session ? :@"",
                                @"fileid"       :theFileID ? :@"",
                                @"encrypt_type" :@"extract"};
    [self sendPostRequestWithBody:postDict postUrl:KEY_SERVER_ADDRESS completeSuccessed:^(NSDictionary *responseJson) {
        successBlock(responseJson);
    } completeFailed:^(NSString *failedStr) {
        failedBlock(failedStr);
    }];
}
@end
