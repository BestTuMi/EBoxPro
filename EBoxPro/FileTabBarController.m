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
#import "EBoxLocalFile.h"

@interface FileTabBarController () <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation FileTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = [NSArray arrayWithObjects:self.onlineFileVC, self.localFileVC, nil];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout-32"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonClicked)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"upload-32"] style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonClicked)];
    self.navigationItem.leftBarButtonItem = uploadButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (OnlineFileViewController *)onlineFileVC{
    if (!_onlineFileVC) {
        _onlineFileVC = [[OnlineFileViewController alloc] init];
        _onlineFileVC.tabBarItem.title = @"Online Files";
        _onlineFileVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"cloud-50"] toSize:CGSizeMake(24, 24)];
    }
    return _onlineFileVC;
}

- (LocalFileViewController *)localFileVC{
    if (!_localFileVC) {
        _localFileVC = [[LocalFileViewController alloc] init];
        _localFileVC.tabBarItem.title = @"Local Files";
        _localFileVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"local-50"] toSize:CGSizeMake(24, 24)];
    }
    return _localFileVC;
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (void)uploadButtonClicked{
    [self uploadPhotos];
}

- (void)uploadPhotos{
    [self presentViewController:self.imagePicker animated:YES completion:^{

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [SVProgressHUD showWithStatus:@"uploading"];
    UIImage *pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    [dateFmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableString *imageName = [[dateFmt stringFromDate:[NSDate date]] mutableCopy];
    NSString *fileType = [[[[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent] componentsSeparatedByString:@"."] lastObject];
    [imageName appendString:@"."];
    [imageName appendString:[fileType lowercaseString]];
    
    [[EBoxNetwork sharedInstance] uploadFileWithName:imageName contentData:imageData completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"upload Successed"];
            [self.onlineFileVC refreshAfterUpload];
        });
    } completeFailed:^(NSString *failedStr) {
        __block NSString *failedDiscription = [NSString stringWithFormat:@"Upload failed:%@",failedStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:failedDiscription];
        });
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = NO;
    }
    return _imagePicker;
}

- (void)logoutButtonClicked{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    
    [alertView show];
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        [[EBoxNetwork sharedInstance] logout];
        [[EBoxLocalFile sharedInstance] logoutAndDeleteFiles];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
