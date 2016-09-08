//
//  PersonDocViewController.h
//  mxj
//  P12-1个人资料
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonDocViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *personDocTableView; //个人资料TableView

@property (strong, nonatomic) IBOutlet UITableViewCell *touXiangCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *menpaiCell; //门牌号
@property (strong, nonatomic) IBOutlet UITableViewCell *niChengCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *xingBieCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *chuShengNianYueCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *suoZaiDiQuCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *dianPuCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *geXingQianMingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *zhuCeShiJianCell;


@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *menpaiLabel;    //门牌号
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;  //昵称名称
@property (weak, nonatomic) IBOutlet UILabel *sexLabel; //性别
@property (weak, nonatomic) IBOutlet UILabel *birthDayLabel;  //出生年月
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;  //所在地区
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;  //店铺
//@property (weak, nonatomic) IBOutlet UITextView *personSign; //个性签名
@property (weak, nonatomic) IBOutlet UILabel *personSign; //个性签名


@property (weak, nonatomic) IBOutlet UILabel *registerTime; //注册时间

@property (weak, nonatomic) IBOutlet EGOImageView *bigPersonImageView; //个人大头像



@property (strong, nonatomic) IBOutlet UIView *openPhotoView;    //打开图库视图
@property (weak, nonatomic) IBOutlet UIImageView *btnBackImageView; //更换头像背景

@property (nonatomic, copy) NSString *queryUserId;  //要查询的用户id



@end
