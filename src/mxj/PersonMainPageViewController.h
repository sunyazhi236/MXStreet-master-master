//
//  PersonMainPageViewController.h
//  mxj
//  P9-0个人主页
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageWaterView.h"
#import "SVPullToRefresh.h"
#import "JSONKit.h"

@interface PersonMainPageViewController : BaseViewController<imageViewClickDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) ImageWaterView *waterView; //瀑布流
@property (strong, nonatomic) IBOutlet UIView *blackNameListView; //黑名单视图
@property (strong, nonatomic) IBOutlet UIView *addBlackListView; //黑名单操作按钮视图
@property (strong, nonatomic) IBOutlet UIView *userPhotoView;    //用户大图视图
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (nonatomic, copy) NSString *userId;  //用户Id
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;     //级别图标
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;             //级别标签
@property (weak, nonatomic) IBOutlet UILabel *userName;               //用户名
@property (weak, nonatomic) IBOutlet UIImageView *jiangPaiImageView;  //奖牌图片
@property (weak, nonatomic) IBOutlet UILabel *daRenLabel;             //达人Label
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;           //地区Label
@property (weak, nonatomic) IBOutlet UILabel *personSignLabel;        //个性签名
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;            //关注按钮
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;              //关注加号

@property (weak, nonatomic) IBOutlet UIButton *fansBtn;               //粉丝按钮
@property (weak, nonatomic) IBOutlet UIButton *concertBtn;            //关注按钮


@property (weak, nonatomic) IBOutlet UIButton *addBlackListBtn;       //加入黑名单按钮
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;  //更多按钮
@property (weak, nonatomic) IBOutlet EGOImageView *bigPersonPhotoImageView; //个人大头像

@property (weak, nonatomic) IBOutlet EGOImageView *bannerImageView;    //背景图片
@property (weak, nonatomic) IBOutlet UITableView *totalTableView;      //全局TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;       //行一
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTwo;       //行二

@end
