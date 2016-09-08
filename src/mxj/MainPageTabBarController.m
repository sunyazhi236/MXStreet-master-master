//
//  MainPageTabBarController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/10.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MainPageTabBarController.h"
#import "OwnAreaViewController.h"
#import "SearchViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "BannerCell.h"

#define PHOTO_COUNT 3 //设置图片总数
@interface MainPageTabBarController ()
{
//    NSInteger btnFlag; //0：关注 1:人气 2:同城
    NSTimer *timer;    //广告轮播定时器
    
    int currentImageIndex; //当前显示的图片下标
#ifdef OPEN_NET_INTERFACE
    EGOImageView *leftImageView;   //ScrollView左侧imageView
    EGOImageView *centerImageView; //ScrollView中间imageView
    EGOImageView *rightImageView;  //ScrollView右侧imageView
    NSMutableArray *imageArray;    //广告图片数组
    NSString *centerImageWebLink;  //中间图片关联的外部链接
    
    NSMutableArray *guanZhuArray;   //关注的数据
    NSMutableArray *renqiArray;     //人气的数据
    NSMutableArray *tongchengArray; //同城的数据
    
    int guanzhuCurrentPage;         //关注当前页码
    int renqiCurrentPage;           //人气当前页码
    int tongchengCurrentPage;       //同城当前页码
    
    NSMutableArray *guanZhuArrayImage;
    NSMutableArray *renqiArrayImage;
    NSMutableArray *tongchengArrayImage;
#else
    UIImageView *leftImageView;
    UIImageView *centerImageView;
    UIImageView *rightImageView;
#endif
    int menuFlag; //菜单标识 0：关注 1:人气 2:同城
    
    UIScrollView *mainScrollView; //最底层的滑动ScrollView，仅限左右滑动
    NSMutableArray *bannerImagePathArray; //广告图片路径数组
    UITableViewCell *lastCell;
    UILabel *msgLabel;
}

@end

@implementation MainPageTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    
    _rightButton.layer.cornerRadius = GetHeight(_rightButton) / 2;
    [self readQiandao];
//    btnFlag = MENU_FLAG; //默认选中关注按钮
    //默认选中菜单
    menuFlag = MENU_FLAG;
#ifdef OPEN_NET_INTERFACE
    imageArray = [[NSMutableArray alloc] init];
    guanZhuArray = [[NSMutableArray alloc] init];
    renqiArray = [[NSMutableArray alloc] init];
    tongchengArray = [[NSMutableArray alloc] init];
    
    guanZhuArrayImage = [[NSMutableArray alloc] init];
    renqiArrayImage = [[NSMutableArray alloc] init];;
    tongchengArrayImage = [[NSMutableArray alloc] init];
    bannerImagePathArray = [[NSMutableArray alloc] init];
