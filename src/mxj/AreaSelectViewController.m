//
//  AreaSelectViewController.m
//  mxj
//  P12-1-3-1中国地区设置实现文件
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "AreaSelectTableCell.h"
#import "OwnAreaViewController.h"
#import "TabBarController.h"
#import "PersonDocViewController.h"
#import "RegisterCreatePersonInfViewController.h"
#import "MainPageTabBarController.h"
#import "InformationVC.h"

@interface AreaSelectViewController ()
{
    NSArray *provanceNameArray; //省名数组
    NSArray *cityNameArray;     //市名数组
    
    NSMutableArray *provinceArray; //省份数组
    NSMutableArray *cityArray;     //城市数组
    
    int provinceFlag;              //省份当前页码
    int cityFlag;                  //城市当前页码
}

@end

@implementation AreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch ([self.intoFlag intValue]) {
        case 0:
            [self.navigationItem setTitle:@"地区选择"];
            break;
        case 1:
            [self.navigationItem setTitle:@"城市选择"];
            break;
        default:
            break;
    }
    provinceArray = [[NSMutableArray alloc] init];
    cityArray = [[NSMutableArray alloc] init];
    provinceFlag = 1;
    cityFlag = 1;
    
    /*
    //添加上拉及下拉刷新
    //添加上拉加载更多
    __weak AreaSelectViewController *blockSelf = self;
    __block int provinceFlagSelf = provinceFlag;
    __block int cityFlagSelf = cityFlag;
    __block NSString * _intoFlagSelf = _intoFlag;
    //下拉刷新
    [_areaSelectTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([_intoFlagSelf isEqualToString:@"0"]) {   //省进入
                provinceFlagSelf = 1;
            } else if ([_intoFlagSelf isEqualToString:@"1"]) { //市进入
                cityFlagSelf = 1;
            }
            [blockSelf reloadData:provinceFlagSelf cityNum:cityFlagSelf block:^{
                [blockSelf.areaSelectTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_areaSelectTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([_intoFlagSelf isEqualToString:@"0"]) {  //省进入
                provinceFlagSelf++;
            } else if ([_intoFlagSelf isEqualToString:@"1"]) { //市进入
                cityFlagSelf++;
            }
            [blockSelf reloadData:provinceFlagSelf cityNum:cityFlagSelf block:^{
                [blockSelf.areaSelectTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
     */
#ifdef OPEN_NET_INTERFACE
    [self reloadData:provinceFlag cityNum:cityFlag block:^{
    }];
#else
    provanceNameArray = [[NSArray alloc] initWithObjects:@"安徽省",
                                                         @"澳门特别行政区",
                                                         @"北京市",
                                                         @"重庆市",
                                                         @"上海市",
                                                         @"贵州省",
                                                         @"湖北省",
                                                         @"湖南省",
                                                         @"河北省",
                                                         @"河南省",
                                                         @"黑龙江省",
                                                         nil];
    cityNameArray = [[NSArray alloc] initWithObjects:@"黄山市",
                     @"合肥市",
                     @"六安市",
                     @"重庆市",
                     @"毫州市",
                     @"宿州市",
                     @"阜阳市",
                     @"蚌埠市",
                     @"淮南市",
                     @"滁州市",
                     @"巢湖市",
                     nil];
