//
//  NewMainPersonVC.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "NewMainPersonVC.h"

#define HEAD_HEIGHT 300

@interface NewMainPersonVC () <UITableViewDelegate, UITableViewDataSource>
{
    GetUserInfo *userInfo; //用户信息
    int currentPageNum;    //当前页码
    NSMutableArray *dataArray;  //数据数组
    //    NSMutableArray *arrayImage; //图片数据
    NSMutableArray *totalDataArray; //图片数据
    
    TencentOAuth *_tencentOAuth;      //qq分享
    BOOL personImageOrBackImageClick; //点击个人头像或背景图标记 YES:个人头像 NO:背景图片
    NSMutableArray *streetListArray;  //街拍列表数组
    int pageNum;               //当前页码
    //    NSMutableArray *arrayImage;       //瀑布流图片数组
    NSMutableArray *totalArray;  //街拍数组
}

@property (nonatomic,strong) UITableView            *tableView;
@property (nonatomic,strong) UIView                 *headView;
@property (nonatomic,strong) EGOImageView           *bannerImageView;
@property (nonatomic,strong) EGOImageView           *personImageView;
@property (nonatomic,strong) UIButton               *backButton;
@property (nonatomic,strong) UIButton               *moreButton;
@property (nonatomic,strong) UILabel                *userName;
@property (nonatomic,strong) UIImageView            *levimg;
@property (nonatomic,strong) UILabel                *levelLabel;
@property (nonatomic,strong) UILabel                *countryLabel;
@property (nonatomic,strong) UILabel                *personSignLabel;
@property (nonatomic,strong) UIImageView            *numberView;
@property (nonatomic,strong) UILabel                *doorNum;
@property (nonatomic,strong) UILabel                *photoNum;
@property (nonatomic,strong) UILabel                *labelNum;
@property (nonatomic,strong) UILabel                *followNum;
@property (nonatomic,strong) UILabel                *fansNum;
@property (nonatomic,strong) UIButton               *guanzhuBtn;

@property (nonatomic,strong) UIView                 *shareView;
@property (nonatomic,strong) UIButton               *weixinBtn;      //微信按钮
@property (nonatomic,strong) UIButton               *pengyouquanBtn; //朋友圈按钮
@property (nonatomic,strong) UIButton               *qqBtn;          //qq按钮
@property (nonatomic,strong) UIButton               *qqkongjianBtn;  //qq空间按钮
@property (nonatomic,strong) UIButton               *weiboBtn;       //微博按钮
@property (nonatomic,strong) UIButton               *duanxiaoxiBtn;  //短消息按钮
@property (nonatomic,strong) UIButton               *fuzhilianjieBtn;//复制链接按钮


@end

@implementation NewMainPersonVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, 30, 20, 18);
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"return9-0"]];
    back.frame = CGRectMake(0, 0, 10, 18);
    [_backButton addSubview:back];
    [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(SCREENWIDTH - 40, 40, 60, 20);
    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more9-0"]];
    more.frame = CGRectMake(0, 8, 23, 4);
    [_moreButton addSubview:more];
    [_moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self reqProxy];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shareView];
}

