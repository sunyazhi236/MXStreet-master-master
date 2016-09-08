//
//  EncourageMeTableCell.h
//  mxj
//  P8-4赞我用TableCell头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncourageMeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;    //用户名
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;  //点赞时间
@property (weak, nonatomic) IBOutlet EGOImageView *photo1;      //赞首图
@property (nonatomic, strong) id<UserImageViewClickProtocol> delegate; //代理

@end
