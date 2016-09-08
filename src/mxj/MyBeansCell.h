//
//  MyBeansCell.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBeansModel.h"

#define CELL_HEIGH 49

@interface MyBeansCell : UITableViewCell

/**
 *  赋值cell
 *
 *  itemData 数据源
 */
- (void)initDataWithModel:(MyBeansModel *)itemData;

@end
