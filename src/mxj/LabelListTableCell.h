//
//  LabelListTableCell.h
//  mxj
//  P7-1-2标签列表Cell
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *firstImageView; //第一个imageView
@property (weak, nonatomic) IBOutlet EGOImageView *secondeImageView; //第二个imageView

@property (weak, nonatomic) IBOutlet EGOImageView *firstPersonImageView;    //图一个人头像
@property (weak, nonatomic) IBOutlet UIImageView *firstBackImageView;      //图一背景图
@property (weak, nonatomic) IBOutlet UIImageView *firstZanImageView;       //图一赞图标
@property (weak, nonatomic) IBOutlet UIButton *firstZanBtn;                //图一赞按钮
@property (weak, nonatomic) IBOutlet UILabel *firstPersonName;             //图一用户名

@property (weak, nonatomic) IBOutlet UIImageView *secondeCellBackImageView;  //图二背景
@property (weak, nonatomic) IBOutlet EGOImageView *secondePersonImageView;    //图二个人头像
@property (weak, nonatomic) IBOutlet UIImageView *secondeZanImageView;       //图二赞图标
@property (weak, nonatomic) IBOutlet UILabel *secondePersonName;             //图二个人用户名
@property (weak, nonatomic) IBOutlet UIButton *secondeZanBtn;                //图二赞按钮



@end
