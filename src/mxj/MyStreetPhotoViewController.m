//
//  MyStreetPhotoViewController.m
//  mxj
//  P9-1我的街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MyStreetPhotoViewController.h"
#import "MeFansViewController.h"
#import "ConcernManViewController.h"
#import "PublishStreetPhotoViewController.h"
#import "PersonDocViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "SendPrivateMessageViewController.h"
#import "LabelPhotoViewController.h"
#import "LabelMainViewController.h"

#define HEAD_HEIGHT 300

#define CELL_OFFSET 10

#define CELL_HEADER_HEIGHT 54

@interface MyStreetPhotoViewController () <UIActionSheetDelegate, imageViewClickDelegate>
{
    TencentOAuth *_tencentOAuth;      //qq分享
    BOOL personImageOrBackImageClick; //点击个人头像或背景图标记 YES:个人头像 NO:背景图片
    NSMutableArray *streetListArray;  //街拍列表数组
    int pageNum;               //当前页码
    NSMutableArray *totalArray;  //街拍数组
    
    GetUserInfo *userInfo;
    
    BOOL isLoading;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIButton               *backButton;

@property (nonatomic,strong) UIButton               *moreButton;

@property (nonatomic,strong) UIButton               *siliaoBtn;

@end

@implementation MyStreetPhotoViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [_shareView setHidden:YES];
    
}

- (NSString *)userId
{
    if (!_userId) {
        _userId = [LoginModel shareInstance].userId;
    }
    return _userId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
//    [_bannerImageView setUserInteractionEnabled:YES];
//    [_bannerImageView addGestureRecognizer:gesture];
//    UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPhotoBtnClick)];
//    [_personImageView setUserInteractionEnabled:YES];
//    [_personImageView addGestureRecognizer:imageGesture];
    streetListArray = [[NSMutableArray alloc] init];
    totalArray = [[NSMutableArray alloc] init];
    
    
//    _totalTableView.delegate = self;
//    _totalTableView.dataSource = self;

    
    [self.view addSubview:self.tableView];
    
    [self initNavigationButton];
    pageNum = 1;
    [self reqProxy];
}

