//
//  MyStreetPhotoViewController.h
//  mxj
//  P9-1我的街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ImageWaterView.h"

@interface MyStreetPhotoViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@property(nonatomic, copy) NSString *userId;     //用户Id

@property(nonatomic, assign) NSInteger type;     // 0=我 1=其他用户进入

@property (strong, nonatomic) IBOutlet UIView *shareView;      //分享View
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;      //微信按钮
@property (weak, nonatomic) IBOutlet UIButton *pengyouquanBtn; //朋友圈按钮
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;          //qq按钮
@property (weak, nonatomic) IBOutlet UIButton *qqkongjianBtn;  //qq空间按钮
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;       //微博按钮
@property (weak, nonatomic) IBOutlet UIButton *duanxiaoxiBtn;  //短消息按钮
@property (weak, nonatomic) IBOutlet UIButton *fuzhilianjieBtn;//复制链接按钮
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;     //微信标签
@property (weak, nonatomic) IBOutlet UILabel *pengyouquanLabel;//朋友圈标签
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;         //qq标签
@property (weak, nonatomic) IBOutlet UILabel *qqkongjianLabel; //qq空间标签
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;      //微博标签
@property (weak, nonatomic) IBOutlet UILabel *duanxiaoxiLabel; //短消息标签
@property (weak, nonatomic) IBOutlet UILabel *fuzhilianjieLabel;//复制链接标签
@property (strong, nonatomic) IBOutlet UIView *openPhotoView;   //打开相册视图
@property (weak, nonatomic) IBOutlet EGOImageView *backGroundImageView; //背景图片

//@property (weak, nonatomic) IBOutlet EGOImageView *bannerImageView; //头像背景图
//
//@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像

@property (weak, nonatomic) IBOutlet UIImageView *levleImageView;   //级别背景
//@property (weak, nonatomic) UILabel *levelLabel;           //级别
//@property (weak, nonatomic) IBOutlet UILabel *userName;             //用户名
@property (weak, nonatomic) IBOutlet UIImageView *jiangPaiImageView; //奖牌图片
@property (weak, nonatomic) IBOutlet UILabel *daRenLabel;            //达人标签
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;        //位置标签

@property (weak, nonatomic) IBOutlet EGOImageView *bigPersonImageView; //个人大头像
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;          //个性签名标签

@property (nonatomic, strong) ImageWaterView *waterView;               //瀑布流视图

@property (weak, nonatomic) IBOutlet UIButton *publishBtn;             //去发布按钮
@property (weak, nonatomic) IBOutlet UILabel *noPublishLabel;          //未发布街拍标签


@property (weak, nonatomic) IBOutlet UITableView *totalTableView;      //总体TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;       //行一
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTwo;       //行二

@property (weak, nonatomic) IBOutlet UILabel *changePhotoLabel;        //更换头像或背景的描述label
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;                //粉丝按钮
//@property (weak, nonatomic) UIButton *guanzhuBtn;             //关注按钮


@property (nonatomic,strong) EGOImageView           *bannerImageView;
@property (nonatomic,strong) EGOImageView           *personImageView;

@property (nonatomic,strong) UILabel                *photoNum;
@property (nonatomic,strong) UIImageView            *levimg;
@property (nonatomic,strong) UILabel                *userName;
@property (nonatomic,strong) UILabel                *levelLabel;
@property (nonatomic,strong) UILabel                *countryLabel;
@property (nonatomic,strong) UIImageView            *personSex;  //个人资料的性别
@property (nonatomic,strong) UILabel                *personSignLabel;
@property (nonatomic,strong) UIImageView            *numberView;
@property (nonatomic,strong) UILabel                *doorNum;
//@property (nonatomic,strong) UILabel                *photoNum;
@property (nonatomic,strong) UILabel                *labelNum;
@property (nonatomic,strong) UILabel                *followNum;
@property (nonatomic,strong) UILabel                *fansNum;
@property (nonatomic,strong) UIButton               *guanzhuBtn;

@end
