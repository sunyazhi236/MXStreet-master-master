//
//  MainPageTabBarController.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/10.
//  Copyright © 2015年 bluemobi. All rights reserved.
//
#import "ImageWaterView.h"
#import "SVPullToRefresh.h"
#import "JSONKit.h"
#import "MenuBtnCell.h"

@interface MainPageTabBarController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITabBarDelegate, imageViewClickDelegate, MenuBtnClickDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainPageTableView;       //TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *imageTableCell;      //广告图Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *btnTableCell;        //菜单Cell

@property (strong, nonatomic) IBOutlet UIButton *guanzhuBtn;                 //关注按钮
@property (strong, nonatomic) IBOutlet UIButton *renqiBtn;                   //人气按钮
@property (strong, nonatomic) IBOutlet UIButton *tongcBtn;                   //同城按钮

@property (strong, nonatomic) UIImageView *cellBackImageView;       //菜单Cell的背景图片

@property (strong, nonatomic) UIView *cellBackView;       //菜单Cell的背景图片

@property (strong, nonatomic) UIScrollView *bannerScrollView;       //广告ScrollView
@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;         //广告ImageView
@property (strong, nonatomic) UIPageControl *bannerPageCtrl;        //广告PageCtrl
@property (strong, nonatomic) ImageWaterView *guanzhuWaterView;              //关注瀑布视图
@property (strong, nonatomic) ImageWaterView *renqiWaterView;                //人气瀑布视图
@property (strong, nonatomic) ImageWaterView *tongchengWaterView;            //同城瀑布视图

@property (strong, nonatomic) id<ScrollViewChangeBtnDelegate>scrollViewChangeBtnDelegate; //按钮点击事件代理
@property (weak, nonatomic) IBOutlet UIButton *positionBtn; //地点按钮

@property (weak, nonatomic) IBOutlet UIButton *rightButton; //右按钮

@property (assign, nonatomic) NSString *cityName;           //城市名称
@property (assign, nonatomic) NSString *cityFlag;           //城市标识（0：定位城市，1：切换城市）
@property (assign, nonatomic) BOOL loginFlag;               //登录进入标识 YES:登录进入 NO:其它进入

@property (strong, nonatomic) UIView *signBackView;
@property (nonatomic, strong) MenuBtnCell *menuBtnCell;

-(void)changeBtnStatus;


@end
