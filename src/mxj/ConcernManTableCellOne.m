//
//  ConcernManTableCellOne.m
//  mxj
//  P10关注的人-已关注TableCell用实现文件
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ConcernManTableCellOne.h"

@implementation ConcernManTableCellOne

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//头像点击事件处理
- (IBAction)imageBtnClick:(id)sender {
    [self.delegate imageViewClick:sender];
}

//已关注按钮点击事件
- (IBAction)concernBtnClick:(id)sender {
    [_gzBtnDelegate gzBtnClick:sender];
}

@end