-(void)reqProxy{
    currentPageNum = 1;
    
    [GetUserInfoInput shareInstance].userId = _userId;
    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            userInfo = [[GetUserInfo alloc] initWithDict:responseDict];
            _personImageView.imageURL = [CustomUtil getPhotoURL:userInfo.image];
            [CustomUtil setImageViewCorner:_personImageView];
            _bannerImageView.imageURL = [CustomUtil getPhotoURL:userInfo.backgroundImage];
            _levelLabel.text = [NSString stringWithFormat:@"LV%@", userInfo.userLevel];
            _userName.text = userInfo.userName;
            CGSize userSize = [_userName.text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] maxSize:CGSizeMake(SCREENWIDTH - 110,15)];
            _userName.frame = CGRectMake(_userName.frame.origin.x, _userName.frame.origin.y, userSize.width, 40);
            _levimg.frame = CGRectMake(_userName.frame.origin.x + _userName.frame.size.width + 5, _userName.frame.origin.y + (40-17) / 2, 33, 17);
            _fansNum.text = userInfo.fansNum;
            _followNum.text =  userInfo.followNum;
            _doorNum.text = [NSString stringWithFormat:@"门牌号：%@", userInfo.userDoorId];
            CGSize doorSize = [_doorNum.text sizeWithFont:[UIFont systemFontOfSize:13.0f] maxSize:CGSizeMake(SCREENWIDTH, 14)];

            CGRect rect1 = _numberView.frame;
            rect1.size.width = doorSize.width + 20;
            rect1.size.height = doorSize.height + 10;
            _numberView.frame = rect1;
            _doorNum.frame = CGRectMake(10, 0, doorSize.width, doorSize.height + 10);
            
            if ([userInfo.country isEqualToString:@"中国"]) {
                NSString *provinceStr = userInfo.province;
                if ([provinceStr isEqualToString:@"香港特别行政区"] ||
                    [provinceStr isEqualToString:@"澳门特别行政区"] ||
                    [provinceStr isEqualToString:@"台湾"]) {
                    provinceStr = @"";
                }
                _countryLabel.text = [NSString stringWithFormat:@"%@ %@", provinceStr, userInfo.city];
            } else {
                NSString *provinceStr = userInfo.province;
                if ([provinceStr isEqualToString:@"香港特别行政区"] ||
                    [provinceStr isEqualToString:@"澳门特别行政区"] ||
                    [provinceStr isEqualToString:@"台湾"]) {
                    provinceStr = @"";
                }
                _countryLabel.text = [NSString stringWithFormat:@"%@ %@ %@", userInfo.country, provinceStr, userInfo.city];
            }
            //设置个性签名
            [self.personSignLabel setText:userInfo.userSign];
            
            //设置关注按钮
            if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
                [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                [_guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
    
    [[NetInterface shareInstance] requestNetWork:@"maoxj/streetsnap/manager/countUserTagForDistinct" param:dict successBlock:^(NSDictionary *responseDict) {
        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            _labelNum.text = [responseDict objectForKey:@"data"];
        }
        else{
            [CustomUtil showToastWithText:@"网络不给力，请稍后重试" view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark - GET&SET
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -10, SCREENWIDTH, SCREENHEIGHT + 20) style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [_tableView addSubview:self.headView];
        [_tableView setContentInset:UIEdgeInsetsMake(HEAD_HEIGHT, 0, 0, 0)];
//        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -HEAD_HEIGHT, SCREENWIDTH, HEAD_HEIGHT)];
        UITapGestureRecognizer *imageGestureview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headBackPhotoBtnClick)];
        [_headView setUserInteractionEnabled:YES];
        [_headView addGestureRecognizer:imageGestureview];
        
        _bannerImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, -HEAD_HEIGHT, SCREENWIDTH, HEAD_HEIGHT)];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_tableView addSubview:_bannerImageView];
        
        UIImageView * _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -50, SCREENWIDTH, 50)];
        _coverImageView.userInteractionEnabled = YES;
        UIImage *image =[UIImage imageNamed:@"mengban"];//原图
        _coverImageView.image = image;
        [_tableView addSubview:_coverImageView];
        
        
        int count = 3;
        
        CGFloat button_width = SCREENWIDTH / count;

//        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        photoBtn.frame = CGRectMake(0, _headView.frame.size.height - 50, SCREENWIDTH / 4, 50);
        labelBtn.frame = CGRectMake(button_width * 0, _headView.frame.size.height - 50, button_width, 50);
        followBtn.frame = CGRectMake(button_width * 1, _headView.frame.size.height - 50, button_width, 50);
        fansBtn.frame = CGRectMake(button_width * 2, _headView.frame.size.height - 50, button_width, 50);
