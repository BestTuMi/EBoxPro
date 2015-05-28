//
//  FileTabBarController.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "FileTabBarController.h"
#import "LocalFileViewController.h"
#import "OnlineFileViewController.h"
#import "EBoxNetwork.h"
#import <SVProgressHUD.h>

@interface FileTabBarController ()

@end

@implementation FileTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = [NSArray arrayWithObjects:self.onlineFileVC, self.localFileVC, nil];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (OnlineFileViewController *)onlineFileVC{
    if (!_onlineFileVC) {
        _onlineFileVC = [[OnlineFileViewController alloc] init];
        _onlineFileVC.tabBarItem.title = @"Online Files";
//        _onlineFileVC.tabBarItem.image =
        
    }
    return _onlineFileVC;
}

- (LocalFileViewController *)localFileVC{
    if (!_localFileVC) {
        _localFileVC = [[LocalFileViewController alloc] init];
        _localFileVC.tabBarItem.title = @"Local Files";
//        _localFileVC.tabBarItem.image =
        
    }
    return _localFileVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