- (void)initNavigationButton
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 50, 64);
    [_backButton setImage:[UIImage imageNamed:@"return9-0"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(SCREENWIDTH - 60, 0, 60, 64);
    [_moreButton setImage:[UIImage imageNamed:@"more9-0"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
//        [_tableView addSubview:self.headView];
//        _tableView.tableHeaderView = self.headView;
//        [_tableView setContentInset:UIEdgeInsetsMake(HEAD_HEIGHT, 0, 0, 0)];
        //        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEAD_HEIGHT)];
        UITapGestureRecognizer *imageGestureview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
        [_headView setUserInteractionEnabled:YES];
        [_headView addGestureRecognizer:imageGestureview];
        
//        UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        headButton.frame = CGRectMake(0, 64, SCREENWIDTH, HEAD_HEIGHT - 50 - 64);
//        [headButton addTarget:self action:@selector(backImageClick) forControlEvents:UIControlEventTouchUpInside];
//        [_headView addSubview:headButton];
        
        _bannerImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEAD_HEIGHT)];
        _bannerImageView.contentMode = UIViewContentModeScaleToFill;
        _bannerImageView.userInteractionEnabled = YES;
        _bannerImageView.placeholderImage = [UIImage imageNamed:@"个人主页默认背景图"];
        [_headView addSubview:_bannerImageView];
        
        UIImageView * _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEAD_HEIGHT)];
        _coverImageView.userInteractionEnabled = YES;
        UIImage *image =[UIImage imageNamed:@"个人主页蒙版"];//原图
        _coverImageView.image = image;
        [_headView addSubview:_coverImageView];
        
        int count = 4;
        
        CGFloat button_width = SCREENWIDTH / count;

        CGFloat button_y = _headView.frame.size.height - 50;

        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, button_y, button_width, 50)];
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(button_width * 1, button_y, button_width, 50)];
        UIView *followView = [[UIView alloc] initWithFrame:CGRectMake(button_width * 2, button_y, button_width, 50)];
        UIView *fansView = [[UIView alloc] initWithFrame:CGRectMake(button_width * 3, button_y, button_width, 50)];

        photoBtn.frame = CGRectMake(0, 0, button_width, 50);
        labelBtn.frame = CGRectMake(0, 0, button_width, 50);
        followBtn.frame = CGRectMake(0, 0, button_width, 50);
        fansBtn.frame = CGRectMake(0, 0, button_width, 50);
        
        _photoNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button_width, 25)];
        _photoNum.text = @"0";
        _photoNum.font = [UIFont systemFontOfSize:16.0f];
        _photoNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _photoNum.textAlignment = NSTextAlignmentCenter;
        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_photoNum), SCREENWIDTH / 4, GetHeight(photoView) - GetHeight(_photoNum) - 5)];
        photoLabel.text = @"照片";
        photoLabel.font = [UIFont systemFontOfSize:12.0f];
        photoLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        photoLabel.textAlignment = NSTextAlignmentCenter;
        [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];

        _labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button_width, 25)];
        _labelNum.text = @"0";
        _labelNum.font = [UIFont systemFontOfSize:16.0f];
        _labelNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        UILabel *leLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_labelNum), button_width, GetHeight(labelView) - GetHeight(_labelNum) - 5)];
        leLabel.text = @"标签";
        leLabel.font = [UIFont systemFontOfSize:12.0f];
        leLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        leLabel.textAlignment = NSTextAlignmentCenter;
        [labelBtn addTarget:self action:@selector(labelBtnClick) forControlEvents:UIControlEventTouchUpInside];

        _followNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button_width, 25)];
        _followNum.text = @"0";
        _followNum.font = [UIFont systemFontOfSize:16.0f];
        _followNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _followNum.textAlignment = NSTextAlignmentCenter;
        UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_followNum), GetWidth(followBtn), GetHeight(followView) - GetHeight(_followNum) - 5)];
        followLabel.text = @"关注";
        followLabel.font = [UIFont systemFontOfSize:12.0f];
        followLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        followLabel.textAlignment = NSTextAlignmentCenter;
        [followBtn addTarget:self action:@selector(guanZhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        _fansNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button_width, 25)];
        _fansNum.text = @"0";
        _fansNum.font = [UIFont systemFontOfSize:16.0f];
        _fansNum.textColor = [UIColor colorWithHexString:@"#f0eff5"];
        _fansNum.textAlignment = NSTextAlignmentCenter;
        UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetHeight(_fansNum), button_width, GetHeight(fansView) - GetHeight(_fansNum) - 5)];
        fansLabel.text = @"粉丝";
        fansLabel.font = [UIFont systemFontOfSize:12.0f];
        fansLabel.textColor = [UIColor colorWithHexString:@"#bebec2"];
        fansLabel.textAlignment = NSTextAlignmentCenter;
        [fansBtn addTarget:self action:@selector(fenSiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView addSubview:photoView];
        [_headView addSubview:labelView];
        [_headView addSubview:followView];
        [_headView addSubview:fansView];

        [photoView addSubview:photoBtn];
        [labelView addSubview:labelBtn];
        [followView addSubview:followBtn];
        [fansView addSubview:fansBtn];
        
        [photoView addSubview:_photoNum];
        [photoView addSubview:photoLabel];
        
        [labelView addSubview:_labelNum];
        [labelView addSubview:leLabel];
        
        [followView addSubview:_followNum];
        [followView addSubview:followLabel];
        
        [fansView addSubview:_fansNum];
        [fansView addSubview:fansLabel];
        
        for (int i = 0; i < count; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button_width * i, button_y + (50 - 30) / 2, 0.5, 30)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#bebec2"];
            [_headView addSubview:lineView];
        }
        
        _personSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, GetHeight(_headView) - 50 - 10 - 35, SCREENWIDTH * 0.7, 35)];
        _personSignLabel.textColor = [UIColor whiteColor];
        _personSignLabel.font = [UIFont systemFontOfSize:12.0f];
        _personSignLabel.numberOfLines = 2;
        _personSignLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
        [_headView addSubview:_personSignLabel];
        
        NSString *doorStr = @"门牌号：";
        CGSize doorSize = [doorStr sizeWithFont:[UIFont systemFontOfSize:13.0f] maxSize:CGSizeMake(SCREENWIDTH, 14)];
        UIImage *img = [UIImage imageNamed:@"door"];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        img = [img resizableImageWithCapInsets:insets];

        _numberView = [[UIImageView alloc] initWithFrame:CGRectMake(20, GetHeight(_headView) - 50 - 10 - 35 - 10 - (doorSize.height ), doorSize.width + 30, doorSize.height + 10)];
        _numberView.image = img;
        _doorNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, doorSize.width, doorSize.height + 10)];
        _doorNum.text = doorStr;
        _doorNum.textColor = [UIColor whiteColor];
        _doorNum.font = [UIFont systemFontOfSize:13.0f];
        [_numberView addSubview:_doorNum];
        [_headView addSubview:_numberView];
        
        _personSex =[[UIImageView alloc]initWithFrame:CGRectMake(20,  GetY(_numberView) - 23, 15, 15)];
        _personSex.image=[UIImage imageNamed:@""];
        [_headView addSubview:_personSex];
        
        _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, GetY(_numberView) - 30, SCREENHEIGHT - 20, 30)];
        _countryLabel.font = [UIFont systemFontOfSize:13.0f];
        _countryLabel.textAlignment = NSTextAlignmentLeft;
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
            _guanzhuBtn.frame = CGRectMake(SCREENWIDTH - 57, _headView.frame.size.height - 122, 57, 27);
            [_guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            _guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            _guanzhuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [_headView addSubview:_guanzhuBtn];
            [_guanzhuBtn addTarget:self action:@selector(guanzhuPerson:) forControlEvents:UIControlEventTouchUpInside];
            
            _siliaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _siliaoBtn.frame = self.guanzhuBtn.frame;
            [_siliaoBtn setBackgroundImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
            [_siliaoBtn setTitle:@"私聊" forState:UIControlStateNormal];
            _siliaoBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            _siliaoBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [_headView addSubview:_siliaoBtn];
            [_siliaoBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
                _guanzhuBtn.hidden = NO;
                _siliaoBtn.hidden = YES;
            } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                _guanzhuBtn.hidden = YES;
                _siliaoBtn.hidden = NO;
            }
        }
        
    }
    return _headView;
}

