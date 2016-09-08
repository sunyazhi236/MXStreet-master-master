//
//  MyFavoriteViewController.m
//  mxj
//  我的收藏
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "StreetPhotoDetailViewController.h"

@interface MyFavoriteViewController ()
{
#ifdef OPEN_NET_INTERFACE
    NSMutableArray *data; //获取的数据
    NSMutableArray *arrayImage; //图片数组
    int currentPageNum;         //当前页号
#endif
}
@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的收藏"];
#ifdef OPEN_NET_INTERFACE
    data = [[NSMutableArray alloc] init];
    arrayImage = [[NSMutableArray alloc] init];
    currentPageNum = 1; //当前页从1开始
#endif
    [self setSelfWaterView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置瀑布流
-(void)setSelfWaterView
{
#ifdef OPEN_NET_INTERFACE
    //从服务器端获取数据
    [GetCollectionListInput shareInstance].pagesize = @"10";
    [GetCollectionListInput shareInstance].current = @"1";
    [GetCollectionListInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCollectionListInput shareInstance]];
    [[NetInterface shareInstance] getCollectionList:@"getCollectionList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetCollectionList *returnData = [GetCollectionList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            for (int i=0; i<returnData.info.count; i++) {
                DLog(@"%@", returnData.info[i]);
                [data addObject:returnData.info[i]];
            }
            //解析数据
            for (int i=0; i<[data count]; i++) {
                NSDictionary *dataD = [data objectAtIndexCheck:i];
                if (![dataD isEqual:@""]) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                    [arrayImage addObject:imageInfo];
                }
            }
            
            self.waterView = [[ImageWaterView alloc] initWithDataArray:arrayImage withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intoFlag:1];
            self.waterView.imageViewClickDelegate = self;
            
            //添加上拉加载更多
            __weak MyFavoriteViewController *blockSelf = self;
            __block NSMutableArray *selfArrayImage = arrayImage;
            __block int currentPageNumSelf = currentPageNum;
            __weak NSMutableArray *dataSelf = data;
            [self.waterView addInfiniteScrollingWithActionHandler:^{
                NSLog(@"上拉刷新");
                //使用GCD开启一个线程，使圈圈转2秒
                int64_t delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    currentPageNumSelf++;
                    [dataSelf removeAllObjects];
                    [selfArrayImage removeAllObjects];
                    [blockSelf refreashData:[NSString stringWithFormat:@"%d", currentPageNumSelf] block:^{
                        for (int i=0; i<[dataSelf count]; i++) {
                            NSDictionary *dataD = [dataSelf objectAtIndexCheck:i];
                            if (![dataD isEqual:@""]) {
                                ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                                [selfArrayImage addObject:imageInfo];
                            }
                        }
                        [blockSelf.waterView loadNextPage:selfArrayImage intoFlag:1];
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
                    [dataSelf removeAllObjects];
                    [selfArrayImage removeAllObjects];
                    [blockSelf refreashData:[NSString stringWithFormat:@"%d", currentPageNumSelf] block:^{
                        for (int i=0; i<[dataSelf count]; i++) {
                            NSDictionary *dataD = [dataSelf objectAtIndexCheck:i];
                            if (![dataD isEqual:@""]) {
                                ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                                [selfArrayImage addObject:imageInfo];
                            }
                        }
                        [blockSelf.waterView refreshView:selfArrayImage intoFlag:1];
                        [blockSelf.waterView.pullToRefreshView stopAnimating];
                    }];
                });
            }];
            [self.view addSubview:self.waterView];
        }
    } failedBlock:^(NSError *err) {
    }];
#else
    //解析数据
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Data1" ofType:@"json"];
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
    
    self.waterView = [[ImageWaterView alloc] initWithDataArray:arrayImage withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intoFlag:1];
    self.waterView.imageViewClickDelegate = self;
    
    //添加上拉加载更多
    __weak MyFavoriteViewController *blockSelf = self;
    [self.waterView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉刷新");
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [blockSelf.waterView loadNextPage:arrayImage intoFlag:1];
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
            [blockSelf.waterView refreshView:arrayImage intoFlag:1];
            [blockSelf.waterView.pullToRefreshView stopAnimating];
        });
    }];
    [self.view addSubview:self.waterView];
#endif
}

//刷新数据
-(void)refreashData:(NSString *)currentPageNum block:(void(^)())block
{
    [GetCollectionListInput shareInstance].pagesize = @"10";
    [GetCollectionListInput shareInstance].current = currentPageNum;
    [GetCollectionListInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCollectionListInput shareInstance]];
    [[NetInterface shareInstance] getCollectionList:@"getCollectionList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetCollectionList *returnData = [GetCollectionList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            for (int i=0; i<returnData.info.count; i++) {
                [data addObject:returnData.info[i]];
            }
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -代理方法
//图片点击事件
-(void)imageViewClick:(ImageInfo *)imageInfo
{
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId1;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
