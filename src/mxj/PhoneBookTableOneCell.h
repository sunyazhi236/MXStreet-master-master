//
//  PhoneBookTableOneCell.h
//  mxj
//  P7-5-1-1手机通讯录
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneBookTableOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView;  //个人头像
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;       //毛线街用户名
@property (weak, nonatomic) IBOutlet UILabel *phoneNameLabel;        //手机通讯录名称
@property (weak, nonatomic) IBOutlet UILabel *phoneContactLabel;     //手机联系人标签

@end
