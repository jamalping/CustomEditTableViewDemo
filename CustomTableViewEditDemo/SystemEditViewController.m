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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.tableView addGestureRecognizer:longPress];
}

// 长按移动表视图
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    static UIImageView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    UIGestureRecognizerState state = longPress.state;
    CGPoint touchPoint = [longPress locationInView:self.tableView];
    NSIndexPath *touchedIndexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
        {
            // Check for a valid index path, otherwise cancel the touch
            if (!touchedIndexPath || [touchedIndexPath section] == NSNotFound || [touchedIndexPath row] == NSNotFound) {
                longPress.enabled = NO;
                longPress.enabled = YES;
                break;
            }
            sourceIndexPath = touchedIndexPath;
            // Get the touched cell and reset it's selection state
            UITableViewCell *touchedCell = [self.tableView cellForRowAtIndexPath:touchedIndexPath];
            [touchedCell setSelected:NO];
            [touchedCell setHighlighted:NO];
            // Add the snapshot as subview, centered at cell's center...
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            snapshot = [[UIImageView alloc] initWithImage:image];
            CGRect snapShotFrame = [self.tableView rectForRowAtIndexPath:touchedIndexPath];
            snapShotFrame.size = touchedCell.bounds.size;
            [snapshot setFrame:snapShotFrame];
            [snapshot setAlpha:0.95];
            
//            [self.tableView addSubview:snapshot];
            
//            snapshot = [self customSnapshotFromView:touchedCell];
            
            __block CGPoint center = touchedCell.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [self.tableView addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                
                // Offset for gesture location.
                center.y = touchPoint.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;
                // Black out.
                touchedCell.backgroundColor = [UIColor clearColor];
            } completion:nil];
        }break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = touchPoint.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (touchedIndexPath && ![touchedIndexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.datas exchangeObjectAtIndex:touchedIndexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:touchedIndexPath];
                
                // ... and update source so it is in sync with UI changes. 
                sourceIndexPath = touchedIndexPath;
            } 
        }break;
         /*
        case UIGestureRecognizerStateEnded:
        {
            [self stopAutoscrolling];
            
            // Get to final index path
            CGRect finalFrame = [self rectForRowAtIndexPath:[self movingIndexPath]];
            
            // Place the snap shot to it's final position and fade it out
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 [[self snapShotImageView] setFrame:finalFrame];
                                 [[self snapShotImageView] setAlpha:1.0];
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 if (finished)
                                 {
                                     // Clean up snap shot
                                     [[self snapShotImageView] removeFromSuperview];
                                     [self setSnapShotImageView:nil];
                                     
                                     // Inform the data source about the new position if necessary
                                     if ([[self initialIndexPathForMovingRow] compare:[self movingIndexPath]] != NSOrderedSame) {
                                         [[self dataSource] moveTableView:self moveRowFromIndexPath:[self initialIndexPathForMovingRow] toIndexPath:[self movingIndexPath]];
                                     }
                                     
                                     // Reload row at moving index path to reset it's content
                                     NSIndexPath *movingIndexPath = [self movingIndexPath];
                                     [self setMovingIndexPath:nil];
                                     [self setInitialIndexPathForMovingRow:nil];
                                     [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                 }
                                 
                             }];			
            
        }break;
          */

        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview]; 
                snapshot = nil; 
                
            }];
            sourceIndexPath = nil;
        }break;
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
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
// 必须实现的方法
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

// 自定义编辑时的操作
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
