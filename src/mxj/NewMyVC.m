//
//  NewMyVC.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/22.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "NewMyVC.h"
#import "NewMyCell.h"
#import "NewMyModel.h"

#import "PersonDocViewController.h"
#import "SetViewController.h"
#import "MyLevelViewController.h"
#import "MyFavoriteViewController.h"
#import "MyFollowFansViewController.h"
#import "MyBeansViewController.h"
#import "MyBeansCashViewController.h"
#import "SearchFriendViewController.h"
#import "NewMainPersonVC.h"
#import "MyStreetPhotoViewController.h"

#define TOPHEIGH 100
#define TOPLINE  10
@interface NewMyVC () <UITableViewDelegate, UITableViewDataSource>
{
    GetUserInfo *userInfo; //用户信息
}

@property (nonatomic, strong) UITableView       *myTableView;    //我的 TableView
@property (nonatomic, strong) GetUserInfo       *returnData;
@property (nonatomic, strong) NSMutableArray    *dataArray;
//@property (nonatomic, strong) NewMyModel        *dataModel;

@end

@implementation NewMyVC

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [self reloadProxy]; //关注 粉丝 收藏图片
   [self reSignTime];//我的连续签到天数
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touXiang:) name:@"touxianggaibian" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 64)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#E8423D"];
    [self.view addSubview:topView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 44, SCREENWIDTH, 44)];
    title.text = @"我的";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [topView addSubview:title];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREENWIDTH - 37, 32.5, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"iconNew.png"] forState:UIControlStateNormal];
    [topView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(searchFriend) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 405)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    //    _myTableView.scrollEnabled = NO;
    [self.view addSubview:_myTableView];
    
    [_myTableView reloadData];
}

//查询用户数据
-(void)reloadProxy
{
    NSMutableArray *subTitle = [NSMutableArray arrayWithCapacity:0];
    
    [GetUserInfoInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetUserInfoInput shareInstance].currentUserId = @"";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        _returnData = [GetUserInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(_returnData.status)) {
            //            [_myTableView reloadData];
            userInfo = [[GetUserInfo alloc] initWithDict:responseDict];
            NSString *str = [NSString stringWithFormat:@"关注%@人 粉丝%@人", userInfo.followNum, userInfo.fansNum];
            [subTitle addObject:str];
            
            [GetCollectionListInput shareInstance].pagesize = @"10";
            [GetCollectionListInput shareInstance].current = @"1";
            [GetCollectionListInput shareInstance].userId = [LoginModel shareInstance].userId;
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCollectionListInput shareInstance]];
            [[NetInterface shareInstance] getCollectionList:@"getCollectionList" param:dict successBlock:^(NSDictionary *responseDict) {
                GetCollectionList *returnData = [GetCollectionList modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    NSString *totStr = [NSString stringWithFormat:@"%@张图片",returnData.totalnum];
                    [subTitle addObject:totStr];
                    
                    [self initData:subTitle];
                    [self initView];
                }
            } failedBlock:^(NSError *err) {
            }];
        }
    } failedBlock:^(NSError *err) {
    }];
}

-(void)reSignTime{
//    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[LoginModel shareInstance].userId}];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/signIn/cumulativeSignTime" param:dict successBlock:^(NSDictionary *responseDict) {
        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            [LoginModel shareInstance].loginDays = [responseDict objectForKey:@"days"];
        }
    } failedBlock:^(NSError *err) {
    }];
}

-(void)initData:(NSMutableArray *)subTitle{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *titIcon = [[NSArray alloc] initWithObjects:@"friends",@"favourite",@"beansvc",@"getmoney",@"mainview",@"dengjivc",@"seticon", nil];
    NSArray *titleText = [[NSArray alloc] initWithObjects:@"我的好友",@"我的收藏",@"我的毛豆",@"充值提现",@"我的主页动态",@"我的等级",@"设置", nil];
//    NSMutableArray *subTitle = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < titleText.count; i++) {
        NewMyModel *dataModel = [[NewMyModel alloc] init];
        if (i < subTitle.count) {
            dataModel.subTitle = [subTitle objectAtIndex:i];
            dataModel.icon = 1;
        }
        dataModel.titleText = [titleText objectAtIndex:i];
        dataModel.titImg = [titIcon objectAtIndex:i];
        [_dataArray addObject:dataModel];
    }
    
    [_myTableView reloadData];

    
