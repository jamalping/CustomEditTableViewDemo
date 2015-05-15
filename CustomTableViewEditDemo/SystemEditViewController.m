//
//  SystemEditViewController.m
//  CustomTableViewEditDemo
//
//  Created by jamalping on 15/5/16.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "SystemEditViewController.h"

@interface SystemEditViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *RightItem;

@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation SystemEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [_datas addObject:[NSString stringWithFormat:@"--%d",i]];
    }
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tableViewEdit:(id)sender {
    if ([_RightItem.title isEqual:@"Edit"]) {
        self.tableView.editing =YES;
        _RightItem.title = @"确定";
    }else {
        /// 删除数据
        for (int i = (int)self.tableView.indexPathsForSelectedRows.count; i < 0; i--) {
            NSIndexPath *indexPath = self.tableView.indexPathsForSelectedRows[i];
            [_datas removeObjectAtIndex:indexPath.row];
        }
        NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
        [self.tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            [deleteIndexSet addIndex:indexPath.row];
        }];
        [_datas removeObjectsAtIndexes:deleteIndexSet];
        [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdetif = @"DSFDFDG";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetif];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetif];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}

// UITableViewCellEditingStyleDelete 删除-----UITableViewCellEditingStyleInsert 插入
// 二者都存在的时候显示多选的圆圈
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return
//    UITableViewCellEditingStyleDelete
//    |
    UITableViewCellEditingStyleInsert
    ;
}

// 设置删除时右边按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除。。。。。。。";
}


//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"shanchu" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [_datas removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    }];
//    UITableViewRowAction *deleteAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//        if (![firstIndexPath isEqual:indexPath]) {
//            [_datas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
//            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
//        }
//    }];
//    return @[deleteAction,deleteAction1];
//}

// 系统删除按钮的响应
- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 数据源也要相应删除一项
        [_datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [_datas addObject:@"100"];
        NSLog(@"%@",_datas);
        [_datas exchangeObjectAtIndex:_datas.count-1 withObjectAtIndex:indexPath.row+1];
        NSLog(@"%@",_datas);
        NSIndexPath *insetIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[insetIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


@end
