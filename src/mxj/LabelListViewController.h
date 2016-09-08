//
//  LabelListViewController.h
//  mxj
//  P7-1-2标签列表页
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "LabelDetailViewController.h"

@interface LabelListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *labelListTableView; //标签列表TableView
@property (strong, nonatomic) UITableViewCell *labelListOneCell; //首行Cell
@property (weak, nonatomic) UILabel *photoNumLabel;              //街拍数量
@property (weak, nonatomic) UILabel *userNumLabel;               //用户数

@property (strong, nonatomic) IBOutlet UITableViewCell *labelListTwoCell; //第二行Cell
@property (weak, nonatomic) IBOutlet EGOImageView *firstImageView;      //第二行第一幅图片
@property (weak, nonatomic) IBOutlet UIImageView *firstBackImageView;   //第一幅图片背景图
@property (weak, nonatomic) IBOutlet UIImageView *firstZanImageView;    //赞图片
@property (weak, nonatomic) IBOutlet UIButton *firstZanBtn;             //赞按钮
@property (weak, nonatomic) IBOutlet EGOImageView *firstPersonImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *firstPersonName;          //个人名称

@property (weak, nonatomic) IBOutlet EGOImageView *secondeImageView;      //第二行第二幅图片
@property (weak, nonatomic) IBOutlet UIImageView *secondeBackImageView;   //背景图片
@property (weak, nonatomic) IBOutlet UIImageView *secondeZanImageView;    //赞图片
@property (weak, nonatomic) IBOutlet UIButton *secondeZanBtn;             //赞按钮
@property (weak, nonatomic) IBOutlet EGOImageView *secondePersonImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *secondePersonName;          //个人名称

@property (weak, nonatomic) LabelDetailViewController *superViewController;   

@property (nonatomic, copy) NSString *tagId;   //标签Id

@property (nonatomic, assign) int type;   //0=默认  1=个人主页进入

@property (nonatomic, copy) NSString *userId;   //个人主页进入需要带userId


@end