-(void)reqProxy{
    
    [GetUserInfoInput shareInstance].userId = self.userId;
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
            if ([userInfo.sex isEqualToString:@"男"]) {
                _personSex.image=[UIImage imageNamed:@"nan"];
            }if ([userInfo.sex isEqualToString:@"女"]) {
                _personSex.image=[UIImage imageNamed:@"nv"];
            }
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
                _guanzhuBtn.hidden = NO;
                _siliaoBtn.hidden = YES;
            } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                _guanzhuBtn.hidden = YES;
                _siliaoBtn.hidden = NO;
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
    
    [self reloadFirstPageData];
}

- (void)reloadFirstPageData
{
    pageNum = 1;
    
    __weak MyStreetPhotoViewController *blockSelf = self;
    
    //添加上拉加载更多
    __block NSMutableArray *dataSelf = streetListArray;
    
    //使用GCD开启一个线程，使圈圈转2秒
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [blockSelf reloadData:1 block:^(NSMutableArray *array) {

            if (!array) {
                return;
            }
            
            [dataSelf removeAllObjects];
            
            for (int i=0; i<[array count]; i++) {
                NSDictionary *dataD = [array objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [dataSelf addObject:imageInfo];
                }
            }
            if (_waterView) {
                [_waterView removeFromSuperview];
                _waterView = nil;
            }
            
            [blockSelf setSelfWaterView];

            [blockSelf.tableView reloadData];
        }];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载数据
-(void)reloadData:(int)currentPageNum block:(void(^)(NSMutableArray *array))block
{
    if (isLoading) {
        block(nil);
        return;
    }
    
    isLoading = YES;
    
    //获取街拍列表
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPageNum];
    [GetStreetsnapListInput shareInstance].userId = self.userId;
    [GetStreetsnapListInput shareInstance].type = @"0";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:dict successBlock:^(NSDictionary *responseDict) {
        isLoading = NO;
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];

        _photoNum.text = returnData.totalnum;
        
        if (RETURN_SUCCESS(returnData.status)) {
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
        isLoading = NO;
    }];
}