#endif
    _areaSelectTableView.delegate = self;
    _areaSelectTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([@"0" isEqualToString:_intoFlag]) {
#ifdef OPEN_NET_INTERFACE
        numberOfRows = provinceArray.count;
#else
        numberOfRows = provanceNameArray.count;
#endif
    }
    if ([@"1" isEqualToString:_intoFlag]) {
#ifdef OPEN_NET_INTERFACE
        numberOfRows = cityArray.count;
#else
        numberOfRows = cityNameArray.count;
#endif
    }
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaSelectTableCell *tableCell = (AreaSelectTableCell *)[tableView dequeueReusableCellWithIdentifier:@"areaSelectTableCell"];
    if (!tableCell) {
        tableCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaSelectTableCell" owner:self options:nil] lastObject];
    }
    if ([@"0" isEqualToString:_intoFlag]) {
#ifdef OPEN_NET_INTERFACE
            NSDictionary *provinceInfo = (NSDictionary *)[provinceArray objectAtIndexCheck:indexPath.row];
            GetProvinceListInfo *info = [[GetProvinceListInfo alloc] initWithDict:provinceInfo];
            [tableCell setCell:info.provinceName];
            
#else
            [tableCell setCell:[provanceNameArray objectAtIndexCheck:indexPath.row]];
#endif
            if (indexPath.row == (provanceNameArray.count - 1)) { //隐藏最后一行下方的下划线
                [tableCell.downLineImageView setHidden:YES];
            }
    } else if ([@"1" isEqualToString:_intoFlag]) {
#ifdef OPEN_NET_INTERFACE
            NSDictionary *dict = [cityArray objectAtIndexCheck:indexPath.row];
            GetCityListInfo *info = [[GetCityListInfo alloc] initWithDict:dict];
            [tableCell setCell:info.cityName];
#else
            [tableCell setCell:[cityNameArray objectAtIndexCheck:indexPath.row]];
#endif
            if (indexPath.row == (cityNameArray.count - 1)) { //隐藏最后一行下方的下划线
                [tableCell.downLineImageView setHidden:YES];
            }
    }
    
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([@"0" isEqualToString:_intoFlag]) {
        //进入城市选择界面
        AreaSelectViewController *viewCtrl = [[AreaSelectViewController alloc] initWithNibName:@"AreaSelectViewController" bundle:nil];
        viewCtrl.intoFlag = @"1";
        viewCtrl.mainIntoFlag = _mainIntoFlag;
        NSDictionary *provinceDic = [provinceArray objectAtIndexCheck:indexPath.row];
        GetProvinceListInfo *info = [[GetProvinceListInfo alloc] initWithDict:provinceDic];
        viewCtrl.selectProvinceId = info.provinceId;
        
        [TKPostion shareInstance].provinceName = info.provinceName;
        [RegisterInput shareInstance].province = info.provinceName;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else if ([@"1" isEqualToString:_intoFlag]) {
        switch (_mainIntoFlag) {
            case 0: //回到首界面
            {
                for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                    if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                        NSDictionary *cityDic = [cityArray objectAtIndexCheck:indexPath.row];
                        GetCityListInfo *info = [[GetCityListInfo alloc] initWithDict:cityDic];
                        TabBarController *tabBarViewCtrl = ((TabBarController *)viewCtrl);
                        for (UIViewController *ctrl in [tabBarViewCtrl viewControllers]) {
                            if ([ctrl isKindOfClass:[MainPageTabBarController class]]) {
                                MainPageTabBarController *tabBarCtrl = (MainPageTabBarController *)ctrl;
                                tabBarCtrl.cityName = info.cityName;
                                tabBarCtrl.cityFlag = @"1";
                            }
                        }
                        [self.navigationController popToViewController:viewCtrl animated:YES];
                    }
                }
            }
                break;
            case 1: //回到个人资料界面
            {
                NSDictionary *cityDic = [cityArray objectAtIndexCheck:indexPath.row];
                GetCityListInfo *info = [[GetCityListInfo alloc] initWithDict:cityDic];
                [TKPostion shareInstance].cityName = info.cityName;
                //修改个人资料
                [ModifyUserDataInput shareInstance].province = [TKPostion shareInstance].provinceName;
                [ModifyUserDataInput shareInstance].city = [TKPostion shareInstance].cityName;
                [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
                [ModifyUserDataInput shareInstance].userSignFlag = @"0";
                [ModifyUserDataInput shareInstance].storeFlag = @"0";
                NSMutableDictionary *modifyUserDataDic = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
                [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:modifyUserDataDic successBlock:^(NSDictionary *responseDict) {
                    ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                    if (RETURN_SUCCESS(returnData.status)) {
                        [LoginModel shareInstance].province = [TKPostion shareInstance].provinceName;
                        [LoginModel shareInstance].city = [TKPostion shareInstance].cityName;
                        for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                            if ([viewCtrl isKindOfClass:[PersonDocViewController class]]) {
                                [self.navigationController popToViewController:viewCtrl animated:YES];
                            }
                        }
                    }
                } failedBlock:^(NSError *err) {
                }];
            }
                break;
            case 2: //回到注册界面
            {
                NSDictionary *cityDict = [cityArray objectAtIndexCheck:indexPath.row];
                GetCityListInfo *info = [[GetCityListInfo alloc] initWithDict:cityDict];
                [TKPostion shareInstance].cityName = info.cityName;
                for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
//                    if ([viewCtrl isKindOfClass:[RegisterCreatePersonInfViewController class]]) {
                    if ([viewCtrl isKindOfClass:[InformationVC class]]) {
                        [RegisterInput shareInstance].city = info.cityName;
                        [TKPostion shareInstance].isArea = YES;
                        [self.navigationController popToViewController:viewCtrl animated:YES];
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}

-(void)reloadData:(int)provinceNum cityNum:(int)cityNum block:(void(^)())block
{
    if ([@"0" isEqualToString:_intoFlag]) { //省份选择
        [self reloadDataForProvince:provinceNum block:block];
    } else if ([@"1" isEqualToString:_intoFlag]) { //城市选择
        [self reloadDataForCity:cityNum block:block];
    }
}

//加载省份列表
-(void)reloadDataForProvince:(int)currentNum block:(void(^)())block
{
    if (1 == currentNum) {
        [provinceArray removeAllObjects];
    }
    //获取省份列表
    [GetProvinceListInput shareInstance].pagesize = @"100";
    [GetProvinceListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentNum];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetProvinceListInput shareInstance]];
    [[NetInterface shareInstance] getProvinceList:@"getProvinceList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetProvinceList *returnData = [GetProvinceList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                [provinceArray addObject:infoDict];
            }
            [_areaSelectTableView reloadData];
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

//加载城市列表
-(void)reloadDataForCity:(int)currentNum block:(void(^)())block
{
    if (1 == currentNum) {
        [cityArray removeAllObjects];
    }
    //获取城市列表
    [GetCityListInput shareInstance].pagesize = @"100";
    [GetCityListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentNum];
    [GetCityListInput shareInstance].provinceId = _selectProvinceId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCityListInput shareInstance]];
    [[NetInterface shareInstance] getCityList:@"getCityList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetCityList *returnData = [GetCityList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                [cityArray addObject:infoDict];
            }
            [_areaSelectTableView reloadData];
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

@end
