//
//  PositionSetCell.m
//  mxj
//  P7-3-1设置位置信息用Cell
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PositionSetCell.h"

@implementation PositionSetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置Cell元素坐标
- (void)setLabelPostion:(BOOL)adjustPostion
{
    if (adjustPostion) {
        CGRect rect = _labelName.frame;
        rect.origin.y = (self.contentView.frame.size.height - _labelName.frame.size.height)/2;
        _labelName.frame = rect;
    } else {
        CGRect rect = _labelName.frame;
        rect.origin.y = 11;
        _labelName.frame = rect;
    }
}

@end