#endif
    currentImageIndex = 0;

    guanzhuCurrentPage = 1;
    renqiCurrentPage = 1;
    tongchengCurrentPage = 1;
    
    if (!msgLabel) {
        msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        [msgLabel setTextColor:[UIColor lightGrayColor]];
        [msgLabel setText:@"关注其他人，发现更多街拍"];
        [msgLabel setTextAlignment:NSTextAlignmentCenter];
        [msgLabel setHidden:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (YES == _loginFlag) {
        if ([CustomUtil CheckParam:[TKLoginPosition shareInstance].cityName]) {
            if (![CustomUtil CheckParam:[LoginModel shareInstance].city]) {
                _cityName = [LoginModel shareInstance].city;
            } else if(![CustomUtil CheckParam:[LoginModel shareInstance].country]) {
                _cityName = [LoginModel shareInstance].country;
            } else {
                _cityName = @"邢台市";
            }
            [CustomUtil saveLocationInfo:_cityName];
            _cityFlag = @"1";
            [self initUI];
        } else {
            _cityFlag = @"0";
            NSString *preCityLocation = [CustomUtil readLocationInfo];
            _cityName = preCityLocation;

            if ((![CustomUtil CheckParam:preCityLocation]) && (![preCityLocation isEqualToString:[TKLoginPosition shareInstance].cityName])) {
                [CustomUtil showCustomAlertView:@"" message:[NSString stringWithFormat:@"系统定位您现在%@，是否切换到%@？", [TKLoginPosition shareInstance].cityName, [TKLoginPosition shareInstance].cityName] leftTitle:@"取消" rightTitle:@"切换" leftHandle:^(UIAlertAction *action) {
                    _cityName = preCityLocation;
                    [self initUI];
                } rightHandle:^(UIAlertAction *action) {
                    _cityName = [TKLoginPosition shareInstance].cityName;
                    [CustomUtil saveLocationInfo:_cityName];
                    [self initUI];
                } target:self btnCount:2];
            } else {
                _cityName = [TKLoginPosition shareInstance].cityName;
                if ([CustomUtil CheckParam:_cityName]) {
                    if (![CustomUtil CheckParam:[LoginModel shareInstance].city]) {
                        _cityName = [LoginModel shareInstance].city;
                    } else if(![CustomUtil CheckParam:[LoginModel shareInstance].country]) {
                        _cityName = [LoginModel shareInstance].country;
                    } else {
                        _cityName = @"邢台市";
                    }
                }
                [CustomUtil saveLocationInfo:_cityName];
                [self initUI];
            }
        }
        _loginFlag = NO;
    } else {
        [CustomUtil saveLocationInfo:_cityName];
        [self initUI];
    }
    //广告自动轮播
    [self addTimer];
}

-(void)initUI
{
    [self.scrollViewChangeBtnDelegate changeBtnStatus:menuFlag];

//    [self changeBtnStatus];
    if ([CustomUtil CheckParam:_cityName]) {
        if (![CustomUtil CheckParam:[LoginModel shareInstance].city]) {
            _cityName = [LoginModel shareInstance].city;
        } else if(![CustomUtil CheckParam:[LoginModel shareInstance].country]) {
            _cityName = [LoginModel shareInstance].country;
        } else {
            _cityName = @"邢台市";
        }
        [CustomUtil saveLocationInfo:_cityName];
    }
    [self reloadData:_cityName cityFlag:_cityFlag];
    switch (menuFlag) {
        case 0:
            if (1 == guanzhuCurrentPage) {
                [_guanzhuWaterView triggerPullToRefresh];
            }
            break;
        case 1:
            if (1 == renqiCurrentPage) {
                [_renqiWaterView triggerPullToRefresh];
            }
            break;
        case 2:
            if (1 == tongchengCurrentPage) {
                [_tongchengWaterView triggerPullToRefresh];
            }
            break;
        default:
            break;
    }
    [_positionBtn setTitle:_cityName forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (timer) {
        [timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MenuBtnCell *)menuBtnCell
{
    if (!_menuBtnCell) {
        _menuBtnCell = [[MenuBtnCell alloc] initWithDelegate:self];
//        _menuBtnCell.menuBtnDelegate = self;
    }
    return _menuBtnCell;
}

//初始化ScrollView
-(void)initScrollView
{
    //设置广告ScrollView
    [_bannerScrollView setShowsHorizontalScrollIndicator:NO];
    [_bannerScrollView setShowsVerticalScrollIndicator:NO];
    [_bannerScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"banner-bg_7"]]];
    [_bannerScrollView setDelegate:self];
#ifdef OPEN_NET_INTERFACE
    [GetBannerListInput shareInstance].pagesize = @"5";
    [GetBannerListInput shareInstance].current = @"1";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetBannerListInput shareInstance]];
    [[NetInterface shareInstance] getBannerList:@"getBannerList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetBannerList *bannerListData = [GetBannerList modelWithDict:responseDict];
        if (RETURN_SUCCESS(bannerListData.status)) {
            [imageArray removeAllObjects];
            for (int i=0; i<bannerListData.info.count; i++) {
                [imageArray addObject:bannerListData.info[i]];
            }
            //保存图片至本地沙盒
            [self saveBannerImageToSandBox];
            //按照广告的序号排序
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
            [imageArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
#ifdef CACHE_SWITCH
            //保存广告图数据
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:imageArray flag:0 imageFlag:100];
#endif
            _bannerPageCtrl.numberOfPages = imageArray.count;
        } else{
            [CustomUtil showCustomAlertView:@"提示" message:bannerListData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        }
        //调整ScrollView
        CGRect rect = _bannerScrollView.frame;
        rect.size.height = SCREEN_WIDTH * 2/5;
        _bannerScrollView.frame = rect;
        //调整指示器位置
        rect = _bannerPageCtrl.frame;
        rect.origin.y = _bannerScrollView.frame.size.height - rect.size.height + 8;
        _bannerPageCtrl.frame = rect;
        
        [_bannerScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*imageArray.count, _bannerScrollView.frame.size.height)];
        leftImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
        centerImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
        [centerImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerImageViewClick)];
        [centerImageView addGestureRecognizer:gesture];
        rightImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
        leftImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
        centerImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
        rightImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
        //imageArray = [[NSMutableArray alloc] initWithObjects:@"http://amuse.nen.com.cn/imagelist/11/21/9as70n3ir61b.jpg",@"http://www.dnkb.com.cn/upload/pic/20110604/161537371.tl.jpg", @"http://www.sgxw.cn/uploadfile/2011/1022/20111022094539323.png", nil];
        GetBannerListInfo *leftInfo;
        GetBannerListInfo *centerInfo;
        GetBannerListInfo *rightInfo;
        if (imageArray.count > 0) {
            leftInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:(imageArray.count - 1)]];
            //获取图片
            leftImageView.image = [self getImage:leftInfo.bannerImg];
            centerInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:0]];
            centerImageView.image = [self getImage:centerInfo.bannerImg];
            rightInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:1]];
            rightImageView.image = [self getImage:rightInfo.bannerImg];
        }
        [_bannerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        [_bannerScrollView addSubview:leftImageView];
        [_bannerScrollView addSubview:centerImageView];
        [_bannerScrollView addSubview:rightImageView];
        //[_mainPageTableView reloadData];
    } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
        if ((-1009) == err.code) {
            [imageArray removeAllObjects];
            //读取缓存数据
            NSMutableArray *array = (NSMutableArray *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:0];
            if (!array) {
                return;
            }
            [imageArray addObjectsFromArray:array];
            
            _bannerPageCtrl.numberOfPages = imageArray.count;
            [_bannerScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*imageArray.count, _bannerScrollView.frame.size.height)];
            leftImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
            centerImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
            [centerImageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerImageViewClick)];
            [centerImageView addGestureRecognizer:gesture];
            rightImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
            leftImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
            centerImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
            rightImageView.placeholderImage = [UIImage imageNamed:@"banner-bg_7"];
            GetBannerListInfo *leftInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:(imageArray.count - 1)]];
            //获取图片
            leftImageView.image = [self getImage:leftInfo.bannerImg];
            GetBannerListInfo *centerInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:0]];
            centerImageView.image = [self getImage:centerInfo.bannerImg];
            GetBannerListInfo *rightInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:1]];
            rightImageView.image = [self getImage:rightInfo.bannerImg];
            [_bannerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
            [_bannerScrollView addSubview:leftImageView];
            [_bannerScrollView addSubview:centerImageView];
            [_bannerScrollView addSubview:rightImageView];
        }
#endif
    }];
#else
    [_bannerScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*PHOTO_COUNT, _bannerScrollView.frame.size.height)];
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
    centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
    rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, _bannerScrollView.frame.size.height)];
    [leftImageView setImage:[UIImage imageNamed:@"banner_7"]];
    [centerImageView setImage:[UIImage imageNamed:@"banner_7"]];
    [rightImageView setImage:[UIImage imageNamed:@"banner_7"]];
    [_bannerScrollView addSubview:leftImageView];
    [_bannerScrollView addSubview:centerImageView];
    [_bannerScrollView addSubview:rightImageView];
    [_bannerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
#endif
}


