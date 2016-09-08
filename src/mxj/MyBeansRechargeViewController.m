//
//  MyBeansRechargeViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansRechargeViewController.h"

#define BTNWITH  100
#define BTNHEIGH 50

@interface MyBeansRechargeViewController ()
{
    int payCoin; // 充值毛豆数
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView   *topImgView;
@property (nonatomic, strong) UILabel       *beansLabel;
@property (nonatomic, strong) UIButton      *wechatBtn;
@property (nonatomic, strong) UILabel       *btnBeans;
@property (nonatomic, strong) UILabel       *rmbLabel;
@property (nonatomic, strong) UIButton      *tmpBtn;

@end

@implementation MyBeansRechargeViewController
{
    CGSize btnViewSize;
    CGSize tmpSize;
    UIButton *selectBtn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSum:(NSInteger)sum
{
    self = [super init];
    
    if (self) {
        _sum = sum;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resp_pay:) name:@"WX_PAY_NOTICE" object:nil];
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
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 80)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self leftBtnWithTitle];
    
    self.title = @"毛豆充值";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topImgView];
    
    [self.view addSubview:self.wechatBtn];
    
    [self initData];
}

- (void)reloadView
{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]] && [(UIButton *)view tag] >= 1000) {
            [view removeFromSuperview];
        }
    }
    
    btnViewSize.width = SCREENWIDTH;
    tmpSize.width = (SCREENWIDTH -  BTNWITH * 3)/4;
    tmpSize.height = 60.0f;
    for (int i = 0; i < _dataArray.count; i++) {
        
        _tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (tmpSize.width < SCREENWIDTH - (SCREENWIDTH -  BTNWITH * 3)/4) {
            btnViewSize.width = SCREENWIDTH - BTNWITH;
            _tmpBtn.frame = CGRectMake(tmpSize.width, tmpSize.height, BTNWITH, BTNHEIGH);
            tmpSize.width = tmpSize.width + (SCREENWIDTH -  BTNWITH * 3)/4 + BTNWITH;
        }
        else{
            tmpSize.width = (SCREENWIDTH -  BTNWITH * 3)/4;
            tmpSize.height = tmpSize.height + BTNHEIGH + 13.5;
            _tmpBtn.frame = CGRectMake(tmpSize.width, tmpSize.height, BTNWITH, BTNHEIGH);
            tmpSize.width = tmpSize.width + (SCREENWIDTH -  BTNWITH * 3)/4 + BTNWITH;
        }
        [_tmpBtn setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_tmpBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#fef1e5"]] forState:UIControlStateSelected];
        _tmpBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tmpBtn.layer.borderWidth = 1;
        _tmpBtn.tag = 1000 + i;
        [_tmpBtn addTarget:self action:@selector(btnViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_tmpBtn];
        
        NSString *coin = [NSString stringWithFormat:@"%@", [_dataArray objectAtIndex:i]];
        
        UIImage *img = [UIImage imageNamed:@"rechargebeans"];
        UIImageView *btnImg = [[UIImageView alloc] initWithImage:img];
        btnImg.frame = CGRectMake(25, 5, img.size.width/2, img.size.height/2);
        [_tmpBtn addSubview:btnImg];
        
        _btnBeans = [[UILabel alloc] initWithFrame:CGRectMake(46, 5, 50, 22)];
        _btnBeans.text = coin;
        _btnBeans.font = [UIFont systemFontOfSize:15.0f];
        [_tmpBtn addSubview:_btnBeans];
        
        _rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, BTNWITH, 20)];
        _rmbLabel.text = [NSString stringWithFormat:@"￥%.2f", [coin floatValue] / 100];
        _rmbLabel.textAlignment = NSTextAlignmentCenter;
        _rmbLabel.font = [UIFont systemFontOfSize:13.f];
        _rmbLabel.textColor = [UIColor colorWithHexString:@"#e70b0b"];
        [_tmpBtn addSubview:_rmbLabel];
    }
}

#pragma mark - get&set
-(UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        _topImgView.image = [UIImage imageNamed:@"bgbeanstitle"];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 90, 0, 90, 45)];
        titleLabel.text = @"我的毛豆：";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [_topImgView addSubview:titleLabel];
        
        UIImage *beans = [UIImage imageNamed:@"rechargebeans"];
        UIImageView *beansImg = [[UIImageView alloc] initWithImage:beans];
        beansImg.frame = CGRectMake(titleLabel.frame.origin.x + 85, 22.5 - beans.size.height/4, beans.size.width/2, beans.size.height/2);
        [_topImgView addSubview:beansImg];
        
        _beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(beansImg.frame.origin.x + beans.size.width/2 + 3, 0, SCREENWIDTH - beansImg.frame.origin.x + beans.size.width/2, 45)];
        _beansLabel.text = [NSString stringWithFormat:@"%ld", (long)_sum];
        _beansLabel.textAlignment = NSTextAlignmentLeft;
        _beansLabel.font = [UIFont fontWithName:@"ArialMT" size:20.0f];
        _beansLabel.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
        [_topImgView addSubview:_beansLabel];
    }
    return _topImgView;
}

