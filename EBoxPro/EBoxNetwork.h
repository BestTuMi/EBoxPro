//
//  EBoxNetwork.h
//  EBoxPro
//
//  Created by yxj on 5/24/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USER_SERVER_ADDRESS @"http://0.0.0.0:8881"
#define KEY_SERVER_ADDRESS @"http://0.0.0.0:8882"
#define FILE_SERVER_ADDRESS @"http://0.0.0.0:8883"

typedef void(^requestSuccessed)(NSDictionary *responseJson);//定义了一个requestSuccessed类型的代码块，返回值void，接受一个NSDictionary*类型的参数
typedef void(^requestFailed)(NSString *failedStr);

@interface EBoxNetwork : NSObject

+ (EBoxNetwork *)sharedInstance;

- (BOOL)isStayOnline;
- (NSString *)loginUserName;
- (void)logout;

- (void)loginWithUserName:(NSString *)theUserName
                password:(NSString *)thePassword
        completeSuccessed:(requestSuccessed)successBlock
           completeFailed:(requestFailed)failedBlock;

- (void)registerWithUserName:(NSString *)theUserName
                    password:(NSString *)thePassword
           completeSuccessed:(requestSuccessed)successBlock
              completeFailed:(requestFailed)failedBlock;

- (void)uploadFileWithName:(NSString *)theName
               contentData:(NSData *)theContentData
         completeSuccessed:(requestSuccessed)successBlock
            completeFailed:(requestFailed)failedBlock;

- (void)getFileListWithCompleteSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock;

@end
