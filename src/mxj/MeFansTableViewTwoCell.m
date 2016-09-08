//
//  MeFansTableViewTwoCell.m
//  mxj
//  P11我的粉丝首行以外的TableCell
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MeFansTableViewTwoCell.h"

@implementation MeFansTableViewTwoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -按钮点击事件处理
//用户头像按钮点击事件处理
- (IBAction)userImageViewClick:(id)sender {
    [self.delegate imageViewClick:sender];
}

//关注按钮点击事件
- (IBAction)guanzhuBtnClick:(id)sender {
    [_guanzhuBtnDelegate guanZhuCellBtnClick:sender];
}


@end