//    [GetUserInfoInput shareInstance].userId = [LoginModel shareInstance].userId;
//    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
//    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
//    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
//        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
//        if (RETURN_SUCCESS(returnData.status)) {
//                    }
//    } failedBlock:^(NSError *err) {
//    }];
    
    
    //    NSArray *subTitle = [[NSArray alloc] initWithObjects:@"关注28人 粉丝1245人",@"12张图片", nil];
    
    //    for (int i = 0; i < titleText.count; i++) {
    //       NewMyModel *dataModel = [[NewMyModel alloc] init];
    //        if (i < subTitle.count) {
    //            dataModel.subTitle = [subTitle objectAtIndex:i];
    //            dataModel.icon = 1;
    //        }
    //        dataModel.titleText = [titleText objectAtIndex:i];
    //        dataModel.titImg = [titIcon objectAtIndex:i];
    //        [_dataArray addObject:dataModel];
    //    }
}

- (void)searchFriend
{
    SearchFriendViewController *searchFriendViewCtrl = [[SearchFriendViewController alloc] initWithNibName:@"SearchFriendViewController" bundle:nil];
    [self.navigationController pushViewController:searchFriendViewCtrl animated:YES];
    
}

#pragma mark - delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return TOPHEIGH;
        default:
            return 44;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //    NewMyCell *cell = (NewMyCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    //    if (!cell) {
    NewMyCell *cell = [[NewMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row < 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    if (indexPath.row == 0) {
        if (_returnData) {
            [cell initDataWithModel:_returnData type:indexPath.row dataArray:_dataArray];
        }
    }else{
        if (_dataArray.count > 0) {
            [cell initDataWithModel:_returnData type:indexPath.row dataArray:_dataArray];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PersonDocViewController *personDocViewCtrl = [[PersonDocViewController alloc] initWithNibName:@"PersonDocViewController" bundle:nil];
        personDocViewCtrl.queryUserId = [LoginModel shareInstance].userId;
        [self.navigationController pushViewController:personDocViewCtrl animated:YES];
    }
    else if (indexPath.row == 1) {
        MyFollowFansViewController *mffVC = [[MyFollowFansViewController alloc] init];
        [self.navigationController pushViewController:mffVC animated:YES];
    }
    else if (indexPath.row == 2) {
        MyFavoriteViewController *myFavoriteViewCtrl = [[MyFavoriteViewController alloc] initWithNibName:@"MyFavoriteViewController" bundle:nil];
        [self.navigationController pushViewController:myFavoriteViewCtrl animated:YES];
    }
    else if (indexPath.row == 3) {
        MyBeansViewController *beansViewCtrl = [[MyBeansViewController alloc] init];
        [self.navigationController pushViewController:beansViewCtrl animated:YES];
    }
    else if (indexPath.row == 4) {
        MyBeansCashViewController *vc = [[MyBeansCashViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5) {
//        NewMainPersonVC *vc = [[NewMainPersonVC alloc] init];
//        vc.userId = [LoginModel shareInstance].userId;
//        vc.type = 0;
//        [self.navigationController pushViewController:vc animated:YES];
        
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];

    }
    else if (indexPath.row == 7) {
        SetViewController *setViewCtrl = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
        [self.navigationController pushViewController:setViewCtrl animated:YES];
    }
    else if (indexPath.row == 6) {
        MyLevelViewController *myLevelViewCtrl = [[MyLevelViewController alloc] initWithNibName:@"MyLevelViewController" bundle:nil];
        [self.navigationController pushViewController:myLevelViewCtrl animated:YES];
    }
}

-(void)touXiang:(NSNotification *)sender{
    
    _returnData.image = sender.userInfo[@"img"];
    _returnData.userName = sender.userInfo[@"name"];
    [_myTableView reloadData];
}

@end
