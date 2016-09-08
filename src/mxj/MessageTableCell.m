//
//  MessageTableCell.m
//  mxj
//  P8消息TableCell实现文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MessageTableCell.h"

@implementation MessageTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置Cell的内容
- (void)setCellValue:(NSString *)titleName messageCount:(NSString *)messageCount
{
    [self.messageLabel setText:titleName];
    [_messageLabel showBadgeWithStyle:WBadgeStyleNumber value:messageCount.intValue animationType:WBadgeAnimTypeNone];
}

@end
