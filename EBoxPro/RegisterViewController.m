//
//  RegisterViewController.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "RegisterViewController.h"
#import <SVProgressHUD.h>
#import "EBoxNetwork.h"
#import "FileTabBarController.h"

@interface RegisterViewController ()

@property (nonatomic,strong)UILabel *mainTitleLabel;
@property (nonatomic,strong)UITextField *userNameTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,strong)UIButton *registerButton;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA_COLOR(0, 175, 145, 1);
    
    self.mainTitleLabel = [[UILabel alloc] init];
    self.mainTitleLabel.size = CGSizeMake(200, 50);
    self.mainTitleLabel.center = CGPointMake(self.view.center.x, 100);
    self.mainTitleLabel.text = @"Register";
    self.mainTitleLabel.textColor = [UIColor whiteColor];
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mainTitleLabel];
    
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.size = CGSizeMake(250, 30);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 150);
    self.userNameTextField.placeholder = @"Username";
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor blackColor];
    self.userNameTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.userNameTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.size = CGSizeMake(250, 30);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 200);
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.layer.cornerRadius = 3;
    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.size = CGSizeMake(100, 50);
    self.registerButton.center = CGPointMake(self.view.center.x, 250);
    [self.registerButton setTitle:@"Register Now!" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void)registerClicked:(UIButton *)sender{
    if ([[self.userNameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""]) {
        alert(@"Please enter email and password!");
        return;
    }else{
        [self sendRegisterRequest];
    }
}

- (void)sendRegisterRequest{
    [SVProgressHUD showWithStatus:@"Registering"];
    
    __weak RegisterViewController *weakSelf = self;
    [[EBoxNetwork sharedInstance] registerWithUserName:self.userNameTextField.text password:self.passwordTextField.text completeSuccessed:^(NSDictionary *responseJson) {
        [weakSelf performSelectorOnMainThread:@selector(registerSuccess) withObject:nil waitUntilDone:NO];
    } completeFailed:^(NSString *failedStr) {
        [weakSelf performSelectorOnMainThread:@selector(registerFailed:) withObject:nil waitUntilDone:NO];
    }];
}

- (void)registerSuccess{
    [SVProgressHUD showSuccessWithStatus:@"Register Successed"];
    
    FileTabBarController *fileVC = [[FileTabBarController alloc] init];
    fileVC.title = self.userNameTextField.text;
    [self.navigationController pushViewController:fileVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)registerFailed:(NSString *)failedStr{
    [SVProgressHUD showErrorWithStatus:failedStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
