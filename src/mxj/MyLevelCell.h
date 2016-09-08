//
//  MyLevelCell.h
//  mxj
//  我的等级用Cell
//  Created by 齐乐乐 on 15/12/5.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLevelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;      //操作名称
@property (weak, nonatomic) IBOutlet UILabel *scollLabel;     //分值
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;   //重复性描述

@end
