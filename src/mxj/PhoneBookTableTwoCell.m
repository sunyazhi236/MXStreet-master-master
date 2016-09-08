//
//  PhoneBookTableTwoCell.m
//  mxj
//  P7-5-1-1手机通讯录用第二类Cell
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PhoneBookTableTwoCell.h"

@implementation PhoneBookTableTwoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//邀请按钮点击事件
- (IBAction)inviteUserBtnClick:(id)sender {
    [_invisteUserBtnDelegate invisteUserBtnClick:sender];
}

@end
