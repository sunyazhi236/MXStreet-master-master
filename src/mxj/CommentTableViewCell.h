//
//  CommentTableViewCell.h
//  mxj
//  P8_1评论TableCell头文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;       //评论用户名
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;    //评论时间
@property (weak, nonatomic) IBOutlet UILabel *commentContextLabel; //评论内容
@property (weak, nonatomic) IBOutlet EGOImageView *photo1;          //街拍首图
@property (nonatomic, strong) id<UserImageViewClickProtocol> delegate; //图片点击代理

@end