- (void)showQiandaoView:(NSDictionary *)dictionary
{
    if (!_signBackView) {
        _signBackView = [[UIView alloc] initWithFrame:self.view.frame];
        _signBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:_signBackView];
    }
    
    UIImageView *imageViewBg = (UIImageView *)[_signBackView viewWithTag:2000];
    if (!imageViewBg) {
        imageViewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qdbg"]];
        imageViewBg.frame = CGRectMake(35, SCREENHEIGHT/2 - 90, SCREENWIDTH - 70, 200);
        [_signBackView addSubview:imageViewBg];
    }
    
    UIImageView *imageViewStar = (UIImageView *)[_signBackView viewWithTag:2001];
    if (!imageViewStar) {
        imageViewStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qdstar"]];
        imageViewStar.frame = CGRectMake(SCREENWIDTH/2 - 78, imageViewBg.frame.origin.y - 73, 156, 120);
        [_signBackView addSubview:imageViewStar];
    }
    
    UIImageView *imageViewDgl = (UIImageView *)[_signBackView viewWithTag:2002];
    if (!imageViewDgl) {
        imageViewDgl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qddgl"]];
        imageViewDgl.frame = CGRectMake(0, 0, SCREENWIDTH, 330);
        [_signBackView addSubview:imageViewDgl];
    }
    
    UIImageView *imageViewDgr = (UIImageView *)[_signBackView viewWithTag:2003];
    if (!imageViewDgr) {
        imageViewDgr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qddgr"]];
        imageViewDgr.frame = CGRectMake(0, 0, SCREENWIDTH, 330);
        [_signBackView addSubview:imageViewDgr];
    }
    
    NSString *num;
    if ([dictionary objectForKey:@"days"]) {
        num = [dictionary objectForKey:@"days"];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"连续签到 %@ 天，奖励", num]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,num.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(6 + num.length,4)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(5,num.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(6 + num.length,4)];
    
    UILabel *titleLabel = (UILabel *)[_signBackView viewWithTag:2004];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, imageViewBg.frame.size.width, 20)];
        titleLabel.attributedText = str;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [imageViewBg addSubview:titleLabel];
    }
    
    UIImageView *imageViewMd = (UIImageView *)[_signBackView viewWithTag:2005];
    if (!imageViewMd) {
        UIImage *md = [UIImage imageNamed:@"qdmd"];
        imageViewMd = [[UIImageView alloc] initWithImage:md];
        imageViewMd.frame = CGRectMake(SCREENWIDTH/2 - md.size.width/2 - 50, 90, md.size.width/2, md.size.height/2);
        [imageViewBg addSubview:imageViewMd];
    }
    
    UIImageView *imageViewMdk = (UIImageView *)[_signBackView viewWithTag:2006];
    UIImage *mdk = [UIImage imageNamed:@"qdkuang"];
    if (!imageViewMdk) {
        imageViewMdk = [[UIImageView alloc] initWithImage:mdk];
        imageViewMdk.frame = CGRectMake(SCREENWIDTH/2 - 45, 95, mdk.size.width/2, mdk.size.height/2);
        [imageViewBg addSubview:imageViewMdk];
    }
    
    NSString *mdnum;
    if ([dictionary objectForKey:@"todayRewardMxCoin"]) {
        mdnum = [dictionary objectForKey:@"todayRewardMxCoin"];
    }
    NSMutableAttributedString *mdstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@毛豆", mdnum]];
    [mdstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,mdnum.length)];
    [mdstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(mdnum.length,2)];
    [mdstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:30.0] range:NSMakeRange(0,mdnum.length)];
    [mdstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(mdnum.length,2)];
    UILabel *mdLabel = (UILabel *)[_signBackView viewWithTag:2007];
    if (!mdLabel) {
        mdLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, mdk.size.width/2, mdk.size.height/2)];
        mdLabel.attributedText = mdstr;
        mdLabel.textAlignment = NSTextAlignmentCenter;
        [imageViewMdk addSubview:mdLabel];
    }
    
    NSString *max;
    if ([dictionary objectForKey:@"max"]) {
        max = [dictionary objectForKey:@"max"];
    }
    NSString *botStr = [NSString stringWithFormat:@"连续签到能保持每天活得%@毛豆", max];
    if ([mdnum intValue] < [max intValue] && [dictionary objectForKey:@"tomorrowRewardMxCoin"]) {
        botStr = [NSString stringWithFormat:@"预测明天签到奖励%@毛豆", [dictionary objectForKey:@"tomorrowRewardMxCoin"]];
    }
    UILabel *bottomLabel = (UILabel *)[_signBackView viewWithTag:2008];
    if (!bottomLabel) {
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewBg.frame.size.height - 40, imageViewBg.frame.size.width, 20)];
        bottomLabel.text = botStr;
        bottomLabel.textColor = [UIColor lightGrayColor];
        bottomLabel.font = [UIFont systemFontOfSize:13.0f];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [imageViewBg addSubview:bottomLabel];
    }
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSignBackView)];
    [_signBackView addGestureRecognizer:tap];
    
    [_signBackView setHidden:NO];
    
    //三秒后隐藏
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideSignBackView];
    });
}

- (void)hideSignBackView
{
    [_signBackView setHidden:YES];
}

//刷新数据
-(void)reloadData:(NSString *)cityName cityFlag:(NSString *)cityFlag
{
    //调用接口 获取瀑布流数据
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = @"1";
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"1"; //关注
    NSMutableDictionary *guanzhuDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:guanzhuDict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            if (returnData.info.count == 0) {
                if(0 == menuFlag) {
                    [msgLabel setHidden:NO];
                }
            } else {
                [msgLabel setHidden:YES];
            }
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *guanzhuDict = (NSDictionary *)(returnData.info[i]);
                [guanZhuArray addObject:guanzhuDict];
#ifdef CACHE_SWITCH
                //保存用户头像
                NSURL *personImageUrl = [CustomUtil getPhotoURL:[guanzhuDict objectForKey:@"image"]];
                [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:personImageUrl flag:1 imageFlag:(i + 10)];
                //保存街拍首图
                NSURL *photoUrl = [CustomUtil getPhotoURL:[guanzhuDict objectForKey:@"photo1"]];
                [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:photoUrl flag:1 imageFlag:i];
#endif
            }
