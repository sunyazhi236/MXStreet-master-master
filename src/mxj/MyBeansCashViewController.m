//
//  MyBeansCashViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansCashViewController.h"
#import "MyBeansCashModel.h"
#import "MyBeansCashCell.h"
#import "MyBeansRechargeViewController.h"
#import "MyBeansRedBagViewController.h"
#import "MyBeansMoneyViewController.h"

@interface MyBeansCashViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIImageView       *headTitleView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIImageView       *bgBeansView;
@property (nonatomic, strong) UILabel           *beansLabel;
@property (nonatomic, strong) NSMutableArray    *dataArray;

@end

@implementation MyBeansCashViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self reqData];
}

//返回按钮的点击事件处理
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏返回按钮标题
-(void)leftBtnWithTitle{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 80)];
    
//    [leftButton setTitle:@"充值提现" forState:UIControlStateNormal];
    
//    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self leftBtnWithTitle];
    self.title = @"充值提现";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    [self.view addSubview:self.headView];
    
    [self initData];
}

#pragma mark - get&set
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 135)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        _headTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        _headTitleView.image = [UIImage imageNamed:@"bgbeanstitle"];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        _titleLabel.text = @"毛豆总额";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        [_headTitleView addSubview:_titleLabel];
        [_headView addSubview:_headTitleView];
        
        _bgBeansView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 85, 59 , 170, 62)];
        _bgBeansView.image = [UIImage imageNamed:@"bgbeans"];
        
        UIImageView *beans = [[UIImageView alloc] initWithFrame:CGRectMake(30, 13.5, 30, 35)];
        beans.image = [UIImage imageNamed:@"beans"];
        
        _beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 90, 24)];
        _beansLabel.text = @"2345";
        _beansLabel.font = [UIFont fontWithName:@"ArialMT" size:30.0f];
        _beansLabel.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
        [_bgBeansView addSubview:_beansLabel];
        [_bgBeansView addSubview:beans];
        [_headView addSubview:_bgBeansView];
    }
    return _headView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        NSInteger heigh = CELL_HEIGH * _dataArray.count;
        _tableView.scrollEnabled = NO;
        if (heigh > MainViewHeight - 144) {
            heigh = MainViewHeight - 144;
            _tableView.scrollEnabled = YES;
        }
        _tableView.frame = CGRectMake(0, 144, SCREENWIDTH, heigh);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    }
    return _tableView;
}

-(void)initData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
//    NSArray *iconArr = [NSArray arrayWithObjects:@"recharge",@"redbag",@"cash", nil];
//    NSArray *titleArr = [NSArray arrayWithObjects:@"毛豆充值",@"发红包",@"提现", nil];
//    NSArray *subArr = [NSArray arrayWithObjects:@"仅支持微信支付",@"仅支持微信平台",@"满10元可提现", nil];

    NSArray *iconArr = [NSArray arrayWithObjects:@"recharge", @"cash", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"毛豆充值", @"提现", nil];
    NSArray *subArr = [NSArray arrayWithObjects:@"仅支持微信支付", @"满10元可提现", nil];

    
    for (int i = 0; i < iconArr.count; i++) {
        MyBeansCashModel *model = [[MyBeansCashModel alloc] init];
        model.icon = [iconArr objectAtIndex:i];
        model.title = [titleArr objectAtIndex:i];
        model.subTitle = [subArr objectAtIndex:i];
        [_dataArray addObject:model];
    }
    
    [self.view addSubview:self.tableView];
    
    [_tableView reloadData];
}

- (void)reqData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];

    /**
     *  请求我的毛豆接口
     */
//    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/queryMxAccount" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"getmxCoinList：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 && [responseDict objectForKey:@"mxCoinAccount"]) {
            _beansLabel.text = [[responseDict objectForKey:@"mxCoinAccount"] objectForKey:@"sum"] ? [[responseDict objectForKey:@"mxCoinAccount"] objectForKey:@"sum"] : @"0";
        }
        else {
            [CustomUtil showToast:@"加载毛豆余额失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBeansCashModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    MyBeansCashCell *cell = [[MyBeansCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model) {
        [cell initDataWithModel:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyBeansRechargeViewController *rechargeVC = [[MyBeansRechargeViewController alloc] initWithSum:[_beansLabel.text integerValue]];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
//    else if (indexPath.row == 1) {
//        MyBeansRedBagViewController *redBagVC = [[MyBeansRedBagViewController alloc] initWithSum:[_beansLabel.text integerValue]];
//        [self.navigationController pushViewController:redBagVC animated:YES];
//    }
    else  {
        MyBeansMoneyViewController *moneyVC = [[MyBeansMoneyViewController alloc] initWithSum:[_beansLabel.text integerValue]];
        [self.navigationController pushViewController:moneyVC animated:YES];
    }
}


@end
