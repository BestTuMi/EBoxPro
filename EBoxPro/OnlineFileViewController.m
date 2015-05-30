//
//  OnlineFileViewController.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "OnlineFileViewController.h"
#import "EBoxNetwork.h"
#import "EBoxLocalFile.h"
#import "EBoxFile.h"
#import "MJRefresh.h"
#import <SVProgressHUD.h>
#import "PreviewViewController.h"

@interface OnlineFileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *fileArray;

@end

@implementation OnlineFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Online files";
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    [self.view addSubview:self.mainTableView];
    
    __weak OnlineFileViewController *weakSelf = self;
    [self.mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefresh];
    }];
    [self.mainTableView.header beginRefreshing];
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 64+44, 0);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (NSMutableArray *)fileArray{
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

- (void)pullToRefresh{
    __weak OnlineFileViewController *weakSelf = self;
    [[EBoxNetwork sharedInstance] getFileListWithCompleteSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullToRefreshSuccess:responseJson];
        });
        [weakSelf.mainTableView.header endRefreshing];
    } completeFailed:^(NSString *failedStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:failedStr];
        });
        [weakSelf.mainTableView.header endRefreshing];
    }];
}

- (void)pullToRefreshSuccess:(NSDictionary *)responseJson{
    [self.fileArray removeAllObjects];
    NSArray *theFileArray = [(NSArray *)responseJson[@"result"] mutableCopy];
    for (NSDictionary *theFileDict in theFileArray) {
        EBoxFile *theFile = [[EBoxFile alloc] initWithResultJson:theFileDict];
        [self.fileArray addObject:theFile];
    }
    [self.mainTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCell = [[UITableViewCell alloc] init];
    EBoxFile *theFile = (EBoxFile *)self.fileArray[indexPath.row];
    theCell.textLabel.text = theFile.filePath;
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    EBoxFile *theFile = (EBoxFile *)self.fileArray[index];
    if ([[EBoxLocalFile sharedInstance] isLocalFileExistWithFileName:theFile.filePath]) {
        [self segueToPreviewVC:index];
    }else{
        [self downloadSelectedFile:index];
        
    }
   
}

- (void)downloadSelectedFile:(NSInteger)index{
    EBoxFile *theFile = (EBoxFile *)self.fileArray[index];
    NSString *fileID = theFile.fileID;
    
    [SVProgressHUD showWithStatus:@"downloading"];
    [[EBoxNetwork sharedInstance] downloadFileWithFileID:fileID completeSuccessed:^(NSDictionary *responseJson) {
        EBoxFile *downloadFile = [[EBoxFile alloc] initWithResultJson:responseJson];
        [[EBoxLocalFile sharedInstance] saveFile:downloadFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"download successed"];
            [self segueToPreviewVC:index];
        });
    } completeFailed:^(NSString *failedStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"download error"];
        });
    }];
}

- (void)segueToPreviewVC:(NSInteger)index{
    EBoxFile *theFile = (EBoxFile *)self.fileArray[index];
    
    PreviewViewController *previewVC = [[PreviewViewController alloc] initWithFileName:theFile.filePath];
    if (previewVC) {
        [self.navigationController pushViewController:previewVC animated:YES];
    }else{
        alert(@"Not support");
    }
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
