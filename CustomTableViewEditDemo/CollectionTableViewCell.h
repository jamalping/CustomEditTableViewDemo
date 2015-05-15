//
//  CollectionTableViewCell.h
//  GENIUS
//
//  Created by jamalping on 15/5/6.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@protocol DeleteEditDelegate <NSObject>

- (void)editSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface CollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic, weak)id <DeleteEditDelegate> delegate;
@property (nonatomic,strong)CollectionModel *model;

@end
