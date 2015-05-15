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
        self.tableView.allowsSelectionDuringEditing = YES;
        self.tableView.allowsMultipleSelection=YES;
        self.tableView.allowsMultipleSelectionDuringEditing=YES;
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return
    UITableViewCellEditingStyleDelete
    |
    UITableViewCellEditingStyleInsert;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    [segue initWithIdentifier:@"PresentSystem" source:<#(UIViewController *)#> destination:<#(UIViewController *)#>]
    
//}

@end