//        UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 4, 50)];
//        _photoNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 4, 25)];
//        _photoNum.text = @"";
//        _photoNum.font = [UIFont systemFontOfSize:16.0f];
//        _photoNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
//        _photoNum.textAlignment = NSTextAlignmentCenter;
//        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_photoNum), SCREENWIDTH / 4, GetHeight(photoBtn) - GetHeight(_photoNum) - 5)];
//        photoLabel.text = @"照片";
//        photoLabel.font = [UIFont systemFontOfSize:12.0f];
//        photoLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
//        photoLabel.textAlignment = NSTextAlignmentCenter;
//        [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [photoView addSubview:_photoNum];
//        [photoView addSubview:photoLabel];
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetWidth(labelBtn), 50)];
        _labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GetWidth(labelBtn), 25)];
        _labelNum.text = @"";
        _labelNum.font = [UIFont systemFontOfSize:16.0f];
        _labelNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        UILabel *leLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_labelNum), GetWidth(labelBtn), GetHeight(labelBtn) - GetHeight(_labelNum) - 5)];
        leLabel.text = @"标签";
        leLabel.font = [UIFont systemFontOfSize:12.0f];
        leLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        leLabel.textAlignment = NSTextAlignmentCenter;
        [labelBtn addTarget:self action:@selector(labelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [labelView addSubview:_labelNum];
        [labelView addSubview:leLabel];
        UIView *followView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetWidth(followBtn), 50)];
        _followNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GetWidth(followBtn), 25)];
        _followNum.text = @"";
        _followNum.font = [UIFont systemFontOfSize:16.0f];
        _followNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _followNum.textAlignment = NSTextAlignmentCenter;
        UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_followNum), GetWidth(followBtn), GetHeight(followBtn) - GetHeight(_followNum) - 5)];
        followLabel.text = @"关注";
        followLabel.font = [UIFont systemFontOfSize:12.0f];
        followLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        followLabel.textAlignment = NSTextAlignmentCenter;
        [followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [followView addSubview:_followNum];
        [followView addSubview:followLabel];
        UIView *fansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetWidth(fansBtn), 50)];
        _fansNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GetWidth(fansBtn), 25)];
        _fansNum.text = @"";
        _fansNum.font = [UIFont systemFontOfSize:16.0f];
        _fansNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _fansNum.textAlignment = NSTextAlignmentCenter;
        UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_fansNum), GetWidth(fansBtn), GetHeight(fansBtn) - GetHeight(_fansNum) - 5)];
        fansLabel.text = @"粉丝";
        fansLabel.font = [UIFont systemFontOfSize:12.0f];
        fansLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        fansLabel.textAlignment = NSTextAlignmentCenter;
        [fansBtn addTarget:self action:@selector(fansBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [fansView addSubview:_fansNum];
        [fansView addSubview:fansLabel];
        
//        [photoBtn addSubview:photoView];
        [labelBtn addSubview:labelView];
        [followBtn addSubview:followView];
        [fansBtn addSubview:fansView];
//        [_headView addSubview:photoBtn];
        [_headView addSubview:labelBtn];
        [_headView addSubview:followBtn];
        [_headView addSubview:fansBtn];
        
        for (int i = 0; i < count; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button_width * i, GetY(followBtn) + (50 - 30) / 2, 0.5, 30)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#bebec2"];
            [_headView addSubview:lineView];
        }
        
        _personSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, GetHeight(_headView) - 50 - 10 - 35, SCREENWIDTH * 0.7, 35)];
        _personSignLabel.textColor = [UIColor whiteColor];
        _personSignLabel.font = [UIFont systemFontOfSize:12.0f];
        _personSignLabel.numberOfLines = 2;
        _personSignLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
        [_headView addSubview:_personSignLabel];
        
        NSString *doorStr = @"门牌号：";
        CGSize doorSize = [doorStr sizeWithFont:[UIFont systemFontOfSize:13.0f] maxSize:CGSizeMake(SCREENWIDTH, 14)];
        _numberView = [[UIImageView alloc] initWithFrame:CGRectMake(20, GetHeight(_headView) - 50 - 10 - 35 - 10 - (doorSize.height + 10), doorSize.width + 30, doorSize.height + 10)];
        UIImage *img = [UIImage imageNamed:@"door"];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        img = [img resizableImageWithCapInsets:insets];
        _numberView.image = img;
        _doorNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, doorSize.width, doorSize.height + 10)];
        _doorNum.text = doorStr;
        _doorNum.textColor = [UIColor whiteColor];
        _doorNum.font = [UIFont systemFontOfSize:13.0f];
        [_numberView addSubview:_doorNum];
        [_headView addSubview:_numberView];

        _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, GetY(_numberView) - 30, SCREENHEIGHT - 20, 30)];
        _countryLabel.font = [UIFont systemFontOfSize:13.0f];
        _countryLabel.textColor = [UIColor whiteColor];
        _countryLabel.text = @"";
        [_headView addSubview:_countryLabel];

        _personImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(20, 70, 40, 40)];
        _personImageView.layer.masksToBounds = YES;
        _personImageView.layer.cornerRadius = 20;
        _personImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
        UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPhotoBtnClick)];
        [_personImageView setUserInteractionEnabled:YES];
        [_personImageView addGestureRecognizer:imageGesture];
        [_headView addSubview:_personImageView];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 80, 40)];
        _userName.font = [UIFont boldSystemFontOfSize:18.0f];
        _userName.textColor = [UIColor whiteColor];
        _userName.text = @"";
        [_headView addSubview:_userName];
        
        _levimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengjimain"]];
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 33, 17)];
        _levelLabel.text = @"";
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.textColor = [UIColor yellowColor];
        _levelLabel.font = [UIFont italicSystemFontOfSize:10.0f];
        [_levimg addSubview:_levelLabel];
        [_headView addSubview:_levimg];
        
        if (_type == 1) {
            _guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _guanzhuBtn.frame = CGRectMake(SCREENWIDTH - 57, _headView.frame.size.height - 87, 57, 27);
            [_guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            _guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            _guanzhuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [_headView addSubview:_guanzhuBtn];
            
            UIButton *siliao = [UIButton buttonWithType:UIButtonTypeCustom];
            siliao.frame = CGRectMake(SCREENWIDTH - 57, _headView.frame.size.height - 124, 57, 27);
            [siliao setBackgroundImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
            [siliao setTitle:@"私聊" forState:UIControlStateNormal];
            siliao.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            siliao.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [_headView addSubview:siliao];
        }
        
    }
    return _headView;
}

