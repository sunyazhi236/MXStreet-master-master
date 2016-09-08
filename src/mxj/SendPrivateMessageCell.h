//
//  SendPrivateMessageCell.h
//  mxj
//  P8-3-1发送私信用TableCell头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPrivateMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *kuangImageView; //气泡imageView
@property (strong, nonatomic) IBOutlet CustomLabel *messageLabel; //消息内容
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;  //时间标签
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;    //时间标签背景
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UIButton *personBtn;   //个人头像按钮

@end
