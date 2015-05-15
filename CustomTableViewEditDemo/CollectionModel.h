//
//  CollectionModel.h
//  GENIUS
//
//  Created by jamalping on 15/5/7.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic,copy)NSString *headImgStr;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *newsTitle;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,assign)BOOL edit;

@end
