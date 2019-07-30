//
//  ArtLogListViewController.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import "ArtLogListViewController.h"
#import "ArtLogPreviewViewController.h"
#import "ArtDDLogReader.h"
#import "ArtLogPreManager.h"

@interface ArtLogListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *fileList;
@property (nonatomic, copy)NSString *folderPath;

@end

@implementation ArtLogListViewController

- (void)dealloc
{
    NSLog(@"ArtLogListViewController:%@正常释放...",self);
}

+ (instancetype)LogListWithFolderPath:(NSString *)folderPath{
    ArtLogListViewController *listVC = [[ArtLogListViewController alloc] initWithFolderPath:folderPath];
    return listVC;
}

- (instancetype)initWithFolderPath:(NSString *)folderPath{
    if (self = [super init]) {
        self.folderPath = folderPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllfiles)];
    self.navigationItem.rightBarButtonItems = @[refreshItem,deleteItem];
    
    [self.view addSubview:self.tableView];
    
    [self refreshData];
}

- (void)refreshData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.fileList = [ArtDDLogReader readFolderWithPath:self.folderPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.fileList.count) {
                [self.tableView reloadData];
            }
        });
    });
}

- (void)deleteAllfiles{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ArtLogPreManager shareInstance] removeAllLogFiles];
        self.fileList = [ArtDDLogReader readFolderWithPath:self.folderPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)dismiss{
    [[ArtLogPreManager shareInstance] setIsShowLogVC:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.fileList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *filePath = [self.folderPath stringByAppendingPathComponent:self.fileList[indexPath.row]];
    ArtLogPreviewViewController *vc = [ArtLogPreviewViewController PreviewWithFilePath:filePath];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0.001;
        _tableView.estimatedSectionFooterHeight = 0.001;
    }
    return _tableView;
}



@end
