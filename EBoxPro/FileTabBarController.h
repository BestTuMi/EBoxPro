//
//  FileTabBarController.h
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalFileViewController;
@class OnlineFileViewController;

@interface FileTabBarController : UITabBarController

@property(nonatomic,strong)LocalFileViewController  *localFileVC;
@property(nonatomic,strong)OnlineFileViewController *onlineFileVC;

- (void)uploadFile:(NSString *)theFileUrl;

@end
