//
//  MyBeansRedBagViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansRedBagViewController.h"
#import "MyBeansBagCell.h"
#import "MyBeansBagModel.h"

#define SHARE_CONTENT @"【我发了一个红包，快来领取吧！（分享自@毛线街 -不仅仅是毛线）】"

static TencentOAuth *_tencentOAuth= nil;
static NSString *openId = nil; //腾讯登录openId

@interface MyBeansRedBagViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, TencentSessionDelegate, WXApiDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) UILabel           *footLabel;
@property (nonatomic, strong) UIButton          *redBagBtn;
@property (nonatomic, strong) UIView            *redBagView;
@property (nonatomic, strong) UITextField       *redBagText;

@property (nonatomic, strong) NSString          *urlStr;

// qq
@property (nonatomic, assign) BOOL              isQQShare;
// 微信
@property (nonatomic, assign) BOOL              isWeiXinShare;

@end

@implementation MyBeansRedBagViewController

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
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 80)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的红包";
    
    [self leftBtnWithTitle];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];

    [self.view addSubview:self.redBagBtn];
    
    [self.view addSubview:self.redBagView];
    
    [self.view addSubview:self.tableView];

    [self initData];
}

-(void)initData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];

    [CustomUtil showLoading:@""];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getredPacketTemplate" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"getredPacketTemplate：%@",responseDict);
        //{"mxCoinSum":"10005","code":"1","rewardTemplate":["200","500","1000","2000"]}
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 && [[responseDict objectForKey:@"rewardTemplate"] isKindOfClass:[NSArray class]] && [[responseDict objectForKey:@"rewardTemplate"] count] > 0) {
            [_dataArray removeAllObjects];
            
            for (int i = 0; i < [[responseDict objectForKey:@"rewardTemplate"] count]; i ++) {
                NSString *str = [NSString stringWithFormat:@"%@", [[responseDict objectForKey:@"rewardTemplate"] objectAtIndex:i]];
                MyBeansBagModel *model = [[MyBeansBagModel alloc] init];
                model.titleText = str;
                model.subTitle = [NSString stringWithFormat:@"%.2f", [str floatValue] / 100];
                if (i == 0) {
                    model.type = 0;
                }
                else {
                    model.type = 1;
                }
                
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

#pragma mark - get&set
-(UIButton *)redBagBtn{
    if (!_redBagBtn) {
        _redBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redBagBtn.frame = CGRectMake(25, MainViewHeight - 85, SCREENWIDTH - 50, 50);
        _redBagBtn.backgroundColor = [UIColor colorWithHexString:@"#e84335"];
        [_redBagBtn setTitle:@"发红包" forState:UIControlStateNormal];
        _redBagBtn.titleLabel.textColor = [UIColor whiteColor];
        [_redBagBtn.layer setCornerRadius:25];
        [_redBagBtn addTarget:self action:@selector(sendRedPackage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redBagBtn;
}

-(UIView *)redBagView{
    if (!_redBagView) {
        _redBagView = [[UIView alloc] initWithFrame:CGRectMake(15, MainViewHeight - 155, SCREENWIDTH - 30, 45)];
        _redBagView.layer.borderWidth = 1;
        _redBagView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _redBagView.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 60, 45)];
        title.text = @"红包数：";
        title.font = [UIFont systemFontOfSize:15.0f];
        [_redBagView addSubview:title];
        
        _redBagText = [[UITextField alloc] initWithFrame:CGRectMake(68, 0, _redBagView.frame.size.width - 68, 45)];
        _redBagText.keyboardType = UIKeyboardTypeNumberPad;
        _redBagText.delegate = self;
        _redBagText.placeholder = @"请输入介于1到10之间的个数";
        _redBagText.keyboardType = UIKeyboardTypeNumberPad;
        [_redBagView addSubview:_redBagText];
        
        //侦听全局键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:@"UIKeyboardDidShowNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    }
    return _redBagView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, MainViewHeight - (MainViewHeight - _redBagView.frame.origin.y) - 5)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        line.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = line;
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREENWIDTH, 20)];
        _footLabel.text = [NSString stringWithFormat:@"您还剩余：%ld毛豆", (long)_sum];
        _footLabel.textColor = [UIColor lightGrayColor];
        _footLabel.font = [UIFont systemFontOfSize:13.0f];
        [footView addSubview:_footLabel];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

#pragma mark - delegate
- (void)keyboardDidShow:(NSNotification*)aNotification
{
    NSMutableDictionary *userInfo = (NSMutableDictionary *)[aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];

    CGFloat tmpKeyboardHeight = keyboardRect.size.height;
    
    CGFloat offset = self.view.frame.size.height - (_redBagView.frame.origin.y + _redBagView.frame.size.height + keyboardRect.size.height);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _redBagView.frame = CGRectMake(15, MainViewHeight - 50 - tmpKeyboardHeight, SCREENWIDTH - 30, 45);
            
            CGRect tableRect = _tableView.frame;
            tableRect.size.height = MainViewHeight - 44 - tmpKeyboardHeight;
            _tableView.frame = tableRect;

        }];
    }
}

