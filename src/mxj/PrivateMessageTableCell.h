//
//  PrivateMessageTableCell.h
//  mxj
//  私信用Cell头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateMessageTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *showUserNameLabel;   //姓名
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;        //内容
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;     //发信时间
@property (nonatomic, strong) id<UserImageViewClickProtocol> delegate;  //代理

@end