#ifdef CACHE_SWITCH
            //保存关注数据
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:guanZhuArray flag:1 imageFlag:100];
#endif
            //设置瀑布流
            [self setSelfWaterView:0];
            [GetStreetsnapListInput shareInstance].type = @"2"; //人气
            NSMutableDictionary *renqiDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
            [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:renqiDict successBlock:^(NSDictionary *responseDict) {
                GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    for (int i=0; i<returnData.info.count; i++) {
                        NSDictionary *dict = (NSDictionary *)(returnData.info[i]);
                        [renqiArray addObject:dict];
#ifdef CACHE_SWITCH
                        //保存用户头像
                        NSURL *personImageUrl = [CustomUtil getPhotoURL:[dict objectForKey:@"image"]];
                        [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:personImageUrl flag:2 imageFlag:(i + 10)];
                        //保存街拍首图
                        NSURL *photoUrl = [CustomUtil getPhotoURL:[dict objectForKey:@"photo1"]];
                        [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:photoUrl flag:2 imageFlag:i];
#endif
                    }
#ifdef CACHE_SWITCH
                    //保存人气数据
                    [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:renqiArray flag:2 imageFlag:100];
#endif
                    //设置瀑布流
                    [self setSelfWaterView:1];
                    [GetStreetsnapListInput shareInstance].type = @"3"; //同城
                    [GetStreetsnapListInput shareInstance].place = cityName;
                    [GetStreetsnapListInput shareInstance].cityFlag = cityFlag;
                    NSMutableDictionary *tongchengDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
                    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:tongchengDict successBlock:^(NSDictionary *responseDict) {
                        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
                        if (RETURN_SUCCESS(returnData.status)) {
                            for (int i=0; i<returnData.info.count; i++) {
                                NSDictionary *dict = (NSDictionary *)(returnData.info[i]);
                                [tongchengArray addObject:dict];
#ifdef CACHE_SWITCH
                                //保存用户头像
                                NSURL *personImageUrl = [CustomUtil getPhotoURL:[dict objectForKey:@"image"]];
                                [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:personImageUrl flag:3 imageFlag:(i + 10)];
                                //保存街拍首图
                                NSURL *photoUrl = [CustomUtil getPhotoURL:[dict objectForKey:@"photo1"]];
                                [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:photoUrl flag:3 imageFlag:i];
#endif
                            }
#ifdef CACHE_SWITCH
                            //保存同城数据
                            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:tongchengArray flag:3 imageFlag:100];
#endif
                            //设置瀑布流
                            [self setSelfWaterView:2];
                        } else {
                            [CustomUtil showToastWithText:returnData.msg view:self.view];
                        }
                        [_mainPageTableView setDelegate:self];
                        [_mainPageTableView setDataSource:self];
                        [_mainPageTableView reloadData];
                    } failedBlock:^(NSError *err) {
                    }];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:self.view];
                }
            } failedBlock:^(NSError *err) {
            }];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
        if ((-1009) == [err code]) {
            //读取缓存数据
            NSMutableArray *array1 = (NSMutableArray *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:1];
            if (array1) {
                [guanZhuArray addObjectsFromArray:array1];
            }
            [self setSelfWaterView:0];
            NSMutableArray *array2 = (NSMutableArray *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:2];
            if (array2) {
                [renqiArray addObjectsFromArray:array2];
            }
            [self setSelfWaterView:1];
            NSMutableArray *array3 = (NSMutableArray *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:3];
            if (array3) {
                [tongchengArray addObjectsFromArray:array3];
            }
            [self setSelfWaterView:2];
            [_mainPageTableView setDelegate:self];
            [_mainPageTableView setDataSource:self];
            [_mainPageTableView reloadData];
        }
#endif
    }];
}

//获取关注瀑布数据
-(void)reloadGuanZhuData:(int)currentPageNum block:(void(^)(NSMutableArray *info))block
{
    //调用接口 获取瀑布流数据
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPageNum];
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"1"; //关注
    NSMutableDictionary *guanzhuDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:guanzhuDict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            if (1 == currentPageNum) {
                [guanZhuArray removeAllObjects];
            }
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *guanzhuDict = (NSDictionary *)(returnData.info[i]);
                [guanZhuArray addObject:guanzhuDict];
            }
            if (guanZhuArray.count == 0) {
                if (0 == menuFlag) {
                    [msgLabel setHidden:NO];
                }
            } else {
                [msgLabel setHidden:YES];
            }
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

//获取人气瀑布数据
-(void)reloadRenqiData:(int)currentPageNum block:(void(^)(NSMutableArray *info))block
{
    //调用接口 获取瀑布流数据
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPageNum];
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"2"; //人气
    NSMutableDictionary *renqiDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:renqiDict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            if (1 == currentPageNum) {
                [renqiArray removeAllObjects];
            }
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *renqiDict = (NSDictionary *)(returnData.info[i]);
                [renqiArray addObject:renqiDict];
            }
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