-(void)setSelfWaterView
{
    if (!_waterView) {
        self.waterView = [[ImageWaterView alloc] initWithDataArray:streetListArray withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intoFlag:0];
        if (_waterView.contentSize.height < _waterView.frame.size.height) {
            CGSize waterViewContentSize = _waterView.contentSize;
            waterViewContentSize.height = _waterView.frame.size.height;
            _waterView.contentSize = waterViewContentSize;
        }
        [self.waterView setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f]];
        self.waterView.imageViewClickDelegate = self;
        _waterView.delegate = self;
        
        _waterView.delegate = self;
        //添加刷新
        //添加加载更多
        __weak MyStreetPhotoViewController *blockSelf = self;
        __weak NSMutableArray *dataArraySelf = streetListArray;
        __block int currentPageNumSelf = pageNum;
        __weak ImageWaterView *waterViewSelf = _waterView;
        [blockSelf.waterView addPullToRefreshWithActionHandler:^{
            NSLog(@"下拉更新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                currentPageNumSelf = 1;
                [blockSelf reloadData:currentPageNumSelf block:^(NSMutableArray *info) {
                    //if ((info.count > 0) && ([((ImageInfo *)[arrayImageSelf objectAtIndexCheck:0]).thumbURL isEqualToString:[CustomUtil getPhotoURL:[[info objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString])) {
                    //  [blockSelf.waterView.pullToRefreshView stopAnimating];
                    // return;
                    //}
                    [dataArraySelf removeAllObjects];
                    
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    [array addObjectsFromArray:info];
                    for (int i=0; i<[array count]; i++) {
                        NSDictionary *dataD = [array objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [dataArraySelf addObject:imageInfo];
                        }
                    }
                    [waterViewSelf refreshView:dataArraySelf intoFlag:0];
                    if (waterViewSelf.contentSize.height < waterViewSelf.frame.size.height) {
                        CGSize size = waterViewSelf.contentSize;
                        size.height = waterViewSelf.frame.size.height;
                        waterViewSelf.contentSize = size;
                    }
                    [blockSelf.waterView.pullToRefreshView stopAnimating];
                }];
            });
        }];
        
        [blockSelf.waterView addInfiniteScrollingWithActionHandler:^{
            NSLog(@"上拉刷新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                currentPageNumSelf++;
                [blockSelf reloadData:currentPageNumSelf block:^(NSMutableArray *info) {
                    [dataArraySelf addObjectsFromArray:info];
                    NSMutableArray *imageArrayCopy = [[NSMutableArray alloc] init];
                    for (int i=0; i<[info count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [imageArrayCopy addObject:imageInfo];
                        }
                    }
                    [waterViewSelf loadNextPage:imageArrayCopy intoFlag:0];
                    if (waterViewSelf.contentSize.height < waterViewSelf.frame.size.height) {
                        CGSize size = waterViewSelf.contentSize;
                        size.height = waterViewSelf.frame.size.height;
                        waterViewSelf.contentSize = size;
                    }
                    [blockSelf.waterView.infiniteScrollingView stopAnimating];
                }];
            });
        }];
    }
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
//    return streetListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return HEAD_HEIGHT;
    }
    
    return SCREEN_HEIGHT;
    
//    return CELL_OFFSET + CELL_HEADER_HEIGHT + SCREENWIDTH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *cellId = [NSString stringWithFormat:@"cellId"];

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        [cell.contentView addSubview:self.headView];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (_waterView.contentSize.height < _waterView.firstView.frame.size.height) {
        CGSize waterViewContentSize = _waterView.contentSize;
        waterViewContentSize.height = _waterView.frame.size.height;
        _waterView.contentSize = waterViewContentSize;
    }
    [cell.contentView addSubview:_waterView];
    return cell;
    