- (void)keyboardDidHide:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{

        _redBagView.frame = CGRectMake(15, MainViewHeight - 155, SCREENWIDTH - 30, 45);

        CGRect tableFrame = self.tableView.frame;
        tableFrame.origin.y = 0;
        tableFrame.size.height = MainViewHeight - (MainViewHeight - _redBagView.frame.origin.y) - 5;
        self.tableView.frame = tableFrame;
    }];
}

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
    MyBeansBagModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString *cellId = [NSString stringWithFormat:@"CELL%ld",(long)indexPath.row];
    MyBeansBagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyBeansBagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model) {
        [cell initDataWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_redBagText resignFirstResponder];

    for (int i = 0; i < _dataArray.count; i ++) {
        MyBeansBagModel *model = [_dataArray objectAtIndex:i];
        model.type = 1;
    }
    
    MyBeansBagModel *model = [_dataArray objectAtIndex:indexPath.row];
    model.type = 0;
    
    [_tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_redBagText resignFirstResponder];
}

// 发红包
- (void)sendRedPackage
{
    if (_redBagText.text.length == 0) {
        [CustomUtil showToast:@"请输入要发的红包数！" view:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:_redBagText.text forKey:@"size"];

    for (int i = 0; i < _dataArray.count; i ++) {
        MyBeansBagModel *model = [_dataArray objectAtIndex:i];
        if (model.type == 0) {
            [dict setValue:model.titleText forKey:@"sum"];
            break;
        }
    }
    
    [CustomUtil showLoading:@""];

    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/sendRedPacket" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"sendRedPacket：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 ) {
            [CustomUtil showToast:@"操作成功" view:self.view];
            if ([responseDict objectForKey:@"url"]) {
                
                _urlStr = [responseDict objectForKey:@"url"];
                
                [self showShareView];
            }
        }
        else {
            [CustomUtil showToast:@"加载数据失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];

}


- (void)showShareView
{
    UIView *shareBackView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
    if (!shareBackView) {
        shareBackView = [[UIView alloc] init];
    }
    shareBackView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    shareBackView.tag = 10000;
    shareBackView.hidden = NO;
    shareBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:shareBackView];
    
    UIView *shareView = (UIView *)[shareBackView viewWithTag:10001];
    if (!shareView) {
        shareView = [[UIView alloc] init];
    }
    shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 220);
    shareView.tag = 10001;
    shareView.backgroundColor = [UIColor whiteColor];
    [shareBackView addSubview:shareView];
    
    NSArray *array = @[@"微信", @"朋友圈", @"qq", @"qq空间", @"微博"];
    NSArray *images = @[@"weixn9_1", @"pengyq9_1", @"qq9_1", @"kongjian9_1", @"weibo9_1"];
    
    
    CGFloat btnMarginW = 54;
    
    CGFloat btnMarginX = (SCREENWIDTH - 54 * 4) / 5;

    CGFloat labelMarginH = 16;

    CGFloat btnMarginH = (GetHeight(shareView) - 40) / 2 - labelMarginH;

    CGFloat btn_label_offsetH = (btnMarginH - btnMarginW) / 2 - 2;

    for (int i = 0; i < array.count; i++) {
        UIButton *button = (UIButton *)[shareBackView viewWithTag:i + 20000];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        button.tag = i + 20000;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(btnMarginX + (btnMarginX + btnMarginW) * (i % 4), 40 + (btnMarginH + btn_label_offsetH) * (i / 4), btnMarginW, btnMarginH);
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [shareView addSubview:button];
        
        UILabel *label = (UILabel *)[shareBackView viewWithTag:i + 30000];
        if (!label) {
            label = [[UILabel alloc] init];
        }
        label.tag = i + 30000;
        label.frame = CGRectMake(btnMarginX + (btnMarginX + btnMarginW) * (i % 4), GetBottom(button) - btn_label_offsetH, btnMarginW, labelMarginH);
        label.text = array[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(15);
        [shareView addSubview:label];
    }

    UILabel *label = (UILabel *)[shareBackView viewWithTag:10002];
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.tag = 10002;
    label.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
    label.text = @"红包分享到";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(18);
    [shareView addSubview:label];

//    UIButton *cancelButton = (UIButton *)[shareBackView viewWithTag:10002];
//    if (!cancelButton) {
//        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    }
//    cancelButton.tag = 10002;
//    cancelButton.frame = CGRectMake(0, 220 - 40, SCREENWIDTH, 40);
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton.titleLabel setFont:FONT(15)];
//    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"quxiao9_1"] forState:UIControlStateNormal];
//    [shareView addSubview:cancelButton];
    
    [UIView animateWithDuration:0.1 animations:^{
        shareView.frame = CGRectMake(0, SCREENHEIGHT - 220, SCREENWIDTH, 220);
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag - 20000) {
        case 0:
            // 微信好友
            NSLog(@"微信好友");
            [self weiXinBtnClick];
            break;
        case 1:
            // 微信朋友圈
            NSLog(@"微信朋友圈");
            [self pengyouquanBtnClick];
            break;
        case 2:
            // qq
            NSLog(@"qq");
            [self qqBtnClick];
            break;
        case 3:
            // qq空间
            NSLog(@"qq空间");
            [self qqkongjianBtnClick];
            break;
        case 4:
            // 微博
            NSLog(@"微博");
            [self weiboBtnClick];
            break;
            
        default:
            break;
    }
}

//微信按钮点击事件
- (void)weiXinBtnClick {
    
    [self cancelClick];

    if (!_urlStr.length) {
        return;
    }
    
    _isWeiXinShare = YES;
    
    [self outhWeixin];
}

//朋友圈按钮点击事件
- (void)pengyouquanBtnClick {
    
    [self cancelClick];
    
    if (!_urlStr.length) {
        return;
    }
    
    _isWeiXinShare = NO;
    
    [self outhWeixin];
}

- (void)outhWeixin
{
    //读取微信授权plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKWeixinLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKWeixinLogin shareInstance].token = [dict objectForKey:@"token"];
    
    if ((![CustomUtil CheckParam:[TKWeixinLogin shareInstance].openId]) &&
        (![CustomUtil CheckParam:[TKWeixinLogin shareInstance].token])) {
        [[CustomUtil shareInstance] getWeixinToken:^{
            //发送分享内容
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.openID = [TKWeixinLogin shareInstance].openId;
            req.bText = NO;
            WXMediaMessage *message = [[WXMediaMessage alloc] init];

            message.description = SHARE_CONTENT;
            message.title = @"毛线街";
            UIImage *orginalImage = [UIImage imageNamed:@"icon_80*80"];
            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
            UIImage *finishImage = [UIImage imageWithData:targetImageData];
            [message setThumbImage:finishImage];
            
            WXWebpageObject *webPageExt = [WXWebpageObject object];
            
            webPageExt.webpageUrl = _urlStr;

            message.mediaObject = webPageExt;
            req.message = message;
            
            if (_isWeiXinShare) {
                req.scene = 0;          //发送至个人
            } else {
                req.scene = 1;          //发送至朋友圈
            }
            [WXApi sendReq:req];
        }];
        
    } else {
        //请求授权
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
        req.state = @"123";
        //req.openID = WEIXIN_APPKEY;
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }
}

//微信响应代理
- (void)onResp:(BaseResp *)resp {

    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        if (sendResp.errCode == WXSuccess) { //分享成功
            [CustomUtil showToastWithText:@"分享成功" view:kWindow];
        }
        else {
            //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            [TKWeixinLogin shareInstance].code = authResp.code;
            //获取微信token、openId及用户信息
            [[CustomUtil shareInstance] getWeixinToken:^{
                //发送分享内容
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                WXMediaMessage *message = [[WXMediaMessage alloc] init];
                message.description = SHARE_CONTENT;
                message.title = @"毛线街";
                UIImage *orginalImage = [UIImage imageNamed:@"icon_80*80"];
                UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                UIImage *finishImage = [UIImage imageWithData:targetImageData];
                [message setThumbImage:finishImage];
                
                WXWebpageObject *webPageExt = [WXWebpageObject object];
                webPageExt.webpageUrl = _urlStr;
                message.mediaObject = webPageExt;
                req.message = message;
                
                if (_isWeiXinShare) {
                    req.scene = 0;          //发送至个人
                } else {
                    req.scene = 1;          //发送至朋友圈
                }
                [WXApi sendReq:req];
                
            }];
        }
        else {
            [CustomUtil showToastWithText:@"授权失败" view:kWindow];
        }
    }
}

