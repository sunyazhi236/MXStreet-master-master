//
//  AreaSelectTableCell.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "AreaSelectTableCell.h"

@implementation AreaSelectTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置Cell上的省份名称
- (void)setCell:(NSString *)provanceNameStr
{
    self.provanceNameLabel.text = provanceNameStr;
}

@end