-(UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _shareView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        _shareView.hidden = YES;
        
        UIView *share = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 194, SCREENWIDTH, 194)];
        share.backgroundColor = [UIColor whiteColor];
        [_shareView addSubview:share];
        
        CGFloat x = (SCREENWIDTH - 180) / 5;
        _weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinBtn.frame = CGRectMake(x, 10, 45, 60);
        UIImageView *imgweixin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgweixin.image = [UIImage imageNamed:@"weixn9_1"];
        UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 15)];
        weixinLabel.text = @"微信";
        weixinLabel.textAlignment = NSTextAlignmentCenter;
        weixinLabel.font = [UIFont systemFontOfSize:13.0f];
        [_weixinBtn addTarget:self action:@selector(weixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_weixinBtn addSubview:weixinLabel];
        [_weixinBtn addSubview:imgweixin];
        [share addSubview:_weixinBtn];
        _pengyouquanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pengyouquanBtn.frame = CGRectMake(x * 2 + 45, 10, 45, 60);
        UIImageView *imgpengyou = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgpengyou.image = [UIImage imageNamed:@"pengyq9_1"];
        UILabel *pengyouLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 15)];
        pengyouLabel.text = @"朋友圈";
        pengyouLabel.textAlignment = NSTextAlignmentCenter;
        pengyouLabel.font = [UIFont systemFontOfSize:13.0f];
        [_pengyouquanBtn addTarget:self action:@selector(pengyouqBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pengyouquanBtn addSubview:pengyouLabel];
        [_pengyouquanBtn addSubview:imgpengyou];
        [share addSubview:_pengyouquanBtn];
        _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqBtn.frame = CGRectMake(x * 3 + 90, 10, 45, 60);
        UIImageView *imgqq = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgqq.image = [UIImage imageNamed:@"qq9_1"];
        UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 15)];
        qqLabel.text = @"QQ";
        qqLabel.textAlignment = NSTextAlignmentCenter;
        qqLabel.font = [UIFont systemFontOfSize:13.0f];
        [_qqBtn addTarget:self action:@selector(qqBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_qqBtn addSubview:qqLabel];
        [_qqBtn addSubview:imgqq];
        [share addSubview:_qqBtn];
        _qqkongjianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqkongjianBtn.frame = CGRectMake(x * 4 + 135, 10, 45, 60);
        UIImageView *imgkongjian = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgkongjian.image = [UIImage imageNamed:@"kongjian9_1"];
        UILabel *kongjianLabel = [[UILabel alloc] initWithFrame:CGRectMake(-7.5, 45, 60, 15)];
        kongjianLabel.text = @"QQ空间";
        kongjianLabel.textAlignment = NSTextAlignmentCenter;
        kongjianLabel.font = [UIFont systemFontOfSize:13.0f];
        [_qqkongjianBtn addTarget:self action:@selector(qqKongJianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_qqkongjianBtn addSubview:kongjianLabel];
        [_qqkongjianBtn addSubview:imgkongjian];
        [share addSubview:_qqkongjianBtn];
        _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiboBtn.frame = CGRectMake(x, 80, 45, 60);
        UIImageView *imgweibo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgweibo.image = [UIImage imageNamed:@"weibo9_1"];
        UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 15)];
        weiboLabel.text = @"微博";
        weiboLabel.textAlignment = NSTextAlignmentCenter;
        weiboLabel.font = [UIFont systemFontOfSize:13.0f];
        [_weiboBtn addTarget:self action:@selector(weiboBtnClickj:) forControlEvents:UIControlEventTouchUpInside];
        [_weiboBtn addSubview:weiboLabel];
        [_weiboBtn addSubview:imgweibo];
        [share addSubview:_weiboBtn];
        _duanxiaoxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _duanxiaoxiBtn.frame = CGRectMake(x * 2 + 45, 80, 45, 60);
        UIImageView *imgduanxin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgduanxin.image = [UIImage imageNamed:@"duanxx9_1"];
        UILabel *duanxinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 15)];
        duanxinLabel.text = @"短信";
        duanxinLabel.textAlignment = NSTextAlignmentCenter;
        duanxinLabel.font = [UIFont systemFontOfSize:13.0f];
        [_duanxiaoxiBtn addTarget:self action:@selector(duanxxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_duanxiaoxiBtn addSubview:duanxinLabel];
        [_duanxiaoxiBtn addSubview:imgduanxin];
        [share addSubview:_duanxiaoxiBtn];
        _fuzhilianjieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fuzhilianjieBtn.frame = CGRectMake(x * 3 + 90, 80, 45, 60);
        UIImageView *imgfuzhi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imgfuzhi.image = [UIImage imageNamed:@"lianjie9_1"];
        UILabel *fuzhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(-7.5, 45, 60, 15)];
        fuzhiLabel.text = @"复制链接";
        fuzhiLabel.textAlignment = NSTextAlignmentCenter;
        fuzhiLabel.font = [UIFont systemFontOfSize:13.0f];
        [_fuzhilianjieBtn addTarget:self action:@selector(fuzhiLianJieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fuzhilianjieBtn addSubview:fuzhiLabel];
        [_fuzhilianjieBtn addSubview:imgfuzhi];
        [share addSubview:_fuzhilianjieBtn];
        
        UIButton *cancelShare = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelShare.frame = CGRectMake(0, share.frame.size.height - 44, SCREENWIDTH, 44);
        cancelShare.backgroundColor = [UIColor grayColor];
        [cancelShare setTitle:@"取消" forState:UIControlStateNormal];
        cancelShare.titleLabel.textColor = [UIColor whiteColor];
        [cancelShare addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
        [share addSubview:cancelShare];
    }
    return _shareView;
}

