//
//  MessageTableCell.h
//  mxj
//  P8消息TableCell头文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;      //标题

//设置Cell的内容
- (void)setCellValue:(NSString *)titleName messageCount:(NSString *)messageCount;

@end
