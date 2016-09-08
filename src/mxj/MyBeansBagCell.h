//
//  MyBeansBagCell.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/11.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBeansBagModel.h"

#define CELL_HEIGH 65

@interface MyBeansBagCell : UITableViewCell
/**
 *  赋值cell
 *
 *  itemData 数据源
 */
- (void)initDataWithModel:(MyBeansBagModel *)itemData;
@end