#pragma mark -分享按钮的点击事件
//微信按钮
- (IBAction)weixinBtnClick:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil weixinLogin:self shareFlag:YES personOrZone:YES inviteUser:NO image:[CustomUtil getShareImage:SHARE_IMAGE] shareContent:SHARE_TEXT_NO_URL];
}

//朋友圈
- (IBAction)pengyouqBtnClick:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil weixinLogin:self shareFlag:YES personOrZone:NO inviteUser:NO image:[CustomUtil getShareImage:SHARE_IMAGE] shareContent:SHARE_TEXT_NO_URL];
}

//qq
- (IBAction)qqBtnClick:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil qqLogin:YES personOrZone:YES inviteUser:NO imagePath:SHARE_IMAGE shareContent:SHARE_TEXT_NO_URL];
}

//qq空间
- (IBAction)qqKongJianBtnClick:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil qqLogin:YES personOrZone:NO inviteUser:NO imagePath:SHARE_IMAGE shareContent:SHARE_TEXT_NO_URL];
}

//微博
- (IBAction)weiboBtnClickj:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil sinaLogin:YES viewCtrl:@"MyStreetPhotoViewController" personOrZone:NO inviteUser:NO imagePath:SHARE_IMAGE shareContent:SHARE_TEXT_NO_URL];
}

//短消息
- (IBAction)duanxxBtnClick:(id)sender {
    [_shareView setHidden:YES];
    [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
        [CustomUtil shareInstance].viewCtrl = self;
        [CustomUtil sendSMS:self bodyMesage:SHARE_TEXT recipientList:nil];
    }];
}

//复制链接
- (IBAction)fuzhiLianJieBtnClick:(id)sender {
    [_shareView setHidden:YES];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
        pasteboard.string = returnStr;
    }];
    [CustomUtil showToastWithText:@"链接已复制" view:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Action
//返回按钮点击事件
- (void)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更多
- (void)moreBtnClick:(id)sender {
    if (_type == 0) {
        self.shareView.hidden = NO;
    }
    else {
        return;
    }
}

//分享取消
- (void)cancelShare{
    self.shareView.hidden = YES;
}

//头像
- (void)headPhotoBtnClick{
    return;
}

//头部背景
- (void)headBackPhotoBtnClick{
    return;
}

//照片
- (void)photoBtnClick{
    return;
}

//标签
- (void)labelBtnClick{
    return;
}

//关注
- (void)followBtnClick{
    return;
}

//粉丝
- (void)fansBtnClick{
    return;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat offsetX = (offsetY + HEAD_HEIGHT) / 2;

    if (offsetY < -HEAD_HEIGHT) {
        CGRect rect = _bannerImageView.frame;
        rect.origin.y = offsetY;
        rect.size.height =  - offsetY ;
        rect.origin.x = offsetX;
        rect.size.width = _headView.frame.size.width + fabs(offsetX) * 2;
        
        _bannerImageView.frame = rect;
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