//获取同城瀑布数据
-(void)reloadTongchengData:(int)currentPageNum block:(void(^)(NSMutableArray *info))block
{
    //调用接口 获取瀑布流数据
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPageNum];
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"3"; //同城
    [GetStreetsnapListInput shareInstance].place = _cityName;
    [GetStreetsnapListInput shareInstance].cityFlag = _cityFlag;
    NSMutableDictionary *tongchengDict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:tongchengDict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            if (1 == currentPageNum) {
                [tongchengArray removeAllObjects];
            }
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *tongchengDict = (NSDictionary *)(returnData.info[i]);
                [tongchengArray addObject:tongchengDict];
            }
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark - TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum;
    switch (section) {
        case 0:
            rowNum = 1;
            break;
        case 1:
            rowNum = 1;
            break;
        default:
            break;
    }
    return rowNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (0 == indexPath.section) {
        height = SCREEN_WIDTH * 2/5;
    }
    
    if (1 == indexPath.section) {
        switch (menuFlag) {
            case 0:
                height = _guanzhuWaterView.frame.size.height;
                break;
            case 1:
                height = _renqiWaterView.frame.size.height;
                break;
            case 2:
                height = _tongchengWaterView.frame.size.height;
            default:
                break;
        }
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        BannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:@"BannerCell"];
        if (!bannerCell) {
            bannerCell = [[[NSBundle mainBundle] loadNibNamed:@"BannerCell" owner:self options:nil] lastObject];
            bannerCell.bannerScrollView.delegate = self;
            _bannerScrollView = bannerCell.bannerScrollView;
            _bannerPageCtrl = bannerCell.bannerPageCtrl;
            //设置PageCtrl
            _bannerPageCtrl.currentPage = currentImageIndex;
            _bannerPageCtrl.pageIndicatorTintColor = [UIColor grayColor];
            _bannerPageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
            //初始化ScrollView
            [self initScrollView];
        }
        
        return bannerCell;
    }
    
    if (1 == indexPath.section) {
        if (!lastCell) {
            lastCell = [[UITableViewCell alloc] init];
        }
        CGRect customeFrame = lastCell.frame;
        
        //构造底层ScrollView
        if (!mainScrollView) {
            mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _guanzhuWaterView.frame.size.height)];
            mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, _guanzhuWaterView.frame.size.height);
            mainScrollView.showsHorizontalScrollIndicator = NO;
            mainScrollView.showsVerticalScrollIndicator = NO;
            mainScrollView.bounces = NO;
            mainScrollView.canCancelContentTouches = NO;
            mainScrollView.pagingEnabled = YES;
            
            [mainScrollView addSubview:_guanzhuWaterView];
            [mainScrollView addSubview:_renqiWaterView];
            [mainScrollView addSubview:_tongchengWaterView];
            mainScrollView.delegate = self;
            
            [mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*menuFlag, 0) animated:NO];
        }
        
        [_guanzhuWaterView addSubview:msgLabel];
        
        switch (menuFlag) {
            case 0:
            {
                customeFrame.size.height = _guanzhuWaterView.frame.size.height;
                lastCell.frame = customeFrame;
                CGRect mainScrollFrame = mainScrollView.frame;
                mainScrollFrame.size.height = _guanzhuWaterView.frame.size.height;
                mainScrollView.frame = mainScrollFrame;
                //[_guanzhuWaterView setScrollEnabled:NO];
                //[mainScrollView setScrollEnabled:NO];
                [lastCell addSubview:mainScrollView];
            }
                break;
            case 1:
            {
                customeFrame.size.height = _renqiWaterView.frame.size.height;
                lastCell.frame = customeFrame;
                CGRect mainScrollFrame = mainScrollView.frame;
                mainScrollFrame.size.height = _renqiWaterView.frame.size.height;
                mainScrollView.frame = mainScrollFrame;
                //[_renqiWaterView setScrollEnabled:NO];
                //[mainScrollView setScrollEnabled:NO];
                [lastCell addSubview:mainScrollView];
            }
                break;
            case 2:
            {
                customeFrame.size.height = _tongchengWaterView.frame.size.height;
                lastCell.frame = customeFrame;
                CGRect mainScrollFrame = mainScrollView.frame;
                mainScrollFrame.size.height = _tongchengWaterView.frame.size.height;
                mainScrollView.frame = mainScrollFrame;
                //[_tongchengWaterView setScrollEnabled:NO];
                //[mainScrollView setScrollEnabled:NO];
                [lastCell addSubview:mainScrollView];
            }
                break;
            default:
                break;
        }
        [lastCell setBackgroundColor:[UIColor clearColor]];
        return lastCell;
    }
    
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (1 == section) {
        height = MENU_CELL_HEIGHT;
    }
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
//        MenuBtnCell *menuBtnCell = [tableView dequeueReusableCellWithIdentifier:@"MenuBtnCell"];
//        if (!menuBtnCell) {
//            menuBtnCell = [[[NSBundle mainBundle] loadNibNamed:@"MenuBtnCell" owner:self options:nil] lastObject];
//        }
//        CGRect labelFrame = menuBtnCell.leftLineLabel.frame;
//        labelFrame.origin.x = SCREEN_WIDTH/3;
//        menuBtnCell.leftLineLabel.frame = labelFrame;
//        labelFrame = menuBtnCell.rightLineLable.frame;
//        labelFrame.origin.x = SCREEN_WIDTH - menuBtnCell.leftLineLabel.frame.origin.x;
//        menuBtnCell.rightLineLable.frame = labelFrame;
        self.scrollViewChangeBtnDelegate = self.menuBtnCell;
//        switch (menuFlag) {
//            case 0:
//                [menuBtnCell.guanzhuBtn setSelected:YES];
//                //[self.cellBackImageView setImage:[UIImage imageNamed:@"left_7"]];
//                [menuBtnCell.menuBackImageView setImage:[UIImage imageNamed:@"left_7"]];
//                break;
//            case 1:
//                [menuBtnCell.renqiBtn setSelected:YES];
//                [menuBtnCell.menuBackImageView setImage:[UIImage imageNamed:@"middle_7"]];
//                //[self.cellBackImageView setImage:[UIImage imageNamed:@"middle_7"]];
//                break;
//            case 2:
//                [menuBtnCell.tongchengBtn setSelected:YES];
//                //[self.cellBackImageView setImage:[UIImage imageNamed:@"right_7"]];
//                [menuBtnCell.menuBackImageView setImage:[UIImage imageNamed:@"right_7"]];
//                break;
//            default:
//                break;
//        }
        return self.menuBtnCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ((0 == indexPath.section) && (0 == indexPath.row)) {
        [_guanzhuWaterView setScrollEnabled:YES];
        [_renqiWaterView setScrollEnabled:YES];
        [_tongchengWaterView setScrollEnabled:YES];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //[mainScrollView setScrollEnabled:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((0 == indexPath.section) && (0 == indexPath.row)) {
        [_guanzhuWaterView scrollsToTop];
        [_renqiWaterView scrollsToTop];
        [_tongchengWaterView scrollsToTop];
        //[_guanzhuWaterView setScrollEnabled:NO];
        //[_renqiWaterView setScrollEnabled:NO];
        //[_tongchengWaterView setScrollEnabled:NO];
        //[mainScrollView setScrollEnabled:NO];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
     }
}

