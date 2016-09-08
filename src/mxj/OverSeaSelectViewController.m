//
//  OverSeaSelectViewController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "OverSeaSelectViewController.h"
#import "OverSeaTableCell.h"
#import "OverSeaHeadCell.h"
#import "TabBarController.h"
#import "PersonDocViewController.h"
#import "RegisterCreatePersonInfViewController.h"
#import "MainPageTabBarController.h"

#define kCountryCodeFirstChar @"ABCDEFGHIJKLMNOPQRSTUVWXYZ" //国家名称缩写首字母

@interface OverSeaSelectViewController ()
{
    NSMutableArray *data; //数据
    NSMutableArray *groupData; //分组数据
}
@end

@implementation OverSeaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"海外地区选择"];
    [self.overSeaSelectTableView setDelegate:self];
    [self.overSeaSelectTableView setDataSource:self];
    
    data = [[NSMutableArray alloc] init];
    groupData = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadData:1 block:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载数据
-(void)reloadData:(int)currentPage block:(void(^)())block
{
    //查询国家列表
    [GetCountryListInput shareInstance].pagesize = @"200"; //按200个国家获取
    [GetCountryListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPage];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCountryListInput shareInstance]];
    [[NetInterface shareInstance] getCountryList:@"getCountryList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetCountryList *returnData = [GetCountryList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [data removeAllObjects];
            [groupData removeAllObjects];
            for (int i=0; i<returnData.info.count; i++) {
                GetCountryListInfo *info = [returnData.info objectAtIndexCheck:i];
                [data addObject:info];
            }
            //获取分组数据
            [self getGroupData];
            [_overSeaSelectTableView reloadData];
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return groupData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TKCountryGroup *countryGroup = [groupData objectAtIndexCheck:section];
    return countryGroup.countryListInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OverSeaTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overSeaTableCellIdentifier"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OverSeaTableCell" owner:self options:nil] lastObject];
    }
    TKCountryGroup *countryGroup = [groupData objectAtIndexCheck:indexPath.section];
    GetCountryListInfo *info = [countryGroup.countryListInfo objectAtIndexCheck:indexPath.row];
    cell.nameEnglishLabel.text = info.nameEnglish;
    cell.nameChineseLabel.text = info.nameChinese;
    cell.codeLabel.text = info.code;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OverSeaHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverSeaHeaderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OverSeaHeadCell" owner:self options:nil] lastObject];
    }
    TKCountryGroup *countryGroup = [groupData objectAtIndexCheck:section];
    cell.groupName.text = countryGroup.groupName;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKCountryGroup *countryGroup = [groupData objectAtIndexCheck:indexPath.section];
    GetCountryListInfo *info = [countryGroup.countryListInfo objectAtIndexCheck:indexPath.row];
    switch (_mainIntoFlag) {
        case 0: //返回首页
        {
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                    TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                    MainPageTabBarController *ctrl = (MainPageTabBarController *)(tabBarCtrl.viewControllers[0]);
                    ctrl.cityName = info.nameChinese;
                    ctrl.cityFlag = @"1";
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
        }
            break;
        case 1: //返回个人资料
        {
            [TKPostion shareInstance].countryName = info.nameChinese;
            [TKPostion shareInstance].provinceName = @"";
            [TKPostion shareInstance].cityName = @"";
            //修改个人资料
            [ModifyUserDataInput shareInstance].country = info.nameChinese;
            [ModifyUserDataInput shareInstance].province = @"";
            [ModifyUserDataInput shareInstance].city = @"";
            [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
            [ModifyUserDataInput shareInstance].userSignFlag = @"0";
            [ModifyUserDataInput shareInstance].storeFlag = @"0";
            NSMutableDictionary *modifyUserDataDic = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
            [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:modifyUserDataDic successBlock:^(NSDictionary *responseDict) {
                ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
                if (RETURN_SUCCESS(returnData.status)) {
                    [LoginModel shareInstance].country = info.nameChinese;
                    [LoginModel shareInstance].province = @"";
                    [LoginModel shareInstance].city = @"";
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
        case 2: //返回注册界面
        {
            [TKPostion shareInstance].countryName = info.nameChinese;
            [TKPostion shareInstance].provinceName = @"";
            [TKPostion shareInstance].cityName = @"";
            [RegisterInput shareInstance].country = info.nameChinese;
            [RegisterInput shareInstance].province = @"";
            [RegisterInput shareInstance].city = @"";
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                if ([viewCtrl isKindOfClass:[RegisterCreatePersonInfViewController class]]) {
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}

//获取分组数据
-(void)getGroupData
{
    for (int i=0; i<kCountryCodeFirstChar.length; i++) {
        NSString *firstChar = [kCountryCodeFirstChar substringWithRange:NSMakeRange(i, 1)];
        TKCountryGroup *countryGroup = [[TKCountryGroup alloc] init];
        countryGroup.groupName = firstChar;
        for (int j=0; j<data.count; j++) {
            GetCountryListInfo *info = [[GetCountryListInfo alloc] initWithDict:[data objectAtIndexCheck:j]];
            if ([[info.nameEnglish substringWithRange:NSMakeRange(0, 1)] isEqualToString:firstChar]) {
                [countryGroup.countryListInfo addObject:info];
            }
        }
        [groupData addObject:countryGroup];
    }
}

@end
