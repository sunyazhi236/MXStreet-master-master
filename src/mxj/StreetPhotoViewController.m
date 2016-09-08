//
//  StreetPhotoViewController.m
//  mxj
//  P7-5街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "StreetPhotoViewController.h"
#import "SearchViewController.h"
#import "SearchFriendViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "StreetSearchListViewController.h"

#define SCROLLVIEW_BUTTON_HEIGHT 69

#define SCROLLVIEW_BUTTON_WEIGHT 112

#define SCROLLVIEW_OFFST_Y 15

#define SCROLLVIEW_OFFST_X 5

@interface StreetPhotoViewController ()
{
    NSMutableArray *data; //街拍数据
    int currentPageNum;      //当前页
}
@end

@implementation StreetPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1;
    
    [self initHeadView];
    
    [self setSelfWaterView];
    //[self reloadData];
    
    /*
    if (![TKLoginType shareInstance].loginType) {
        [_inviteUserImageView setHidden:YES];
        [_inviteUserBtn setHidden:YES];
        
        //将邀请好友按钮替换为返回按钮
        CGRect rect = _inviteUserImageView.frame;
        rect.size.height = 18;
        rect.size.width = 12;
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:rect];
        [backImageView setImage:[UIImage imageNamed:@"return"]];
        [self.view addSubview:backImageView];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:_inviteUserBtn.frame];
        [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
     */
}