#pragma mark -广告ScrollView代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_bannerScrollView == scrollView) {
        //关闭定时器
        [timer invalidate];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_bannerScrollView == scrollView) {
        //开启定时器
        [self addTimer];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_bannerScrollView == scrollView) {
        if ((SCREEN_WIDTH*2 == scrollView.contentOffset.x) || (0 == scrollView.contentOffset.x)) {
            [self reloadImageView];
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        }
    }
    if ((_guanzhuWaterView == scrollView) ||
        (_renqiWaterView == scrollView) ||
        (_tongchengWaterView == scrollView)) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *array = [_mainPageTableView indexPathsForVisibleRows];
        for (NSIndexPath *object in array) {
            if (([path isEqual:object]) && (scrollView.contentOffset.y > 0)) {
                [_mainPageTableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
            }
        }
        BOOL isDisplay = NO;
        for (NSIndexPath *object in array) {
            if ([path isEqual:object]) {
                isDisplay = YES;
            }
        }
        if ((scrollView.contentOffset.y < 0) && (NO == isDisplay)) {
            [_mainPageTableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (mainScrollView == scrollView) {
        //按照滑动距离设置菜单按钮
        int currentIndex = menuFlag = (int)(scrollView.contentOffset.x/SCREEN_WIDTH);
        [self.scrollViewChangeBtnDelegate changeBtnStatus:currentIndex];
        
        if (menuFlag == 0) {
            if (guanZhuArray.count == 0) {
                [msgLabel setHidden:NO];
            }
            else {
                [msgLabel setHidden:YES];
            }
        }
    }
}

- (void)reloadImageView
{
    if (imageArray.count <= 0) {
        return;
    }
    if (_bannerScrollView.contentOffset.x < SCREEN_WIDTH) { //向右滑动
        currentImageIndex = (currentImageIndex + (int)(imageArray.count) - 1)%imageArray.count;
    } else { //向左滑动
        currentImageIndex = (currentImageIndex + 1)%imageArray.count;
    }
    
    [_bannerPageCtrl setCurrentPage:currentImageIndex];
#ifdef OPEN_NET_INTERFACE
    if (0 != imageArray.count) {
        //重新加载图片
        centerImageView.image = [self getImage:[[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:currentImageIndex]].bannerImg];
        centerImageWebLink = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:currentImageIndex]].bannerLink;
        leftImageView.image = [self getImage:[[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:(currentImageIndex + (imageArray.count - 1))%imageArray.count]].bannerImg];
        rightImageView.image = [self getImage:[[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:(currentImageIndex + 1)%(imageArray.count)]].bannerImg];
    }
#endif
}

#pragma mark -tabBar代理方法
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 1:       //首页
            NSLog(@"首页");
            break;
        case 2:       //街拍
        {
            NSLog(@"街拍");
            UIViewController *viewCtrl = [[UIViewController alloc] init];
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case 3:       //中间
            NSLog(@"中间");
            break;
        case 4:       //消息
            NSLog(@"消息");
            break;
        case 5:       //我的
            NSLog(@"我的");
            break;
        default:
            break;
    }
    
}

#pragma mark -按钮点击事件处理
//菜单按钮点击事件
-(void)menuBtnClick:(int)flag
{
    menuFlag = flag - 1;
    //根据选中的按钮滑动mainScrollView
    [mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*menuFlag, 0) animated:YES];
    switch (menuFlag) {
        case 0:
            if (guanZhuArray.count == 0) {
                [_guanzhuWaterView triggerPullToRefresh];
            }
            break;
        case 1:
            [msgLabel setHidden:YES];
            if (renqiArray.count == 0) {
                [_renqiWaterView triggerPullToRefresh];
            }
            break;
        case 2:
            [msgLabel setHidden:YES];
            if (tongchengArray.count == 0) {
                [_tongchengWaterView triggerPullToRefresh];
            }
            break;
        default:
            break;
    }
}

//地区按钮点击事件
- (IBAction)areaBtnClick:(id)sender {
    //跳转至P12-1-3所在地区界面
    OwnAreaViewController *ownAreaViewCtrl = [[OwnAreaViewController alloc] initWithNibName:@"OwnAreaViewController" bundle:nil];
    ownAreaViewCtrl.intoFlag = 0; //主页进入
    [self.navigationController pushViewController:ownAreaViewCtrl animated:YES];
}

//搜索按钮点击事件 --> 签到
- (IBAction)searchBtnClick:(id)sender {
    NSLog(@"签到");
    
    //http://localhost:8080/maoxj//signIn/cumulativeSignTime?userId=2833
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[LoginModel shareInstance].userId}];

    [[NetInterface shareInstance] requestNetWork:@"maoxj/signIn/tosignin" param:dict successBlock:^(NSDictionary *responseDict) {
        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            [self showQiandaoView:responseDict];
            [self.rightButton setTitle:@"已签到" forState:UIControlStateNormal];
            [self writeQiandao];
        }
        else {
            [CustomUtil showToast:[responseDict objectForKey:@"msg"] ? [responseDict objectForKey:@"msg"] : @"今日已签到" view:self.view];
            [self.rightButton setTitle:@"已签到" forState:UIControlStateNormal];
            [self writeQiandao];
        }
    } failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
    
    
//    SearchViewController *searchViewCtrl = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
//    [self.navigationController pushViewController:searchViewCtrl animated:YES];
}

//签到写入文件
-(void)writeQiandao{
    //将数据写入plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"maodouQiandao.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filePath contents:nil attributes:nil];
    NSMutableDictionary *writeDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    [writeDict setValue:dateString forKey:@"date"];
    [writeDict setValue:[LoginModel shareInstance].userId forKey:@"uid"];
    
    [writeDict writeToFile:filePath atomically:YES];
}

//读取签到文件
-(void)readQiandao{
    //将数据写入plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"maodouQiandao.plist"];

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];

    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ([[dic2 objectForKey:@"data"] rangeOfString:dateString].location != NSNotFound && [[dic2 objectForKey:@"uid"] rangeOfString:[LoginModel shareInstance].userId].location != NSNotFound && dic2!=nil) {
        [self.rightButton setTitle:@"已签到" forState:UIControlStateNormal];
    }
}

#pragma mark -共通方法
//修改菜单按钮的状态
-(void)changeBtnStatus
{
    switch (menuFlag) {
        case 0: //关注
            [self.guanzhuBtn setSelected:YES];
            [self.renqiBtn setSelected:NO];
            [self.tongcBtn setSelected:NO];
            [self.cellBackImageView setImage:[UIImage imageNamed:@"left_7"]];
            [_guanzhuWaterView scrollsToTop];
            break;
        case 1: //人气
            [self.guanzhuBtn setSelected:NO];
            [self.renqiBtn setSelected:YES];
            [self.tongcBtn setSelected:NO];
            [self.cellBackImageView setImage:[UIImage imageNamed:@"middle_7"]];
            [_renqiWaterView scrollsToTop];
            break;
        case 2: //同城
            [self.guanzhuBtn setSelected:NO];
            [self.renqiBtn setSelected:NO];
            [self.tongcBtn setSelected:YES];
            [self.cellBackImageView setImage:[UIImage imageNamed:@"right_7"]];
            [_tongchengWaterView scrollsToTop];
            break;
        default:
            break;
    }
}

