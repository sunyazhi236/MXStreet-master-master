//
//  MeFansTableViewOneCell.m
//  mxj
//  P11我的粉丝首行TableCell
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MeFansTableViewOneCell.h"

@implementation MeFansTableViewOneCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -按钮点击事件
//用户头像点击事件
- (IBAction)userImageViewClick:(id)sender {
    [self.delegate imageViewClick:sender];
}

//关注按钮点击事件
- (IBAction)guanzhuBtnClick:(id)sender {
    [_guanzhuBtnDelegate guanZhuCellBtnClick:sender];
}

@end