//    NSString *cellId = [NSString stringWithFormat:@"cellId"];
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//
//    cell.backgroundColor = RGB(236, 236, 236, 1);
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    Info *info = [streetListArray objectAtIndexCheck:indexPath.row];
//    
//    if (!info) {
//        return nil;
//    }
//    
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_OFFSET, SCREENWIDTH, SCREENWIDTH + CELL_HEADER_HEIGHT)];
//    backgroundView.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:backgroundView];
//    
//    EGOImageView *userImageView = [[EGOImageView alloc] init];
//    userImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//    userImageView.userInteractionEnabled = YES;
//    userImageView.imageURL = [CustomUtil getPhotoURL:info.image];
//    userImageView.frame = CGRectMake(15, (CELL_HEADER_HEIGHT - 40) / 2, 40, 40);
//    [CustomUtil setImageViewCorner:userImageView];
//    [backgroundView addSubview:userImageView];
//    
//    CGSize titleSize = [@"姓名" sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREENWIDTH, 30)];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GetX(userImageView) + GetWidth(userImageView) + 9,  13, SCREENWIDTH - (GetX(userImageView) + GetWidth(userImageView) + 9), titleSize.height)];
//    titleLabel.text = info.userName;
//    titleLabel.font = FONT(14);
//    titleLabel.textColor = [UIColor blackColor];
//    [backgroundView addSubview:titleLabel];
//
//    CGFloat label_x = GetX(titleLabel);
//    
//    if (![CustomUtil CheckParam:info.publishTime]) {
//        CGSize size = [info.publishTime sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREENWIDTH, 30)];
//        
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label_x, GetY(titleLabel) + GetHeight(titleLabel) + 4, size.width, 15)];
//        label2.text = info.publishTime;
//        label2.font = FONT(12);
//        label2.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
//        [backgroundView addSubview:label2];
//    
//        label_x = label_x + size.width + 10;
//    }
//
//    
//    if (![CustomUtil CheckParam:info.city]) {
//        
//        UIImage *image = [UIImage imageNamed:@"位置"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(label_x, GetY(titleLabel) + GetHeight(titleLabel) + 4 + (15 - image.size.height) / 2, image.size.width, image.size.height);
//        [cell.contentView addSubview:imageView];
//        
//        label_x = label_x + image.size.width + 5;
//        
//        CGSize size = [info.city sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREENWIDTH, 30)];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(label_x, GetY(titleLabel) + GetHeight(titleLabel) + 4, size.width, 15)];
//        label.text = info.city;
//        label.font = FONT(12);
//        label.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
//        [backgroundView addSubview:label];
//    }
//
//    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, CELL_HEADER_HEIGHT, SCREENWIDTH, SCREENWIDTH)];
//    imageView.backgroundColor = [UIColor clearColor];
//    imageView.userInteractionEnabled = YES;
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    
//    if (![imageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:info.photo1].absoluteString]) {
////        imageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//        imageView.imageURL = [CustomUtil getPhotoURL:info.photo1];
//    }
//    [backgroundView addSubview:imageView];
//
//    
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return;// 暂时注释掉
//    
//    Info *info = [streetListArray objectAtIndexCheck:indexPath.row];
//    
//    if (!info) {
//        return;
//    }
//    
//    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
//    viewCtrl.intoFlag = NO;
//    viewCtrl.streetsnapId = info.streetsnapId;
//    [self.navigationController pushViewController:viewCtrl animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == _tableView) {
//        CGFloat offsetY = scrollView.contentOffset.y;
//        
//        CGFloat offsetX = (offsetY + HEAD_HEIGHT) / 2;
//        
//        if (offsetY < -HEAD_HEIGHT) {
//            CGRect rect = _bannerImageView.frame;
//            rect.origin.y = offsetY;
//            rect.size.height =  - offsetY ;
//            rect.origin.x = offsetX;
//            rect.size.width = _headView.frame.size.width + fabs(offsetX) * 2;
//            
//            _bannerImageView.frame = rect;
//        }
//        
//        if (offsetY < -HEAD_HEIGHT - 65) {
//            // 下拉刷新
//            if (!isLoading) {
//                [self reloadFirstPageData];
//            }
//        }
//    }
    if (_waterView == scrollView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *array = [_tableView indexPathsForVisibleRows];
        BOOL isDisplay = NO;
        for (NSIndexPath *object in array) {
            if ([path isEqual:object]) {
                isDisplay = YES;
            }
        }
        
        if (NO == isDisplay) {
            if (scrollView.contentOffset.y > 0) {
                return;
            } else {
                [_tableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
            }
        } else {
            if ((scrollView.contentOffset.y > 0) &&
                (_tableView.contentOffset.y <= HEAD_HEIGHT)) {
                if (scrollView.contentOffset.y > (HEAD_HEIGHT - _totalTableView.contentOffset.y)) {
                    [_tableView setContentOffset:CGPointMake(0, HEAD_HEIGHT) animated:NO];
                } else {
                    [_tableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
                }
            }
        }
        if (_tableView.contentOffset.y < 0) {
            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

#pragma mark -按钮点击事件处理
//返回按钮点击事件
- (void)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更多按钮点击事件
- (void)moreBtnClick:(id)sender {
    if (_type == 1) {

        NSString *str;
        if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
        } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
            str = @"取消关注";
        }
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:str, nil];
        // 其他人的主页
        actionSheet.tag = 3000;
        [actionSheet showInView:self.view];
        
        return;
    }
    personImageOrBackImageClick = NO;
    //弹出相机及相册选择页面
    CGRect rect = _openPhotoView.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    _openPhotoView.frame = rect;
    [self.view addSubview:_openPhotoView];
    [_backGroundImageView setHidden:NO];
    [_bigPersonImageView setHidden:YES];
    _backGroundImageView.imageURL = [CustomUtil getPhotoURL:[LoginModel shareInstance].backgroundImage];
    [_changePhotoLabel setText:@"更换背景"];
    
//    _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    //设置分享按钮的布局
//    NSArray *firstLineBtnArray = [NSArray arrayWithObjects:_weixinBtn, _pengyouquanBtn, _qqBtn, _qqkongjianBtn, nil];
//    NSArray *fristLineLabelArray = [NSArray arrayWithObjects:_weixinLabel, _pengyouquanLabel, _qqLabel, _qqkongjianLabel, nil];
//    CGFloat btnMarginX = [self getBtnMarginX];
//    for (int i=0; i<4; i++) {
//        UIButton *fenxiangBtn = [firstLineBtnArray objectAtIndexCheck:i];
//        CGRect fenxiangBtnFrame = fenxiangBtn.frame;
//        fenxiangBtnFrame.origin.x = btnMarginX*(i+1) + i*fenxiangBtnFrame.size.width;
//        fenxiangBtn.frame = fenxiangBtnFrame;
//        UILabel *fenxiangLabel = [fristLineLabelArray objectAtIndexCheck:i];
//        CGPoint fenxiangLabelCenter = fenxiangLabel.center;
//        fenxiangLabelCenter.x = fenxiangBtn.center.x;
//        fenxiangLabel.center = fenxiangLabelCenter;
//    }
//    
//    NSArray *secondeLineBtnArray = [NSArray arrayWithObjects:_weiboBtn, _duanxiaoxiBtn, _fuzhilianjieBtn, nil];
//    NSArray *secondeLineLabelArray = [NSArray arrayWithObjects:_weiboLabel, _duanxiaoxiLabel, _fuzhilianjieLabel, nil];
//    for (int i=0; i<3; i++) {
//        UIButton *fenxiangBtn = [secondeLineBtnArray objectAtIndexCheck:i];
//        CGRect fenxiangBtnFrame = fenxiangBtn.frame;
//        fenxiangBtnFrame.origin.x = btnMarginX*(i+1) + i*fenxiangBtnFrame.size.width;
//        fenxiangBtn.frame = fenxiangBtnFrame;
//        UILabel *fenxiangLabel = [secondeLineLabelArray objectAtIndexCheck:i];
//        CGPoint fenxiangLabelCenter = fenxiangLabel.center;
//        fenxiangLabelCenter.x = fenxiangBtn.center.x;
//        fenxiangLabel.center = fenxiangLabelCenter;
//    }
//    
//    [self.view addSubview:_shareView];
//    //显示分享视图
//    [_shareView setHidden:NO];
}

//编辑资料按钮点击事件
- (IBAction)editDocBtnClick:(id)sender {
    PersonDocViewController *viewCtrl = [[PersonDocViewController alloc] initWithNibName:@"PersonDocViewController" bundle:nil];
    viewCtrl.queryUserId = self.userId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

//粉丝按钮点击事件
- (void)fenSiBtnClick:(id)sender {
    MeFansViewController *meFansViewCtrl = [[MeFansViewController alloc] initWithNibName:@"MeFansViewController" bundle:nil];
    meFansViewCtrl.userId = self.userId;
    meFansViewCtrl.sex = userInfo.sex;
    [self.navigationController pushViewController:meFansViewCtrl animated:YES];
}

//关注按钮点击事件
- (void)guanZhuBtnClick:(id)sender {
    ConcernManViewController *concernManViewCtrl = [[ConcernManViewController alloc] initWithNibName:@"ConcernManViewController" bundle:nil];
    concernManViewCtrl.userId = self.userId;
    concernManViewCtrl.sex = userInfo.sex;
    [self.navigationController pushViewController:concernManViewCtrl animated:YES];
}

//照片
- (void)photoBtnClick{
    NSLog(@"照片");
    
    LabelPhotoViewController *vc = [[LabelPhotoViewController alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//标签
- (void)labelBtnClick{
    NSLog(@"标签");
    
    LabelMainViewController *vc = [[LabelMainViewController alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//去发布按钮点击事件
- (void)publishBtnClick:(id)sender {
    PublishStreetPhotoViewController *viewCtrl = [[PublishStreetPhotoViewController alloc] initWithNibName:@"PublishStreetPhotoViewController" bundle:nil];
    viewCtrl.photoIndex = 0;
    [TKPublishType shareInstance].publishType = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

//头像按钮点击事件
- (void)headPhotoBtnClick {
    if (_type == 1) {
        // 其他人的主页
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"个人资料" otherButtonTitles: nil];
        actionSheet.tag = 3001;
        [actionSheet showInView:self.view];
        
        return;
    }

    personImageOrBackImageClick = YES;
    CGRect rect = _openPhotoView.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    _openPhotoView.frame = rect;
    [self.view addSubview:_openPhotoView];
    [_backGroundImageView setHidden:YES];
    [_bigPersonImageView setHidden:NO];
    _bigPersonImageView.imageURL = [CustomUtil getPhotoURL:[LoginModel shareInstance].image];
    [CustomUtil setImageViewCorner:_bigPersonImageView];
    [_changePhotoLabel setText:@"更换头像"];
}

//背景图点击事件
-(void)backImageClick
{
    if (_type == 1) {
        // 其他人的主页
        return;
    }

    personImageOrBackImageClick = NO;
    //弹出相机及相册选择页面
    CGRect rect = _openPhotoView.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    _openPhotoView.frame = rect;
    [self.view addSubview:_openPhotoView];
    [_backGroundImageView setHidden:NO];
    [_bigPersonImageView setHidden:YES];
    _backGroundImageView.imageURL = [CustomUtil getPhotoURL:[LoginModel shareInstance].backgroundImage];
    [_changePhotoLabel setText:@"更换背景"];
}

//打开相册按钮点击事件
- (IBAction)openPhotoBtnClick:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"当前设备没有图片库" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}


//打开相机按钮点击事件
- (IBAction)openCameraBtnClick:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"当前设备没有摄像头" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//点击照相机Use按钮事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (YES == personImageOrBackImageClick) {
        [CustomUtil saveImageToSandBox:info fileName:@"personImage.jpg" block:^(UIImage *sandBoxImage, NSString *filePath) {
            //上传头像
            [ModifyUserDataInput shareInstance].image = filePath;
            [ModifyUserDataInput shareInstance].birthday = @"";
            [ModifyUserDataInput shareInstance].backgroundImage = @"";
            [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
            [ModifyUserDataInput shareInstance].userSignFlag = @"0";
            [ModifyUserDataInput shareInstance].storeFlag = @"0";
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
            [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
                ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    //设置头像及大图
                    _personImageView.image = sandBoxImage;
                    _bigPersonImageView.image = sandBoxImage;
                    
                    [GetUserInfoInput shareInstance].userId = self.userId;
                    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
                    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
                    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
                        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
                        if (RETURN_SUCCESS(returnData.status)) {
                            [LoginModel shareInstance].image = returnData.image;
                        } else {
                            [CustomUtil showToastWithText:returnData.msg view:kWindow];
                        }
                    } failedBlock:^(NSError *err) {
                    }];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
            } failedBlock:^(NSError *err) {
            }];
        }];
        [_openPhotoView removeFromSuperview];
    } else {
        [CustomUtil saveImageToSandBox:info fileName:@"backgroundImage.jpg" block:^(UIImage *sandBoxImage, NSString *filePath) {
            //上传背景图片
            [ModifyUserDataInput shareInstance].backgroundImage = filePath;
            [ModifyUserDataInput shareInstance].image = @"";
            [ModifyUserDataInput shareInstance].birthday = @"";
            [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
            [ModifyUserDataInput shareInstance].userSignFlag = @"0";
            [ModifyUserDataInput shareInstance].storeFlag = @"0";
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
            [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
                ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    //设置头像及大图
                    _bannerImageView.image = sandBoxImage;
                    
                    [GetUserInfoInput shareInstance].userId = self.userId;
                    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
                    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
                    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
                        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
                        if (RETURN_SUCCESS(returnData.status)) {
                            [LoginModel shareInstance].backgroundImage = returnData.backgroundImage;
                        } else {
                            [CustomUtil showToastWithText:returnData.msg view:kWindow];
                        }
                    } failedBlock:^(NSError *err) {
                    }];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
            } failedBlock:^(NSError *err) {
            }];
        }];
        [_openPhotoView removeFromSuperview];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击相机Cancel按钮事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消相册按钮点击事件
- (IBAction)cancelOpenPhotoBtnClick:(id)sender {
    [_openPhotoView removeFromSuperview];
}

//关注按钮点击事件
- (void)guanzhuPerson:(id)sender {
    //if (![TKLoginType shareInstance].loginType) {
    //   return;
    //}
    
    [UpdateFollwInput shareInstance].userId = self.userId;
    [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
    if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
        //加关注
        [UpdateFollwInput shareInstance].flag = @"0";
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
        [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
            UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if ([userInfo.followFlag isEqualToString:@"0"]) {
                    userInfo.followFlag = @"1";
                } else if ([userInfo.followFlag isEqualToString:@"1"]) {
                    userInfo.followFlag = @"0";
                }
                if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
                    _guanzhuBtn.hidden = NO;
                    _siliaoBtn.hidden = YES;
                } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                    _guanzhuBtn.hidden = YES;
                    _siliaoBtn.hidden = NO;
                }
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        } failedBlock:^(NSError *err) {
        }];
    } else if ([userInfo.followFlag isEqualToString:@"1"]) { //已关注
        //取消关注
        [CustomUtil showCustomAlertView:nil message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
            [UpdateFollwInput shareInstance].flag = @"1";
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    if ([userInfo.followFlag isEqualToString:@"0"]) {
                        userInfo.followFlag = @"1";
                    } else if ([userInfo.followFlag isEqualToString:@"1"]) {
                        userInfo.followFlag = @"0";
                    }
                    if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
                        _guanzhuBtn.hidden = NO;
                        _siliaoBtn.hidden = YES;
                    } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                        _guanzhuBtn.hidden = YES;
                        _siliaoBtn.hidden = NO;
                    }
                }
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            } failedBlock:^(NSError *err) {
            }];
        } target:self btnCount:2];
    }
}