//广告自动轮播
-(void)startAutoChangeBanner
{
    [_bannerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
}

//设置瀑布流
-(void)setSelfWaterView:(int)waterViewFlag
{
    //解析数据
    switch (waterViewFlag) {
        case 0: //关注
        {
            for (int i=0; i<[guanZhuArray count]; i++) {
                NSDictionary *dataD = [guanZhuArray objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [guanZhuArrayImage addObject:imageInfo];
                }
            }
        }
            break;
        case 1: //人气
        {
            for (int i=0; i<[renqiArray count]; i++) {
                NSDictionary *dataD = [renqiArray objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [renqiArrayImage addObject:imageInfo];
                }
            }
        }
            break;
        case 2: //同城
        {
            for (int i=0; i<[tongchengArray count]; i++) {
                NSDictionary *dataD = [tongchengArray objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [tongchengArrayImage addObject:imageInfo];
                }
            }
        }
            break;
        default:
            break;
    }
    if (0 == waterViewFlag) {
        if (!_guanzhuWaterView) {
            _guanzhuWaterView = [[ImageWaterView alloc] initWithDataArray:guanZhuArrayImage withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 47 - 44) intoFlag:0];
        }
        /*
        int firstViewHeight = _guanzhuWaterView.firstView.frame.size.height;
        int secondeViewHeight = _guanzhuWaterView.secondView.frame.size.height;
        CGRect _guanzhuWaterViewFrame = _guanzhuWaterView.frame;
        if (firstViewHeight >= secondeViewHeight) {
            _guanzhuWaterViewFrame.size.height = firstViewHeight;
        } else {
            _guanzhuWaterViewFrame.size.height = secondeViewHeight;
        }
        _guanzhuWaterViewFrame.origin.y = 47;
        _guanzhuWaterView.frame = _guanzhuWaterViewFrame;
         */
        _guanzhuWaterView.delegate = self;
        _guanzhuWaterView.imageViewClickDelegate = self;
        //添加上拉加载更多
        __weak MainPageTabBarController *blockSelf = self;
        __weak NSMutableArray *guanzhuArrayImageSelf = guanZhuArrayImage;
        __block int guanzhuCurrentPageSelf = guanzhuCurrentPage;
        __weak NSMutableArray *guanZhuArraySelf = guanZhuArray;
        __block UILabel *msgLabelSelf = msgLabel;
        [_guanzhuWaterView addInfiniteScrollingWithActionHandler:^{
            NSLog(@"上拉加载");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                guanzhuCurrentPageSelf++;
                guanzhuCurrentPage = guanzhuCurrentPageSelf;
                [blockSelf reloadGuanZhuData:guanzhuCurrentPageSelf block:^(NSMutableArray *info) {
                    [guanZhuArraySelf addObjectsFromArray:info];
                    [guanzhuArrayImageSelf removeAllObjects];
                    for(int i=0; i<[info count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [guanzhuArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.guanzhuWaterView loadNextPage:guanzhuArrayImageSelf intoFlag:0];
                }];
                [blockSelf.guanzhuWaterView.infiniteScrollingView stopAnimating];
            });
        }];
        //添加下拉刷新
        [_guanzhuWaterView addPullToRefreshWithActionHandler:^{
            NSLog(@"下拉更新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                guanzhuCurrentPageSelf = 1;
                guanzhuCurrentPage = 1;
                [blockSelf reloadGuanZhuData:guanzhuCurrentPageSelf block:^(NSMutableArray *info) {
                    //if ((info.count > 0) && [((ImageInfo *)[guanzhuArrayImageSelf objectAtIndexCheck:0]).thumbURL isEqualToString:[CustomUtil getPhotoURL:[[info objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString]) {
                      //  [blockSelf.guanzhuWaterView.pullToRefreshView stopAnimating];
                        //return;
                    //}
                    
                    [guanZhuArraySelf removeAllObjects];
                    [guanzhuArrayImageSelf removeAllObjects];
                    [guanZhuArraySelf addObjectsFromArray:info];
                    if (guanZhuArraySelf.count == 0) {
                        if (0 == menuFlag) {
                            [msgLabelSelf setHidden:NO];
                        }
                    } else {
                        [msgLabelSelf setHidden:YES];
                    }
                    for (int i=0; i<[guanZhuArraySelf count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [guanzhuArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.guanzhuWaterView refreshView:guanzhuArrayImageSelf intoFlag:0];
                }];
                [blockSelf.guanzhuWaterView.pullToRefreshView stopAnimating];
            });
        }];
    } else if (1 == waterViewFlag) {
        if (!_renqiWaterView) {
            _renqiWaterView = [[ImageWaterView alloc] initWithDataArray:renqiArrayImage withFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 47) intoFlag:0];
        }
        _renqiWaterView.delegate = self;
        _renqiWaterView.imageViewClickDelegate = self;
        //添加上拉加载更多
        __weak MainPageTabBarController *blockSelf = self;
        __weak NSMutableArray *renqiArrayImageSelf = renqiArrayImage;
        __weak NSMutableArray *renqiArraySelf = renqiArray;
        __block int renqiCurrentPageSelf = renqiCurrentPage;
        [_renqiWaterView addInfiniteScrollingWithActionHandler:^{
            NSLog(@"上拉刷新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                renqiCurrentPageSelf++;
                renqiCurrentPage = renqiCurrentPageSelf;
                [blockSelf reloadRenqiData:renqiCurrentPageSelf block:^(NSMutableArray *info) {
                    [renqiArraySelf addObjectsFromArray:info];
                    [renqiArrayImageSelf removeAllObjects];
                    for(int i=0; i<[info count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [renqiArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.renqiWaterView loadNextPage:renqiArrayImageSelf intoFlag:0];
                }];
                [blockSelf.renqiWaterView.infiniteScrollingView stopAnimating];
            });
        }];
        //添加下拉刷新
        [_renqiWaterView addPullToRefreshWithActionHandler:^{
            NSLog(@"下拉更新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                renqiCurrentPageSelf = 1;
                renqiCurrentPage = 1;
                [blockSelf reloadRenqiData:renqiCurrentPageSelf block:^(NSMutableArray *info) {
                    //if ((info.count > 0) && [((ImageInfo *)[renqiArrayImageSelf objectAtIndexCheck:0]).thumbURL isEqualToString:[CustomUtil getPhotoURL:[[info objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString]) {
                      //  [blockSelf.renqiWaterView.pullToRefreshView stopAnimating];
                        //return;
                    //}
                    
                    [renqiArraySelf removeAllObjects];
                    [renqiArrayImageSelf removeAllObjects];
                    [renqiArraySelf addObjectsFromArray:info];
                    for (int i=0; i<[renqiArraySelf count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [renqiArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.renqiWaterView refreshView:renqiArrayImageSelf intoFlag:0];
                }];
                [blockSelf.renqiWaterView.pullToRefreshView stopAnimating];
            });
        }];
    } else if (2 == waterViewFlag) {
        if (!_tongchengWaterView) {
            _tongchengWaterView = [[ImageWaterView alloc] initWithDataArray:tongchengArrayImage withFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - 44 - 47) intoFlag:0];
        }
        _tongchengWaterView.delegate = self;
        _tongchengWaterView.imageViewClickDelegate = self;
        //添加上拉加载更多
        __weak MainPageTabBarController *blockSelf = self;
        __weak NSMutableArray *tongchengArrayImageSelf = tongchengArrayImage;
        __weak NSMutableArray *tongchengArraySelf = tongchengArray;
        __block int tongchengCurrentPageSelf = tongchengCurrentPage;
        [_tongchengWaterView addInfiniteScrollingWithActionHandler:^{
            NSLog(@"上拉刷新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                tongchengCurrentPageSelf++;
                tongchengCurrentPage = tongchengCurrentPageSelf;
                [blockSelf reloadTongchengData:tongchengCurrentPageSelf block:^(NSMutableArray *info) {
                    [tongchengArraySelf addObjectsFromArray:info];
                    [tongchengArrayImageSelf removeAllObjects];
                    for(int i=0; i<[info count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [tongchengArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.tongchengWaterView loadNextPage:tongchengArrayImageSelf intoFlag:0];
                }];
                [blockSelf.tongchengWaterView.infiniteScrollingView stopAnimating];
            });
        }];
        //添加下拉刷新
        [_tongchengWaterView addPullToRefreshWithActionHandler:^{
            NSLog(@"下拉更新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                tongchengCurrentPageSelf = 1;
                tongchengCurrentPage = 1;
                [blockSelf reloadTongchengData:tongchengCurrentPageSelf block:^(NSMutableArray *info) {
                    
                    //if ((info.count > 0) && [((ImageInfo *)[tongchengArrayImageSelf objectAtIndexCheck:0]).thumbURL isEqualToString:[CustomUtil getPhotoURL:[[info objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString]) {
                      //  [blockSelf.tongchengWaterView.pullToRefreshView stopAnimating];
                       // return;
                    //}
                    
                    [tongchengArraySelf removeAllObjects];
                    [tongchengArrayImageSelf removeAllObjects];
                    [tongchengArraySelf addObjectsFromArray:info];
                    for (int i=0; i<[tongchengArraySelf count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [tongchengArrayImageSelf addObject:imageInfo];
                        }
                    }
                    [blockSelf.tongchengWaterView refreshView:tongchengArrayImageSelf intoFlag:0];
                }];
                [blockSelf.tongchengWaterView.pullToRefreshView stopAnimating];
            });
        }];
    }
}

//开启定时器
-(void)addTimer
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAutoChangeBanner) userInfo:nil repeats:YES];
}

