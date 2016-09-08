//
//  ConcernManTableViewCell.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ConcernManTableViewCell.h"

@implementation ConcernManTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//头像按钮点击事件处理
- (IBAction)imageBtnClick:(id)sender {
    [self.delegate imageViewClick:sender];
}

//关注按钮点击事件
- (IBAction)gzBtnClick:(id)sender {
    [_gzDelegate gzBtnClick:sender];
}

@end
