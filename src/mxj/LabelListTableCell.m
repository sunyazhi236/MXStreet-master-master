//
//  LabelListTableCell.m
//  mxj
//  P7-1-2标签列表Cell
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "LabelListTableCell.h"

@implementation LabelListTableCell

- (void)awakeFromNib {
    self.firstBackImageView.layer.cornerRadius = 5;
    self.secondeCellBackImageView.layer.cornerRadius = 5;

    self.firstBackImageView.layer.masksToBounds = YES;
    self.secondeCellBackImageView.layer.masksToBounds = YES;

    self.firstBackImageView.clipsToBounds = YES;
    self.secondeCellBackImageView.clipsToBounds = YES;

    [CustomUtil setImageViewCorner:_firstPersonImageView];
    [CustomUtil setImageViewCorner:_secondePersonImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -按钮点击事件
//点赞
- (IBAction)zanBtnClick:(id)sender {
    UIButton *zanBtn = (UIButton *)sender;
    [zanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
}

@end
