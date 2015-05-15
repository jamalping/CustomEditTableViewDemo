//
//  CollectViewController.m
//  GENIUS
//
//  Created by jamalping on 15/5/5.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectionTableViewCell.h"
#import "CollectionModel.h"

static CGFloat tableViewUp = 55;

@interface CollectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)NSMutableArray *deleteArray;  // 选中
@property (nonatomic,assign)BOOL editing;                 // 是否正在编辑
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableVIewBottomConstraint; // 表视图下边间距约束
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

static NSString *collectionTableViewCell = @"CollectionTableViewCell";
@implementation CollectViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的收藏";
        self.hidesBottomBarWhenPushed = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateSelected];
//        button.titleLabel.textColor = [UIColor redColor];
//        [button setTintColor:[UIColor redColor]];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    JamalTableViewRegistForCellWithNib(self.tableView, , collectionTableViewCell);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionTableViewCell class]) bundle:nil] forCellReuseIdentifier:collectionTableViewCell];
    
    _datas = [NSMutableArray array];
    
    [self reloadDatas];
}

#pragma mark - 获取数据
- (void)reloadDatas {
    for(int i = 0; i < 10; i++) {
        CollectionModel *collectionModel = [[CollectionModel alloc] init];
        collectionModel.userName = [NSString stringWithFormat:@"山寨达人+%d",i];
        collectionModel.newsTitle = @"这是一条新闻title";
        collectionModel.time = @"15-05-08";
        collectionModel.edit = NO;
//        NSString *str = [NSString stringWithFormat:@"%d",i];
        [_datas addObject:collectionModel];
    }
}

#pragma mark - Action—— 是否进入编辑状态
- (void)editAction:(UIButton *)editButton {
    editButton.selected = !editButton.selected;
    self.editing = editButton.selected;
    
    for (CollectionModel *model in self.datas) {
        model.edit = editButton.selected;
    }
    [self.tableView reloadData];
    
    if (self.editing) {  // 正在编辑
        self.tableVIewBottomConstraint.constant = tableViewUp;
        if (!_deleteArray) {
            _deleteArray = [NSMutableArray array];
        }
    } else {           // 取消编辑
        self.tableVIewBottomConstraint.constant = 0;
        [self clearDeleteArray];
    }
}

// 添加或删除取消的内容
- (void)cellEditedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [_deleteArray addObject:[NSNumber numberWithInteger:button.tag]];
    }else {
        [_deleteArray removeObject:[NSNumber numberWithInteger:button.tag]];
    }
    
    if (_deleteArray.count>0) {
        self.deleteButton.enabled = YES;
    }else {
        self.deleteButton.enabled = NO;
    }
}

// 取消收藏(删除数据，再删除UI)
- (IBAction)deleteCollectionAction:(id)sender {
    // 删除数据
    NSMutableArray *deletePaths = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    [_deleteArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [indexSet addIndex:[obj unsignedIntegerValue]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [deletePaths addObject:indexPath];
    }];
    [_datas removeObjectsAtIndexes:indexSet];
    // 删除UI
    [_tableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationRight];
    // 延迟刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:.5];
        [_tableView reloadRowsAtIndexPaths:[_tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
        [self clearDeleteArray];
    });
}

#pragma mark - 清除删除数组中的数据
- (void)clearDeleteArray {
    [_deleteArray removeAllObjects];
    self.deleteButton.enabled = NO;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionTableViewCell];
    [cell.editButton addTarget:self action:@selector(cellEditedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.editButton.tag = indexPath.row;
    cell.editButton.selected = NO;
    cell.model = _datas[indexPath.row];
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        CollectionTableViewCell *cell = (CollectionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.editButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
