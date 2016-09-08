//
//  MyBeansCashCell.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBeansCashModel.h"

#define CELL_HEIGH 50

@interface MyBeansCashCell : UITableViewCell

/**
 *  赋值cell
 *
 *  itemData 数据源
 */
- (void)initDataWithModel:(MyBeansCashModel *)itemData;

@end
