//
//  LocalFileViewController.m
//  EBoxPro
//
//  Created by yxj on 5/28/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "LocalFileViewController.h"
#import "EBoxLocalFile.h"
#import "MJRefresh.h"

@interface LocalFileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *localFileList;
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation LocalFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Local files";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    __weak LocalFileViewController *weakSelf = self;
    [self.mainTableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.localFileList = [[[EBoxLocalFile sharedInstance] getLocalFilesPathList] mutableCopy];
        [weakSelf.mainTableView reloadData];
        [weakSelf.mainTableView.header endRefreshing];
    }];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.header beginRefreshing];
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (NSMutableArray *)localFileList{
    if (!_localFileList) {
        _localFileList = [NSMutableArray array];
    }
    return _localFileList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localFileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCell = [[UITableViewCell alloc] init];
    theCell.textLabel.text = (NSString *)self.localFileList[indexPath.row];
    return theCell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    return;
//}

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
