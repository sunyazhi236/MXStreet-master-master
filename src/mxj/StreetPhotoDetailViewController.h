//
//  StreetPhotoDetailViewController.h
//  mxj
//  P7-4街拍详情
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface StreetPhotoDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate, UserImageViewClickProtocol, DeleteCommentBtnClickDelegate, WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;  //详情TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;    //首行Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;   //图片Cell
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;       //评论TextView
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;   //照片ScrollView
@property (weak, nonatomic) IBOutlet UIPageControl *photoControl;     //照片指示器
@property (assign, nonatomic) BOOL intoFlag;  //入口标记 YES:发布进入 NO:其它页面进入
@property (weak, nonatomic) IBOutlet UIView *footView; //底部输入视图
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel; //placeholder用label

@property (nonatomic, copy) NSString *streetsnapId; //街拍Id
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView;   //个人头像
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;        //个人名称
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;       //发布时间
@property (weak, nonatomic) IBOutlet UILabel *publichLocationLabel;   //发布位置（城市）
@property (weak, nonatomic) IBOutlet UIImageView *publishLocationImageView; //位置图标
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;          //发布位置（详细地址）
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;  //位置图标

@property (weak, nonatomic) IBOutlet UITextView *publishContextLabel;    //发布内容
@property (weak, nonatomic) UIButton *zanBtn;                //赞按钮
@property (weak, nonatomic) UIButton *collectionBtn;         //收藏按钮
@property (weak, nonatomic) UIButton *shareBtn;              //分享按钮

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;      //点赞按钮下的分割线
@property (strong, nonatomic) UIView *zanView;                 //点赞按钮View

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;                //发送按钮

@property (strong, nonatomic) IBOutlet UIView *shareView;              //分享视图
@property (weak, nonatomic) IBOutlet UIButton *_weixinBtn;             //微信按钮
@property (weak, nonatomic) IBOutlet UIButton *pengyouquanBtn;         //朋友圈按钮
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;                  //qq按钮
@property (weak, nonatomic) IBOutlet UIButton *qqKongjianBtn;          //qq空间按钮
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;               //微博按钮
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;             //微信标签
@property (weak, nonatomic) IBOutlet UILabel *pengyouquanLabel;        //朋友圈标签
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;                 //qq标签
@property (weak, nonatomic) IBOutlet UILabel *qqKongjianLabel;         //qq空间标签
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;              //微博标签

@property (strong, nonatomic) UIView *zanAnimationView;                //点赞动画view

@property (strong, nonatomic) UIImageView *zanAnimationImageView;      //点赞动画+1图片

@property (strong, nonatomic) UIView *rewardBackView;                  //获取点赞列表的背景

@property (strong, nonatomic) UIView *rewardBackView2;                 //获取点赞列表的背景

@property (assign, nonatomic) NSInteger rewardCount;                   //打赏的count

@property (assign, nonatomic) BOOL isRewardEdit;                        //打赏的count

@property (strong, nonatomic) NSDictionary *rewardDictionary;           //打赏的数据源

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) UITextField *rewardTextFeild;

@end