- (void)initHeadView
{
    _searchBar.backgroundImage = [CustomUtil imageFromColor:[UIColor clearColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, GetY(_searchBar) - 5, SCREENWIDTH, 50);
    [button addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _scrollView = [[UIScrollView alloc] init];
    
    NSArray *titles = @[@"棒针\nKnitting",@"钩针\nCrochet",@"缝纫\nSewing",@"工具\nTools"];//@"店铺\nShop"
    NSArray *images = @[@"棒针",@"钩针",@"缝纫",@"工具"];//@"店铺"
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCROLLVIEW_OFFST_X * (i + 1) + SCROLLVIEW_BUTTON_WEIGHT * i, SCROLLVIEW_OFFST_Y, SCROLLVIEW_BUTTON_WEIGHT, SCROLLVIEW_BUTTON_HEIGHT);
        button.tag = i;
        [button addTarget:self action:@selector(searchType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[NSString stringWithFormat:@"%@", titles[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scrollView addSubview:button];
    }
    
    _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCROLLVIEW_BUTTON_HEIGHT + SCROLLVIEW_OFFST_Y * 2);
    _scrollView.backgroundColor = [UIColor whiteColor];
//    _scrollView.contentSize = CGSizeMake(SCROLLVIEW_OFFST_X * 6 + SCROLLVIEW_BUTTON_WEIGHT * 5 + 1, GetHeight(_scrollView));
    _scrollView.contentSize = CGSizeMake(SCROLLVIEW_BUTTON_WEIGHT * 4 + SCROLLVIEW_OFFST_X * 5, GetHeight(_scrollView));
    [self.view addSubview:_scrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (1 == currentPageNum) {
        [_waterView triggerPullToRefresh];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//搜索分类点击事件
- (void)searchType:(UIButton *)button
{
    NSLog(@"%d=%@",(int)button.tag,button.titleLabel.text);
    StreetSearchListViewController *vc = [[StreetSearchListViewController alloc] initWithType:button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

//搜索好友按钮点击事件
- (IBAction)searchFriendBtn:(id)sender {
    SearchFriendViewController *searchFriendViewCtrl = [[SearchFriendViewController alloc] initWithNibName:@"SearchFriendViewController" bundle:nil];
    [self.navigationController pushViewController:searchFriendViewCtrl animated:YES];
}

//搜索标签或用户按钮点击事件
- (void)searchBtnClick:(id)sender {
    SearchViewController *searchViewCtrl = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewCtrl animated:YES];
}

//返回按钮点击事件
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置瀑布流
-(void)setSelfWaterView
{
#ifdef OPEN_NET_INTERFACE
    //解析数据
    NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
    for (int i=0; i<[data count]; i++) {
        NSDictionary *dataD = [data objectAtIndexCheck:i];
        if (dataD) {
            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
            [arrayImage addObject:imageInfo];
        }
    }
    if(!_waterView) {
        self.waterView = [[ImageWaterView alloc] initWithDataArray:arrayImage withFrame:CGRectMake(0, GetHeight(_scrollView) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - GetHeight(_scrollView)) intoFlag:0];
    }
    self.waterView.imageViewClickDelegate = self;
    //添加上拉加载更多
    __weak StreetPhotoViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __weak NSMutableArray *dataSelf = data;
    [self.waterView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉刷新");
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            currentPageNum = currentPageNumSelf;
            [blockSelf refreshData:[NSString stringWithFormat:@"%d", currentPageNumSelf] block:^{
                [arrayImage removeAllObjects];
                for (int i=0; i<dataSelf.count; i++) {
                    NSDictionary *dataD = [dataSelf objectAtIndexCheck:i];
                    if (dataD) {
                        ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                        [arrayImage addObject:imageInfo];
                    }
                }
                [blockSelf.waterView loadNextPage:arrayImage intoFlag:0];
                [blockSelf.waterView.infiniteScrollingView stopAnimating];
            } errorBlock:^{
                [blockSelf.waterView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
    
    
    //添加下拉刷新
    [self.waterView addPullToRefreshWithActionHandler:^{
        NSLog(@"下拉更新");
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf = 1;
            currentPageNum = 1;
            [blockSelf refreshData:[NSString stringWithFormat:@"%d", currentPageNumSelf] block:^{
                //if ((dataSelf.count > 0) && ([[CustomUtil getPhotoURL:[[dataSelf objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString isEqualToString:((ImageInfo *)[arrayImage objectAtIndexCheck:0]).thumbURL])) {
                  //  [blockSelf.waterView.pullToRefreshView stopAnimating];
                    //return;
                //}
                [arrayImage removeAllObjects];
                for (int i=0; i<dataSelf.count; i++) {
                    NSDictionary *dataD = [dataSelf objectAtIndexCheck:i];
                    if (dataD) {
                        ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                        [arrayImage addObject:imageInfo];
#ifdef CACHE_SWITCH
                        //保存个人头像
                        NSURL *personImageUrl = [CustomUtil getPhotoURL:imageInfo.image];
                        [CacheService saveDataToSandBox:NSStringFromClass([blockSelf class]) data:personImageUrl flag:0 imageFlag:(i + 10)];
                        //保存街拍首图
                        [CacheService saveDataToSandBox:NSStringFromClass([blockSelf class]) data:[NSURL URLWithString:imageInfo.thumbURL] flag:0 imageFlag:i];
#endif
                    }
                }
#ifdef CACHE_SWITCH
                //保存文本数据
                [CacheService saveDataToSandBox:NSStringFromClass([blockSelf class]) data:dataSelf flag:0 imageFlag:100];
#endif
                [blockSelf.waterView refreshView:arrayImage intoFlag:0];
                [blockSelf.waterView.pullToRefreshView stopAnimating];
            } errorBlock:^{
                [blockSelf.waterView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    [self.view addSubview:self.waterView];
#else
    //解析数据
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Data" ofType:@"json"];
    NSString *string = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [string objectFromJSONString];
    NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dataD = [array objectAtIndexCheck:i];
        if (dataD) {
            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
            [arrayImage addObject:imageInfo];
        }
    }
    NSLog(@"%@", arrayImage);
    
    self.waterView = [[ImageWaterView alloc] initWithDataArray:arrayImage withFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) intoFlag:0];
    self.waterView.imageViewClickDelegate = self;
    //添加上拉加载更多
    __weak StreetPhotoViewController *blockSelf = self;
    [self.waterView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉刷新");
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [blockSelf.waterView loadNextPage:arrayImage intoFlag:0];
            [blockSelf.waterView.infiniteScrollingView stopAnimating];
        });
    }];
    //添加下拉刷新
    [self.waterView addPullToRefreshWithActionHandler:^{
        NSLog(@"下拉更新");
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [blockSelf.waterView refreshView:arrayImage intoFlag:0];
            [blockSelf.waterView.pullToRefreshView stopAnimating];
        });
    }];
    [self.view addSubview:self.waterView];
#endif
}

//加载数据
-(void)reloadData
{
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = @"1";
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"4"; //无条件查询
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            //取数据
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                [data addObject:infoDict];
            }
#ifdef CACHE_SWITCH
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dataD = [data objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [dataArray addObject:imageInfo];
                    
                    //保存用户头像
                    NSURL *personImageUrl = [CustomUtil getPhotoURL:imageInfo.image];
                    [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:personImageUrl flag:0 imageFlag:(i + 10)];
                    //缓存街拍首图
                    [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:[NSURL URLWithString:imageInfo.thumbURL] flag:0 imageFlag:i];
                }
            }
            //缓存文本数据
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:data flag:0 imageFlag:100];
#endif
            [self setSelfWaterView];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
        if ((-1009) == err.code) {
            //读取缓存数据
            NSMutableArray *array = (NSMutableArray *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:0];
            [data removeAllObjects];
            [data addObjectsFromArray:array];
            [self setSelfWaterView];
        }
#endif
    }];
}

//刷新数据
-(void)refreshData:(NSString *)currentPage block:(void(^)())block errorBlock:(void(^)())errorBlock
{
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = currentPage;
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"4"; //无条件查询
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            //取数据
            [data removeAllObjects];
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                [data addObject:infoDict];
            }
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
        errorBlock();
    }];
}

#pragma mark -代理方法
//图片点击事件
-(void)imageViewClick:(ImageInfo *)imageInfo
{
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
