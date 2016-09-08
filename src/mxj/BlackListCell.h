//
//  BlackListCell.h
//  mxj
//  P12-7黑名单
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel; //用户名
@property (copy, nonatomic) NSString *userId;                //用户Id
@property (copy, nonatomic) NSString *blacklistId;           //黑名单用户Id
@property (copy, nonatomic) NSString *flag;                  //标识(0：拉黑，1：移除）
@property (strong, nonatomic) UIViewController *viewCtrl;    //父视图控制器
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像

@end
