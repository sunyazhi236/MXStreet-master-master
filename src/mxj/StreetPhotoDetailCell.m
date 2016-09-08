//
//  StreetPhotoDetailCell.m
//  mxj
//  P7-4街拍详情用Cell
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "StreetPhotoDetailCell.h"

@implementation StreetPhotoDetailCell

- (void)awakeFromNib {
   // if (![TKLoginType shareInstance].loginType) {
     //   [_personBtn setEnabled:NO];
    //}
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(224, 225, 227, 1);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击用户头像事件
- (IBAction)personImageClick:(id)sender {
    [_imageClickDelegate imageViewClick:sender];
}

//删除评论按钮点击事件
- (IBAction)deleteCommentBtnClick:(id)sender {
    [_deleteCommentDelegate deleteCommentBtnClick:sender];
}

@end