// qq按钮点击事件
- (void)qqBtnClick {
    [self cancelClick];

    if (!_urlStr.length) {
        return;
    }

    _isQQShare = YES;

    [self authQQ];
}

// qq空间按钮点击事件
- (void)qqkongjianBtnClick {
   
    [self cancelClick];

    if (!_urlStr.length) {
        return;
    }
    
    _isQQShare = NO;
    
    [self authQQ];
}

- (void)authQQ
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKQQLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKQQLogin shareInstance].token = [dict objectForKey:@"token"];
    [TKQQLogin shareInstance].expirationDate = [dict objectForKey:@"expirationDate"];
    if (![CustomUtil CheckParam:[TKQQLogin shareInstance].openId] &&
        ![CustomUtil CheckParam:[TKQQLogin shareInstance].token]) {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        _tencentOAuth.openId = [TKQQLogin shareInstance].openId;
        _tencentOAuth.expirationDate = [TKQQLogin shareInstance].expirationDate;
        _tencentOAuth.accessToken = [TKQQLogin shareInstance].token;
        [_tencentOAuth getUserInfo];
    } else {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        //授权
        NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_ADD_SHARE,
                                 nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }
}

//代理-登录成功
-(void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0!=[_tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
        [TKQQLogin shareInstance].openId = _tencentOAuth.openId;
        [TKQQLogin shareInstance].token = _tencentOAuth.accessToken;
        [TKQQLogin shareInstance].expirationDate = _tencentOAuth.expirationDate;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndexCheck:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[TKQQLogin shareInstance]];
        [dict writeToFile:filePath atomically:YES];
        [_tencentOAuth getUserInfo];
    } else {
        //[CustomUtil showToastWithText:@"登录失败" view:kWindow];
    }
}

