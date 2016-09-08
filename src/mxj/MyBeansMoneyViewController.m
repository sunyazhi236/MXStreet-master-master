//
//  MyBeansMoneyViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansMoneyViewController.h"
#import "WithdrawCashViewController.h"

#define HEADVIEWHEIGH 55

@interface MyBeansMoneyViewController() <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
}

@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIImageView       *headTitleView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIImageView       *bgBeansView;
@property (nonatomic, strong) UILabel           *beansLabel;
@property (nonatomic, strong) UILabel           *moneyLabel;
@property (nonatomic, strong) UIView            *rmbView;
@property (nonatomic, strong) UITextField        *rmbLabel;
@property (nonatomic, strong) UILabel           *wechatLabel;
@property (nonatomic, strong) UIButton          *redBagBtn;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property(nonatomic,assign) BOOL isHaveDian;
@end

@implementation MyBeansMoneyViewController

- (instancetype)initWithSum:(NSInteger)sum
{
    self = [super init];
    
    if (self) {
        _sum = sum;
    }
    return self;
}

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
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    
//    [leftButton setTitle:@"提现" forState:UIControlStateNormal];
//    
//    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"提现";
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];

    [self leftBtnWithTitle];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.rmbView];
//    [self.view addSubview:self.wechatLabel];
    [self.view addSubview:self.redBagBtn];
    
    [self.view addSubview:self.tableView];
    
//    [self initData];
    
    currentPageNum = 1; //默认页码从0开始
    //添加上拉加载更多
    __weak MyBeansMoneyViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = _dataArray;
    //下拉刷新
    [_tableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
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
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
    
    //刷新数据
    [_tableView triggerPullToRefresh];
    //隐藏键盘
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
    [self.view addGestureRecognizer:guesture];
}
-(void)backImageClick{
    [_rmbLabel resignFirstResponder];
}

//刷新数据
-(void)reloadData:(int)current block:(void(^)())block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%d",current] forKey:@"page"];
    [dict setValue:@10 forKey:@"rows"];
    [dict setValue:@1 forKey:@"processState"];
    
    /**
     *  请求提现列表接口
     */
    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getwithdrawApplyListForApp" param:dict successBlock:^(NSDictionary *responseDict) {
        block();
        NSLog(@"getmxCoinList：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
            [_dataArray addObjectsFromArray:[[responseDict objectForKey:@"data"] objectForKey:@"info"]];
            
            [self.tableView reloadData];
        }
        else {
//            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
        block();
    }];
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
        
        _bgBeansView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 150, 59 , 300, 62)];
        _bgBeansView.image = [UIImage imageNamed:@"bgbeans"];
        
        
        NSString *beansStr = [NSString stringWithFormat:@"%ld",(long)_sum];
        CGSize beansSize = [beansStr sizeWithFont:[UIFont fontWithName:@"ArialMT" size:26.0f] maxSize:CGSizeMake(_bgBeansView.frame.size.width, 24)];
        NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",_sum/100.0];
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont fontWithName:@"ArialMT" size:26.0f] maxSize:CGSizeMake(_bgBeansView.frame.size.width, 24)];
        
        UIImageView *beans = [[UIImageView alloc] initWithFrame:CGRectMake(_bgBeansView.frame.size.width/2 - (beansSize.width + moneySize.width + 35)/2 - 7.5, 13.5, 30, 35)];
        beans.image = [UIImage imageNamed:@"beans"];
        [_bgBeansView addSubview:beans];
        
        _beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(beans.frame.origin.x + beans.frame.size.width + 5, _bgBeansView.frame.size.height/2 - beansSize.height/2,beansSize.width, beansSize.height)];
        _beansLabel.text = beansStr;
        _beansLabel.font = [UIFont fontWithName:@"ArialMT" size:26.0f];
        _beansLabel.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
        [_bgBeansView addSubview:_beansLabel];
        
        UILabel *plus = [[UILabel alloc] initWithFrame:CGRectMake(_beansLabel.frame.origin.x + _beansLabel.frame.size.width + 5, 20, 10, 24)];
        plus.text = @"=";
        [_bgBeansView addSubview:plus];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(plus.frame.origin.x + plus.frame.size.width + 5, _bgBeansView.frame.size.height/2 - moneySize.height/2, moneySize.width, moneySize.height)];
        _moneyLabel.text = moneyStr;
        _moneyLabel.font = [UIFont fontWithName:@"ArialMT" size:26.0f];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#e70b0b"];
        [_bgBeansView addSubview:_moneyLabel];
        
        [_headView addSubview:_bgBeansView];
    }
    return _headView;
}

-(UIView *)rmbView{
    if (!_rmbView) {
        _rmbView = [[UIView alloc] initWithFrame:CGRectMake(15, 150, SCREENWIDTH - 30, 45)];
        _rmbView.layer.borderWidth = 1;
        _rmbView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _rmbView.backgroundColor = [UIColor whiteColor];
        
        UILabel *rmbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 45)];
        rmbTitle.text = @"人民币：";
        rmbTitle.font = [UIFont systemFontOfSize:15.0f];
        [_rmbView addSubview:rmbTitle];
        
        _rmbLabel = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _rmbView.frame.size.width - 85, 45)];
        _rmbLabel.placeholder = [NSString stringWithFormat:@"%.2f元",_sum/100.0];
        _rmbLabel.delegate=self;
        _rmbLabel.font = [UIFont systemFontOfSize:15.0f];
        _rmbLabel.textAlignment = NSTextAlignmentLeft;
        _rmbLabel.keyboardType=UIKeyboardTypeDecimalPad;
        [_rmbView addSubview:_rmbLabel];
    }
    return _rmbView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self showError:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }          }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self showError:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [self showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showError:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


- (void)showError:(NSString *)errorString
{
    NSLog(@"asfda");
}

-(UILabel *)wechatLabel{
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, SCREENWIDTH - 30, 20)];
        _wechatLabel.text = [NSString stringWithFormat:@"已绑定微信号：%@",[LoginModel shareInstance].webchatId];
        _wechatLabel.textColor = [UIColor lightGrayColor];
        _wechatLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _wechatLabel;
}