//广告中间imageView点击事件
-(void)centerImageViewClick
{
#ifdef OPEN_NET_INTERFACE
    NSString *urlAddress = @"";
    if ((centerImageWebLink.length > 7) && [[centerImageWebLink substringToIndex:7] isEqualToString:@"http://"]) {
        urlAddress = centerImageWebLink;
    } else if ((centerImageWebLink.length > 8) && [[centerImageWebLink substringToIndex:8] isEqualToString:@"https://"]) {
        urlAddress = centerImageWebLink;
    } else {
        urlAddress = [NSString stringWithFormat:@"http://%@", centerImageWebLink];
    }
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]]) {
        [CustomUtil showToastWithText:@"无效的网址" view:kWindow];
    }
#endif
}

#pragma mark -代理方法
//点击图片时的处理
-(void)imageViewClick:(ImageInfo *)imageInfo
{
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

//保存广告图至沙盒
-(void)saveBannerImageToSandBox
{
    //下载至相册
    for (int i=0; i<imageArray.count; i++) {
        GetBannerListInfo *bannerInfo = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:i]];
        //判断当前图片是否已下载
        NSArray *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *fileNameArray = [bannerInfo.bannerImg componentsSeparatedByString:@"/"];
        NSString *fileName = [fileNameArray objectAtIndexCheck:(fileNameArray.count - 1)];
        NSString *filePath = [[basePath objectAtIndexCheck:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"banner/%@", fileName]];
        NSString *directoryPath = [[basePath objectAtIndexCheck:0] stringByAppendingPathComponent:@"banner"];
        [bannerImagePathArray addObject:filePath];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if(![fileManager fileExistsAtPath:directoryPath isDirectory:nil]) {
            [fileManager createDirectoryAtPath:[[basePath objectAtIndexCheck:0] stringByAppendingPathComponent:@"banner"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([fileManager fileExistsAtPath:filePath]) {
            continue;
        }
        NSURL *url = [CustomUtil getPhotoURL:bannerInfo.bannerImg];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSMutableData *imageData = [[NSMutableData alloc] init];
        __block float imageLenth = 0; //图片长度
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                DLog(@"erro:%@", connectionError.localizedDescription);
            } else {
                //清空图片数据
                [imageData setLength:0];
                NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
                imageLenth = [[resp.allHeaderFields objectForKey:@"Content-Length"] floatValue];
                //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [imageData appendData:data];
                UIImage *image = [UIImage imageWithData:imageData];
                //保存至沙盒
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                GetBannerListInfo *info = [[GetBannerListInfo alloc] initWithDict:[imageArray objectAtIndexCheck:i]];
                NSArray *array = [info.bannerImg componentsSeparatedByString:@"/"];
                NSString *filePath = [[paths objectAtIndexCheck:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"banner/%@", array[array.count - 1]]];
                BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
                if (!result) {
                   // [CustomUtil showToastWithText:@"保存失败" view:kWindow];
                }
                //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }];
    }
}

//获取图片
-(UIImage *)getImage:(NSString *)bannerImgPath
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *strArry = [bannerImgPath componentsSeparatedByString:@"/"];
    NSString *fileName = strArry[strArry.count - 1];
    NSString *filePath = [[filePaths objectAtIndexCheck:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"banner/%@", fileName]];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
