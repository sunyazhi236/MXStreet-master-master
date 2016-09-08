//
//  MyBeansViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansViewController.h"
#import "MyBeansModel.h"
#import "MyBeansCell.h"

#define HEADVIEWHEIGH 55

@interface MyBeansViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
}

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIImageView       *headTitleView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIImageView       *bgBeansView;
@property (nonatomic, strong) UILabel           *beansLabel;
@property (nonatomic, strong) NSMutableArray    *dataArray;

@end

@implementation MyBeansViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
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
    
//    [leftButton setTitle:@"我的毛豆" forState:UIControlStateNormal];
    
//    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self leftBtnWithTitle];
    
    self.title = @"我的毛豆";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.tableView];

    _dataArray = [NSMutableArray arrayWithCapacity:0];
//    [self initData];
    currentPageNum = 1; //默认页码从0开始
    //添加上拉加载更多
    __weak MyBeansViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
//    __block NSMutableArray *dataSelf = _dataArray;
    //下拉刷新
    [_tableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.tableView.pullToRefreshView stopAnimating];
                
                blockSelf.tableView.contentOffset = CGPointMake(0, 0);
                
                blockSelf.tableView.contentSize = CGSizeMake(SCREENWIDTH, MainViewHeight - HEADVIEWHEIGH + 5);
                
            }];
        });
    }];
    
    //上拉加载更多
    [_tableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData2:currentPageNumSelf block:^{
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
    
    //刷新数据
    [_tableView triggerPullToRefresh];
}

//刷新数据 下拉刷新
-(void)reloadData:(int)current block:(void(^)())block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%d", current] forKey:@"index"];
    [dict setValue:@20 forKey:@"pageSize"];
    
    /**
     *  请求我的毛豆接口
     */
    //    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getmxCoinList" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"getmxCoinList：%@",responseDict);
        [_dataArray removeAllObjects];
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
            _beansLabel.text = [responseDict objectForKey:@"mxAccountSum"] ? [responseDict objectForKey:@"mxAccountSum"] : @"0";
            
            for (NSDictionary *dic in [responseDict objectForKey:@"mxCoinFlowingList"]) {
                MyBeansModel *model = [[MyBeansModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        else {
            //            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
        block();
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
        block();
    }];
}

//刷新数据 上拉加载
-(void)reloadData2:(int)current block:(void(^)())block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%d", current] forKey:@"index"];
    [dict setValue:@20 forKey:@"pageSize"];
    
    /**
     *  请求我的毛豆接口
     */
//    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getmxCoinList" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"getmxCoinList：%@",responseDict);
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
            for (NSDictionary *dic in [responseDict objectForKey:@"mxCoinFlowingList"]) {
                MyBeansModel *model = [[MyBeansModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        else {
//            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
        block();
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
        block();
    }];
}

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
        _beansLabel.text = @"0";
        _beansLabel.font = [UIFont fontWithName:@"ArialMT" size:30.0f];
        _beansLabel.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
//        _beansLabel.textAlignment = NSTextAlignmentCenter;
        [_bgBeansView addSubview:_beansLabel];
        [_bgBeansView addSubview:beans];
        [_headView addSubview:_bgBeansView];
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 145, SCREENWIDTH, MainViewHeight - 145) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    }
    return _tableView;
}

-(void)initData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
//    for (int i = 8; i > 0; i--) {
//        MyBeansModel *model = [[MyBeansModel alloc] init];
//        model.day = @"2月22";
//        model.time = @"09：33";
//        model.sum = @300;
//        model.type = @1;
//        model.userName = @"豆豆";
//        [_dataArray addObject:model];
//    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:@0 forKey:@"index"];
    [dict setValue:@999 forKey:@"pageSize"];
    
    /**
     *  请求我的毛豆接口
     */
//    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getmxCoinList" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"getmxCoinList：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
            _beansLabel.text = [responseDict objectForKey:@"mxAccountSum"] ? [responseDict objectForKey:@"mxAccountSum"] : @"0";

            for (NSDictionary *dic in [responseDict objectForKey:@"mxCoinFlowingList"]) {
                MyBeansModel *model = [[MyBeansModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        else {
            [CustomUtil showToast:@"加载数据失败" view:self.view];
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
    MyBeansModel *model = [_dataArray objectAtIndexCheck:indexPath.row];
    if (!model) {
        return nil;
    }
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];

    MyBeansCell *cell = [[MyBeansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model) {
        [cell initDataWithModel:model];
    }
    return cell;
}

@end
