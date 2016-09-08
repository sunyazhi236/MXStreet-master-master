//
//  CommentTableViewCell.m
//  mxj
//  P8_1评论TableCell实现文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)personImageBtnClick:(id)sender {
    [_delegate imageViewClick:sender];
}


@end
