//
//  CollectionTableViewCell.m
//  GENIUS
//
//  Created by jamalping on 15/5/6.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "CollectionTableViewCell.h"

#define EDIT_BUTTON_NORMAL_WIDTH 22

@interface CollectionTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delBtnWidthConstraint;


@end

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self commonSet];
}

#pragma mark - 基本设置
- (void)commonSet {
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
    self.headImageView.clipsToBounds = YES;
    
    [_editButton setBackgroundImage:imageFromcolor([UIColor cyanColor]) forState:UIControlStateNormal];
    [_editButton setBackgroundImage:imageFromcolor([UIColor redColor]) forState:UIControlStateSelected];
    // 设置圆角
    self.editButton.layer.cornerRadius = self.editButton.frame.size.height/2;
    self.editButton.clipsToBounds = YES;
}

- (void)layoutSubviews {
    self.userNameLabel.text = _model.userName;
    self.timeLabel.text = _model.newsTitle;
    self.timeLabel.text = _model.time;
    self.delBtnWidthConstraint.constant = _model.edit?EDIT_BUTTON_NORMAL_WIDTH:0;
}

//+ (UIImage *)imageFromColor:(UIColor *)color
UIImage* imageFromcolor (UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