//获取用户信息代理
-(void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSDictionary *dict = response.jsonResponse;
        DLog(@"dict = %@", dict);

        if (_isQQShare) {
            //分享QQ
            QQApiURLObject *object = [QQApiURLObject objectWithURL:[NSURL URLWithString:_urlStr] title:@"毛线街" description:SHARE_CONTENT previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"icon_80*80"]) targetContentType:QQApiURLTargetTypeNews];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            QQApiSendResultCode send = [QQApiInterface sendReq:req];
            if (EQQAPISENDSUCESS == send) {
//                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
            }
            else {
                //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
            }
        }
        else {
            //QZone分享

            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:_urlStr]
                                        title: @"毛线街"
                                        description:SHARE_CONTENT
                                        previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"icon_80*80"])];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qzone
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            if (EQQAPISENDSUCESS == sent) {
//                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
            }
            else {
                //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
            }
        }
    }
}

- (void)tencentDidNotNetWork
{
    [CustomUtil showToastWithText:@"无网络连接，请设置网络" view:kWindow];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

// 微博按钮点击事件
- (void)weiboBtnClick {
    
    [self cancelClick];
    
    if (!_urlStr.length) {
        return;
    }
    
    //读取微博账户plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKWeiboLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKWeiboLogin shareInstance].uid = [dict objectForKey:@"uid"];
    [TKWeiboLogin shareInstance].token = [dict objectForKey:@"token"];
    if ([WeiboSDK isWeiboAppInstalled]) {
        DLog(@"已安装");
    } else {
        DLog(@"未安装");
    }
    if (![CustomUtil CheckParam:[TKWeiboLogin shareInstance].uid] &&
        ![CustomUtil CheckParam:[TKWeiboLogin shareInstance].token]) {
        //获取用户信息
        [WBHttpRequest requestForUserProfile:[TKWeiboLogin shareInstance].uid withAccessToken:[TKWeiboLogin shareInstance].token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            DLog(@"result = %@", result);
            WeiboUser *user = (WeiboUser *)result;
            [TKWeiboLogin shareInstance].name = user.name;
            [TKWeiboLogin shareInstance].image = user.avatarHDUrl;

            WBWebpageObject *pageObject = [[WBWebpageObject alloc] init];
            pageObject.webpageUrl = _urlStr;
            pageObject.title = @"毛线街";
            pageObject.description = SHARE_CONTENT;
            pageObject.objectID = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
            UIImage *image = [UIImage imageNamed:@"icon_80*80"];
            NSData *imageData = UIImagePNGRepresentation(image);
            pageObject.thumbnailData = imageData;
            
            WBMessageObject *object = [[WBMessageObject alloc] init];
            object.mediaObject = pageObject;
            object.text = @"【我发了一个红包（分享自@毛线街 -不仅仅是毛线）】";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:object authInfo:nil access_token:[TKWeiboLogin shareInstance].token];
            request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            BOOL result2 = [WeiboSDK sendRequest:request];
            if (!result2) {
                //[CustomUtil showToastWithText:@"微博分享失败" view:kWindow];
            }
            else {
//                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
//                [CustomUtil share];
            }

        }];
    }
}

// 取消按钮点击
- (void)cancelClick
{
    UIView *shareBackView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
    
    UIView *shareView = (UIView *)[shareBackView viewWithTag:10001];

    [UIView animateWithDuration:0.1 animations:^{
        shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 220);
    } completion:^(BOOL finished) {
        shareBackView.hidden = YES;
    }];
}


@end
