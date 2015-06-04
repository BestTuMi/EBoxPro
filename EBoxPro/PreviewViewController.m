//
//  PreviewViewController.m
//  EBoxPro
//
//  Created by yxj on 5/30/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "PreviewViewController.h"
#import "EBoxFile.h"
#import "EBoxLocalFile.h"

@interface PreviewViewController ()

@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,strong)EBoxFile *mainFile;
@property (nonatomic,strong)UIImageView *mainImageView;
@property (nonatomic,strong)UITextView *mainTextView;

@end

@implementation PreviewViewController

- (PreviewViewController *)initWithFileName:(NSString *)theFileName{
    self = [super init];
    if (self) {
        self.fileName = theFileName;
        if (!self.fileName) {
            return nil;
        }
        self.mainFile = [[EBoxLocalFile sharedInstance] localFileWithFileName:self.fileName];
        if (![self.mainFile.fileType isEqualToString:@"png"] && ![self.mainFile.fileType isEqualToString:@"jpg"] && ![self.mainFile.fileType isEqualToString:@"txt"]) {
            return nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.fileName) {
        return;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainFile = [[EBoxLocalFile sharedInstance] localFileWithFileName:self.fileName];
    
    if ([self.mainFile.fileType isEqualToString:@"png"] || [self.mainFile.fileType isEqualToString:@"jpg"]) {
        UIImage *theImage = [UIImage imageWithData:self.mainFile.fileContent];
        self.mainImageView.image = theImage;
        self.mainImageView.height = theImage.size.height / theImage.size.width * 320.0;
        self.mainImageView.center = CGPointMake(160, (self.view.height - 64) / 2.0);
        [self.view addSubview:self.mainImageView];
    }
    
    if ([self.mainFile.fileType isEqualToString:@"txt"]) {
        self.mainTextView.text = [[NSString alloc] initWithData:self.mainFile.fileContent encoding:NSUnicodeStringEncoding];
        [self.view addSubview:self.mainTextView];
    }
}

- (UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    }
    return _mainImageView;
}

- (UITextView *)mainTextView{
    if (!_mainTextView) {
        _mainTextView = [[UITextView alloc] initWithFrame:self.view.frame];
    }
    return _mainTextView;
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