-(UIButton *)wechatBtn{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatBtn.frame = CGRectMake(24, MainViewHeight - 83, SCREENWIDTH - 48, 51);
        _wechatBtn.backgroundColor = [UIColor colorWithHexString:@"#21b034"];
        [_wechatBtn setTitle:@"微信支付" forState:UIControlStateNormal];
        _wechatBtn.titleLabel.textColor = [UIColor whiteColor];
        [_wechatBtn.layer setCornerRadius:25.5];
        [_wechatBtn addTarget:self action:@selector(wechatRechare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatBtn;
}

- (void)initData
{
    //    mxCoin/topupTemplate
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    
    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/topupTemplate" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"topupTemplate：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 && [responseDict objectForKey:@"topupTemplate"] && [[responseDict objectForKey:@"topupTemplate"] isKindOfClass:[NSArray class]] && [[responseDict objectForKey:@"topupTemplate"] count]) {
            
            [_dataArray removeAllObjects];
            
            [_dataArray addObjectsFromArray:[responseDict objectForKey:@"topupTemplate"]];
            
            [self reloadView];
        }
        else {
            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
    
}

#pragma mark - action
// 充值
- (void)wechatRechare
{
    int coin = -1;
    for (int i = 0; i < _dataArray.count; i ++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000 + i];
        if (button.selected) {
            coin = [[_dataArray objectAtIndex:i] intValue];
            break;
        }
    }
    
    if (coin < 0) {
        [CustomUtil showToast:@"请选择要充值的毛豆数" view:self.view];
        return;
    }
    
    payCoin = coin;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%d", coin] forKey:@"totalFee"];// 单位分
    
    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/wxPreparePay" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"wxPreParePay：%@",responseDict);

        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            
            NSDictionary *dic = [responseDict objectForKey:@"data"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
//            req.appid               = WEIXIN_APPKEY;
            req.nonceStr            = [dic objectForKey:@"nonce_str"];
//            req.openID              = [dic objectForKey:@"appid"];//WEIXIN_APPKEY;
            req.package             = @"Sign=WXpay";
            req.partnerId           = [dic objectForKey:@"mch_id"];
            req.prepayId            = [dic objectForKey:@"prepay_id"];
            
            long tmpTime            = (long)([[dic objectForKey:@"time"] longLongValue] / 1000);
            req.timeStamp           = (int)tmpTime;
            
            NSMutableString *stringA = [NSMutableString string];

            [stringA appendFormat:@"appid=%@&",[dic objectForKey:@"appid"]];
            [stringA appendFormat:@"noncestr=%@&",req.nonceStr];
//            [stringA appendFormat:@"openid=%@&",req.openID];
            [stringA appendFormat:@"package=%@&",req.package];
            [stringA appendFormat:@"partnerid=%@&",req.partnerId];
            [stringA appendFormat:@"prepayid=%@&",req.prepayId];
            [stringA appendFormat:@"timestamp=%lu",(long)req.timeStamp];
            
            NSString *key = @"585858xmxdnhyf934yf7234u3hu8yr89";
            
            NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@", stringA, key];
            
            // MD5后全部转成大写
            NSString *sign = [[CustomUtil md5HexDigest:stringSignTemp] uppercaseString];

            req.sign                = sign;//[dic objectForKey:@"sign"];

            if ([dic objectForKey:@"prepay_id"]) {
                NSInteger state = 0; //订单异常信息。

                if (![WXApi sendReq:req]) {
                    state = 1; //检测打开微信失败
                    [CustomUtil showToast:@"打开微信失败" view:self.view];
                }
                else{
                    state = 2; //打开微信成功
                }
            }
        }
        else {
            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];

    
}

-(void)btnViewAction:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }
    else{
        if (selectBtn) {
            selectBtn.selected = NO;
            selectBtn.backgroundColor = [UIColor clearColor];
        }
        sender.selected = YES;
        selectBtn = sender;
    }
}

- (void)resp_pay:(NSNotification *)note {
    switch([note.object intValue]){
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");

            _beansLabel.text = [NSString stringWithFormat:@"%d", _sum + payCoin];
            [CustomUtil showToast:@" 支付成功 " view:self.view];
            break;
        default:
            NSLog(@"支付失败，retcode=%@",note.object);
            
            [CustomUtil showToast:@"支付失败" view:self.view];
            break;
    }

}



@end
