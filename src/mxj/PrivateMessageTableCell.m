//
//  PrivateMessageTableCell.m
//  mxj
//  私信Cell用实现文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PrivateMessageTableCell.h"

@implementation PrivateMessageTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)personImageBtnClick:(id)sender {
    [_delegate imageViewClick:sender];
}


@end
