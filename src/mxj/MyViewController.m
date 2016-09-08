//
//  MyViewController.m
//  mxj
//  P9我的 视图控制器实现文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MyViewController.h"
#import "ConcernManViewController.h"
#import "MeFansViewController.h"
#import "SetViewController.h"
#import "MyStreetPhotoViewController.h"
#import "MyFavoriteViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询用户数据
-(void)reloadData
{
    [GetUserInfoInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetUserInfoInput shareInstance].currentUserId = @"";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [_myTableView reloadData];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 79.5;
        default:
            return 44;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:  //首行Cell
        {
            _personImageView.imageURL = [CustomUtil getPhotoURL:[GetUserInfo shareInstance].image];
            [CustomUtil setImageViewCorner:_personImageView];
            _userNameLabel.text = [GetUserInfo shareInstance].userName;
            if ([[GetUserInfo shareInstance].userLevel isEqualToString:@"6"]) {
                _levelLabel.text = @"达人";
                _lessPointLabel.text = @"";
            } else {
                _levelLabel.text = [NSString stringWithFormat:@"LV%@", [GetUserInfo shareInstance].userLevel];
                _lessPointLabel.text = [NSString stringWithFormat:@"(距离LV%d升级需%@点经验)", [[GetUserInfo shareInstance].userLevel intValue] + 1, [GetUserInfo shareInstance].lessPoint];
            }
            _userDoorIdLabel.text = [GetUserInfo shareInstance].userDoorId;
        }
            return self.firstTableCell;
        case 1:  //关注Cell
            return self.guangzhuTableCell;
        case 2:  //粉丝Cell
            return self.fensiTableCell;
        case 3:  //收藏Cell
            return self.shoucangTableCell;
        case 4:  //设置Cell
            return self.shezhiTableCell;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //首行Cell
        {
            MyStreetPhotoViewController *myStreetPhotoViewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
            [self.navigationController pushViewController:myStreetPhotoViewCtrl animated:YES];
        }
            break;
        case 1: //关注的人
        {
            ConcernManViewController *concernManViewCtrl = [[ConcernManViewController alloc] initWithNibName:@"ConcernManViewController" bundle:nil];
            concernManViewCtrl.userId = [LoginModel shareInstance].userId;
            [self.navigationController pushViewController:concernManViewCtrl animated:YES];
        }
            break;
        case 2:  //我的粉丝
        {
            MeFansViewController *meFansViewCtrl = [[MeFansViewController alloc] initWithNibName:@"MeFansViewController" bundle:nil];
            meFansViewCtrl.userId = [LoginModel shareInstance].userId;
            [self.navigationController pushViewController:meFansViewCtrl animated:YES];
        }
            break;
        case 3: //我的收藏
        {
            MyFavoriteViewController *myFavoriteViewCtrl = [[MyFavoriteViewController alloc] initWithNibName:@"MyFavoriteViewController" bundle:nil];
            [self.navigationController pushViewController:myFavoriteViewCtrl animated:YES];
        }
            break;
        case 4:  //设置
        {
            SetViewController *setViewCtrl = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
            [self.navigationController pushViewController:setViewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