- (void)messageBtnClick:(id)sender {
    //    if ([TKLoginType shareInstance].loginType) {
    //取得私信内容
    [GetMessageInput shareInstance].pagesize = @"10";
    [GetMessageInput shareInstance].current = @"1";
    [GetMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetMessageInput shareInstance].targetId = self.userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetMessageInput shareInstance]];
    SendPrivateMessageViewController *sendPrivateMessageViewCtrl = [[SendPrivateMessageViewController alloc] initWithNibName:@"SendPrivateMessageViewController" bundle:nil];
    sendPrivateMessageViewCtrl.dict = dict;
    sendPrivateMessageViewCtrl.userName = userInfo.userName;
    sendPrivateMessageViewCtrl.receiveId = userInfo.userId;
    [self.navigationController pushViewController:sendPrivateMessageViewCtrl animated:YES];
    //   }
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

//取消按钮
- (IBAction)cancelBtnClick:(id)sender {
    [_shareView setHidden:YES];
}

#pragma mark -共通方法
//获取分享按钮的X坐标偏移量
-(CGFloat)getBtnMarginX
{
    return (SCREEN_WIDTH - _weiboBtn.frame.size.width * 4)/5;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 3000) {
        if (buttonIndex == 0) {
            NSLog(@"加入黑名单");
            //弹出确认对话框
            [CustomUtil showCustomAlertView:nil message:[NSString stringWithFormat:@"是否把%@加入黑名单？", _userName.text] leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
                //调用接口
                [UpdateBlacklistInput shareInstance].userId = [LoginModel shareInstance].userId;
                [UpdateBlacklistInput shareInstance].blacklistId = _userId;
                [UpdateBlacklistInput shareInstance].flag = @"0"; //拉黑
                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateBlacklistInput shareInstance]];
                [[NetInterface shareInstance] updateBlacklist:@"updateBlacklist" param:dict successBlock:^(NSDictionary *responseDict) {
                    UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
                    if (RETURN_SUCCESS(returnData.status)) {
                        NSLog(@"成功加入黑名单");
                    }
                    [CustomUtil showToastWithText:returnData.msg view:self.view];
                } failedBlock:^(NSError *err) {
                }];
            } target:self btnCount:2];

        }
        else if (buttonIndex == 1 && buttonIndex != actionSheet.cancelButtonIndex) {
            NSLog(@"取消关注");
            [self guanzhuPerson:nil];
        }
    
    }
    else if (actionSheet.tag == 3001) {
        if (buttonIndex == 0) {
            NSLog(@"个人资料");
            PersonDocViewController *personDocViewCtrl = [[PersonDocViewController alloc] initWithNibName:@"PersonDocViewController" bundle:nil];
            personDocViewCtrl.queryUserId = _userId;
            [self.navigationController pushViewController:personDocViewCtrl animated:YES];
        }
    }
}


//图片点击事件处理
- (void)imageViewClick:(ImageInfo *)imageInfo
{
    
    if (!imageInfo) {
        return;
    }
    
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId;
    [self.navigationController pushViewController:viewCtrl animated:YES];

}

@end
