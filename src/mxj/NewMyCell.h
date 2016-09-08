//
//  NewMyCell.h
//  mxj
//
//  Created by MQ-MacBook on 16/5/22.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMyModel.h"

@interface NewMyCell : UITableViewCell

@property (nonatomic, assign) NSInteger *type;

/**
 *  赋值cell
 *
 *  itemData 数据源
 */
- (void)initDataWithModel:(GetUserInfo *)itemData type:(NSInteger)type dataArray:(NSMutableArray *)dataArray;

@end