-(UIButton *)redBagBtn{
    if (!_redBagBtn) {
        _redBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redBagBtn.frame = CGRectMake(25, MainViewHeight - 85, SCREENWIDTH - 50, 50);
        _redBagBtn.backgroundColor = [UIColor colorWithHexString:@"#e84335"];
        [_redBagBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_redBagBtn addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
        _redBagBtn.titleLabel.textColor = [UIColor whiteColor];
        [_redBagBtn.layer setCornerRadius:25];
    }
    return _redBagBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 211, SCREENWIDTH, MainViewHeight - 211 - 90) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    }
    return _tableView;
}

/**
 *  提现
 */
- (void)withdraw:(id)sender
{
    if ([_rmbLabel.text floatValue]>_sum/100.f) {
          [CustomUtil showToast:@"提现余额大于总余额！" view:self.view];
          return;
    }
    if (_sum < 10 * 100 || [_rmbLabel.text floatValue]*100 < 10 * 100 ) {
        [CustomUtil showToast:@"满10元才可提现哦！" view:self.view];
        return;
    }
 
    WithdrawCashViewController *wdcVC = [[WithdrawCashViewController alloc] initWithSum:[_rmbLabel.text floatValue]*100];
    __weak __typeof(&*self)weakSelf = self;
    wdcVC.aBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf initData];
    };
    [self.navigationController pushViewController:wdcVC animated:YES];
}

- (void)initData{

    currentPageNum = 1;
    
    //刷新数据
    [_tableView triggerPullToRefresh];

//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
//    [dict setValue:@1 forKey:@"page"];
//    [dict setValue:@50 forKey:@"rows"];
//    [dict setValue:@1 forKey:@"processState"];
//
//    /**
//     *  请求提现列表接口
//     */
//    [CustomUtil showLoading:@""];
//    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getwithdrawApplyListForApp" param:dict successBlock:^(NSDictionary *responseDict) {
//        NSLog(@"getmxCoinList：%@",responseDict);
//        
//        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
//            
//            [_dataArray removeAllObjects];
//            
//            [_dataArray addObjectsFromArray:[[responseDict objectForKey:@"data"] objectForKey:@"info"]];
//        
//            [self.tableView reloadData];
//        }
//        else {
//            [CustomUtil showToast:@"加载数据失败" view:self.view];
//        }
//    }failedBlock:^(NSError *err) {
//        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
//    }];    
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];

    if ([[dic objectForKey:@"txAccount"] isKindOfClass:[NSString class]] && [[dic objectForKey:@"txAccount"] length] > 0) {
        return 70;
    }
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];

    if (dic) {
        NSString *sortId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"applyDate"]];
        
        NSDate *date;
        /* 时间戳转时间及日期 */
        if ([sortId length] ==13) {
            /* 毫秒级时间戳 */
            date = [NSDate dateWithTimeIntervalSince1970:[sortId longLongValue]/1000];
        }
        else if ([sortId length] == 10) {
            /* 秒级时间戳 */
            date = [NSDate dateWithTimeIntervalSince1970:[sortId longLongValue]];
        }
        else {
            date = [NSDate date];
        }
        /* 获取时间 */
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日"];
        NSString *timeStr = [formatter stringFromDate:date];
        
        CGSize size = [timeStr sizeWithFont:FONT(13) maxSize:CGSizeMake(200, 55)];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, size.width, 55)];
        timeLabel.font = FONT(13);
        timeLabel.text = timeStr;
        timeLabel.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:timeLabel];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + GetWidth(timeLabel) + 13, 0, 180, 55)];
        label.textColor = [UIColor blackColor];
        label.font = FONT(16);
        [cell.contentView addSubview:label];
        switch ([[dic objectForKey:@"processState"] integerValue]) {
            case 1:
            {
                label.text = @"正在提现中";
            }
                break;
            case 2:
            {
                label.text = @"提现完成";
            }
                break;
            case 3:
            {
                label.text = @"提现中被驳回";
            }
                break;
            default:
                break;
        }
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 15 - 200, 0, 200, 55)];
        label2.textColor = [UIColor colorWithHexString:@"#e70b0b"];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = [NSString stringWithFormat:@"￥%.2f", [[dic objectForKey:@"sum"] integerValue] / 100.0];
        label2.font = FONT(16);
        [cell.contentView addSubview:label2];

        if ([[dic objectForKey:@"txAccount"] isKindOfClass:[NSString class]] && [[dic objectForKey:@"txAccount"] length] > 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GetX(timeLabel), GetBottom(timeLabel) - 10, SCREENWIDTH - GetX(timeLabel), 20)];
            label.textColor = [UIColor lightGrayColor];
            label.font = FONT(12);
            label.text = [NSString stringWithFormat:@"支付宝账号：%@", [dic objectForKey:@"txAccount"]];
            [cell.contentView addSubview:label];
        }
    }
    return cell;
}

@end
