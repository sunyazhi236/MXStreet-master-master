//
//  PositionSetViewController.m
//  mxj
//  P7-3-1设置位置信息
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#define CONST_LINE_COUNT 2 //固定显示的行数

#import "PositionSetViewController.h"
#import "PositionSetCell.h"

@interface PositionSetViewController ()
{
    AMapSearchAPI *_search;            //地图搜索
    NSMutableArray *searchResultArray; //搜索结果
    NSInteger selectIndex;             //当前选中的Cell
    NSString *locationCityName;        //定位城市
    CLLocation *location;              //当前地址
    //MBProgressHUD *hud;                //提示框
}

@end

@implementation PositionSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.positionSetTableView.delegate = self;
    self.positionSetTableView.dataSource = self;
    self.positionSetTextFiled.delegate = self;
    self.positionSetTextFiled.returnKeyType = UIReturnKeySearch;
    searchResultArray = [[NSMutableArray alloc] init];
    selectIndex = 0; //默认选中第一行Cell
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [_positionSetTextFiled setReturnKeyType:UIReturnKeyDone];
    //注册
    [MAMapServices sharedServices].apiKey = GAODEDITU_APPKEY;
    [AMapSearchServices sharedServices].apiKey = GAODEDITU_APPKEY;
    //开启定位
    [CustomUtil getLocationInfo:^(AMapLocationReGeocode *regoCode, CLLocation *position) {
        if ([CustomUtil CheckParam:regoCode.city]) {
            locationCityName = regoCode.province;
        } else {
            locationCityName = regoCode.city;
        }
        location = position;
        [self searchMapWithKeyWord:@"" location:location];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResultArray.count + CONST_LINE_COUNT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PositionSetCell *positionSetCell = [tableView dequeueReusableCellWithIdentifier:@"PositionSetCell"];
    if (!positionSetCell) {
        positionSetCell = [[[NSBundle mainBundle] loadNibNamed:@"PositionSetCell" owner:self options:nil] lastObject];
    }
    if (selectIndex == indexPath.row) {
        [positionSetCell.labelImageView setHidden:NO];
    } else {
        [positionSetCell.labelImageView setHidden:YES];
    }
    
    switch (indexPath.row) {
        case 0:  //不显示位置选项
        {
            positionSetCell.labelName.text = @"不显示位置";
            [positionSetCell.labelAddress setHidden:YES];
            [positionSetCell.labelName setTextColor:[UIColor colorWithRed:83/255.0 green:101/255.0 blue:127/255.0 alpha:1.0]];
            [positionSetCell setLabelPostion:YES];
        }
            break;
        case 1:  //定位城市选项
        {
            if ([CustomUtil CheckParam:locationCityName]) {
                positionSetCell.labelName.text = @"获取定位失败";
                [positionSetCell.labelAddress setHidden:YES];
                [positionSetCell.labelName setTextColor:[UIColor colorWithRed:83/255.0 green:101/255.0 blue:127/255.0 alpha:1.0]];
                [positionSetCell setLabelPostion:YES];
            }
            else {
                positionSetCell.labelName.text = locationCityName;
                [positionSetCell.labelAddress setHidden:YES];
                [positionSetCell.labelName setTextColor:[UIColor blackColor]];
                [positionSetCell setLabelPostion:YES];
            }
        }
            break;
        default: //搜索结果选项
        {
            [positionSetCell.labelName setTextColor:[UIColor blackColor]];
            [positionSetCell.labelAddress setHidden:NO];
            [positionSetCell setLabelPostion:NO];
            AMapPOI *info = [searchResultArray objectAtIndexCheck:(indexPath.row - 2)];
            positionSetCell.labelName.text = info.name;
            positionSetCell.labelAddress.text = info.address;
        }
            break;
    }
    
    return positionSetCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [_positionSetTableView reloadData];
    switch (indexPath.row) {
        case 0:
        {
            [TKPublishPosition shareInstance].positionName = @"位置";
            [TKPublishPosition shareInstance].cityName = @"";
        }
            break;
        case 1:
        {
            [TKPublishPosition shareInstance].positionName = locationCityName;
            [TKPublishPosition shareInstance].cityName = locationCityName;
        }
            break;
        default:
        {
            AMapPOI *p = [searchResultArray objectAtIndexCheck:(indexPath.row - 2)];
            [TKPublishPosition shareInstance].cityName = locationCityName;
            [TKPublishPosition shareInstance].positionName = p.name;
        }
        break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -TextField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_positionSetTextFiled setReturnKeyType:UIReturnKeySearch];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (UIReturnKeySearch == textField.returnKeyType) {
        [self.positionSetTextFiled resignFirstResponder];
        if ([CustomUtil CheckParam:_positionSetTextFiled.text]) {
            [CustomUtil showToastWithText:@"请输入待查询的地名" view:kWindow];
            return NO;
        }
        //搜索地图
        [self searchMapWithKeyWord:_positionSetTextFiled.text location:nil];
    } else if (UIReturnKeyDone == textField.returnKeyType) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark -按钮点击事件
//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    //[hud removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -地图搜索
//按关键字搜索地图
-(void)searchMapWithKeyWord:(NSString *)keywords location:(CLLocation *)positionLocation
{
    //初始化检索对象
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
    }
    _search.delegate = self;
    if (positionLocation) {
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:positionLocation.coordinate.latitude longitude:positionLocation.coordinate.longitude];
        [_search AMapPOIAroundSearch:request];
    } else {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = keywords;
        request.sortrule = 0;
        request.requireExtension = YES;
        request.city = locationCityName;
        [_search AMapPOIKeywordsSearch:request];
    }
    //if (!hud) {
      //  hud = [MBProgressHUD showHUDAddedTo:kWindow  animated:YES];
    //}
    //hud.mode = MBProgressHUDAnimationFade;
    //hud.removeFromSuperViewOnHide = YES;
}

//搜索回调方法
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //[hud removeFromSuperview];
    if (0 == response.pois.count) {
        [CustomUtil showToastWithText:@"无数据" view:kWindow];
        return;
    }
    [searchResultArray removeAllObjects];
    [searchResultArray addObjectsFromArray:response.pois];
    //[CustomUtil showToastWithText:@"查询成功" view:kWindow];
    [_positionSetTableView reloadData];
}

@end
