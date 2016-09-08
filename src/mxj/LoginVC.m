//
//  LoginVC.m
//  mxj
//  登录
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LoginVC.h"
#import "Macro.h"
#import "LineTextField.h"
#import "RegisterVC.h"
#import "ValidatePhoneNoViewController.h"
#import "TabBarController.h"
#import "MainPageTabBarController.h"

#import "GotoPhotoVC.h"

#import "InformationVC.h"

@interface LoginVC () <UITextFieldDelegate>
{
    Boolean isHidden;
}

@property (nonatomic, strong) UIImageView   *logoView;
@property (nonatomic, strong) LineTextField   *userNameTextField;
@property (nonatomic, strong) LineTextField   *passwordTextField;
@property (nonatomic, strong) UIButton      *lookButton;
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) UIButton      *forgetButton;
@property (nonatomic, strong) UIButton      *loginButton;
@property (nonatomic, strong) UILabel       *otherLabel;
@property (nonatomic, strong) UIView        *otherView;
@property (nonatomic, strong) UIButton      *qqButton;
@property (nonatomic, strong) UILabel       *qqLabel;
@property (nonatomic, strong) UIButton      *wxButton;
@property (nonatomic, strong) UILabel       *wxLabel;
@property (nonatomic, strong) UIButton      *wbButton;
@property (nonatomic, strong) UILabel       *wbLabel;

@end

@implementation LoginVC

#pragma viewLife

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //设置导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"登录"];
    
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapGesture];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ((![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) && (1 == [CustomUtil readLoginState])) {
        //自动登录
//        [self loginBtnClick:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma initView
-(void)initView{
    if (!_logoView){
        UIImage *logo = [UIImage imageNamed:@"logonew"];
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 150)/2, 44, 150, 46)];
        _logoView.image = logo;
//        _logoView.frame = CGRectMake(0, 56, SCREENWIDTH, 55);
//        _logoView.frame = CGRectMake(0, 44, 150, 46);
//        _logoView.contentMode =  UIViewContentModeCenter;
        [self.view addSubview:_logoView];
        
        _userNameTextField = [[LineTextField alloc] initWithFrame:CGRectMake(55, 157, SCREENWIDTH - 110, 30)];
        [_userNameTextField setBackgroundColor:[UIColor clearColor]];
        _userNameTextField.layer.cornerRadius = 2;
        UIImageView *imgUser=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile"]];
        imgUser.frame = CGRectMake(0, 0, 20, 25);
        _userNameTextField.leftView = imgUser;
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _userNameTextField.placeholder = @"请输入手机号";
        _userNameTextField.font = [UIFont systemFontOfSize:13.0f];
        [_userNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_userNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _userNameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        _userNameTextField.delegate = self;
        _userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_userNameTextField];
        
        _passwordTextField = [[LineTextField alloc] initWithFrame:CGRectMake(55, 195, SCREENWIDTH - 110, 30)];
        [_passwordTextField setBackgroundColor:[UIColor clearColor]];
        _passwordTextField.layer.cornerRadius = 2;
        UIImageView *imgPassword=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
        imgPassword.frame = CGRectMake(0, 0, 20, 25);
        _passwordTextField.leftView = imgPassword;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.font = [UIFont systemFontOfSize:13.0f];
        [_passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _passwordTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        _passwordTextField.secureTextEntry = YES;
        isHidden = YES;
        _passwordTextField.delegate = self;
        [self.view addSubview:_passwordTextField];
        
        if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) {
            _userNameTextField.text = [TKLoginAccount shareInstance].phoneNum;
        }
        if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].password]) {
            _passwordTextField.text = [TKLoginAccount shareInstance].password;
        }
        
        _lookButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 203, 20, 15)];
        [_lookButton setImage: [UIImage imageNamed: @"offpassword"] forState: UIControlStateNormal];
        [_lookButton addTarget:self action:@selector(onPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_lookButton];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loginButton.frame = CGRectMake(55, 255, SCREENWIDTH - 110, 40);
        _loginButton.backgroundColor = [UIColor colorWithRed:237.0/255 green:58.0/255 blue:59.0/255 alpha:1.0f];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTintColor:[UIColor whiteColor]];
        _loginButton.layer.cornerRadius = 20;
        [_loginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
        
        _forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(55, _loginButton.frame.origin.y+50, 60, 12)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [_forgetButton setAttributedTitle:str forState:UIControlStateNormal];
        _forgetButton.titleLabel.textColor = [UIColor lightGrayColor];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_forgetButton setBackgroundColor:[UIColor clearColor]];
        [_forgetButton addTarget:self action:@selector(forgetPassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetButton];
        
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 110, _loginButton.frame.origin.y+50, 60, 12)];
        [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
        _registerButton.titleLabel.textColor = [UIColor lightGrayColor];
        [_registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_registerButton setBackgroundColor:[UIColor clearColor]];
        [_registerButton addTarget:self action:@selector(registerOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerButton];
        
        _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, MainViewHeight - 150, SCREENWIDTH, 150)];
        _otherView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_otherView];
        
        UIView *lineleft = [[UIView alloc] initWithFrame:CGRectMake(55, 15, SCREENWIDTH - SCREENWIDTH/2 - 80, 0.5)];
        lineleft.backgroundColor = [UIColor colorWithHexString:@"#a3a3a3"];
        [_otherView addSubview:lineleft];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        titLabel.text = @"或者";
        titLabel.font = [UIFont systemFontOfSize:14.0f];
        titLabel.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:titLabel];
        
        UIView *lineright = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - lineleft.frame.size.width - 55, 15, lineleft.frame.size.width, 0.5)];
        lineright.backgroundColor = [UIColor colorWithHexString:@"#a3a3a3"];
        [_otherView addSubview:lineright];
        
        _otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 15)];
        _otherLabel.text = @"社交账号快速登录";
        _otherLabel.backgroundColor = [UIColor clearColor];
        _otherLabel.textColor = [UIColor lightGrayColor];
        _otherLabel.font = [UIFont systemFontOfSize:13.0f];
        _otherLabel.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:_otherLabel];
        
        _qqButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/4 - 25, 65, 50, 50)];
        [_qqButton setBackgroundImage:[UIImage imageNamed:@"qqdl"] forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherView addSubview:_qqButton];
        
        _wxButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 25, 65, 50, 50)];
        [_wxButton setBackgroundImage:[UIImage imageNamed:@"wxdl"] forState:UIControlStateNormal];
        [_wxButton addTarget:self action:@selector(weixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherView addSubview:_wxButton];
        
        _wbButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/4*3 - 25, 65, 50, 50)];
        [_wbButton setBackgroundImage:[UIImage imageNamed:@"wbdl"] forState:UIControlStateNormal];
        [_wbButton addTarget:self action:@selector(xinlangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherView addSubview:_wbButton];
        
        _qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/4 - 25, 102, 50, 50)];
        _qqLabel.text = @"QQ登录";
        _qqLabel.textColor = [UIColor lightGrayColor];
        _qqLabel.backgroundColor = [UIColor clearColor];
        _qqLabel.font = [UIFont systemFontOfSize:11.0f];
        _qqLabel.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:_qqLabel];
        
        _wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 24, 102, 50, 50)];
        _wxLabel.text = @"微信登录";
        _wxLabel.textColor = [UIColor lightGrayColor];
        _wxLabel.backgroundColor = [UIColor clearColor];
        _wxLabel.font = [UIFont systemFontOfSize:11.0f];
        _wxLabel.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:_wxLabel];
        
        _wbLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/4*3 - 24, 102, 50, 50)];
        _wbLabel.text = @"微博登录";
        _wbLabel.textColor = [UIColor lightGrayColor];
        _wbLabel.backgroundColor = [UIColor clearColor];
        _wbLabel.font = [UIFont systemFontOfSize:11.0f];
        _wbLabel.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:_wbLabel];
    }
}

#pragma Action
//密码可见事件
-(void)onPassword{
    if (isHidden == YES) {
        [_lookButton setImage: [UIImage imageNamed: @"onpassword"] forState: UIControlStateNormal];
        _passwordTextField.secureTextEntry = NO;
        isHidden = NO;
    }else{
        [_lookButton setImage: [UIImage imageNamed: @"offpassword"] forState: UIControlStateNormal];
        _passwordTextField.secureTextEntry = YES;
        isHidden = YES;
    }
}

//忘记密码事件
- (IBAction)forgetPassBtnClick:(id)sender {
    //弹出输入手机号码对话框
    [self displayForgetPassAlertView];
}

//注册按钮事件
-(void)registerOnClick{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//登录按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
//    if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) {
//        _userNameTextField.text = [TKLoginAccount shareInstance].phoneNum;
//    }
//    if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].password]) {
//        _passwordTextField.text = [TKLoginAccount shareInstance].password;
//    }
#ifdef PACKAGEFORTEST
#else
    //检查手机号是否为空
    if ([CustomUtil CheckParam:_userNameTextField.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入手机号" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    //检查密码是否为空
    if ([CustomUtil CheckParam:_passwordTextField.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
#endif
#ifdef OPEN_NET_INTERFACE
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    //调用登录接口
    [[CustomUtil shareInstance] clearLoginData];
#ifdef PACKAGEFORTEST
#else
    [LoginInput shareInstance].phoneNumber = _userNameTextField.text;
    [LoginInput shareInstance].userPassword = [CustomUtil md5HexDigest:_passwordTextField.text];
#endif
#ifdef PACKAGEFORTEST
    [LoginInput shareInstance].phoneNumber = @"13772009562";
    [LoginInput shareInstance].userPassword = [CustomUtil md5HexDigest:@"000000"];
    _loginPhoneNumber.text = @"13772009562";
    _loginPassword.text = @"000000";
    //add by qi_lele for test start
    //[LoginInput shareInstance].phoneNumber = @"18521539773";
    //[LoginInput shareInstance].userPassword = [CustomUtil md5HexDigest:@"123456"];
    //add by qi_lele for test end
#endif
    [LoginInput shareInstance].registerId = [LoginModel shareInstance].registerId;
    [LoginInput shareInstance].phoneType = @"0"; //iOS设备
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [LoginInput shareInstance].verison=app_Version;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
    [CustomUtil showLoading:@"正在登录中..."];
    [[NetInterface shareInstance] login:@"login" param:dict successBlock:^(NSDictionary *responseDict) {
        LoginModel *loginModel = [LoginModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(loginModel.status)) {
#ifdef CACHE_SWITCH
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:responseDict flag:0 imageFlag:100];
#endif
            [ModifyUserDataInput shareInstance].userId = loginModel.userId;
            [GetUserInfoInput shareInstance].userId = loginModel.userId;
            [TKLoginAccount shareInstance].phoneNum = _userNameTextField.text;
            [TKLoginAccount shareInstance].password = _passwordTextField.text;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.plist"];
            NSFileManager *fileManger = [[NSFileManager alloc] init];
            NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
            [userInfoDict setValue:[TKLoginAccount shareInstance].phoneNum forKey:@"phoneNum"];
            [userInfoDict setValue:[TKLoginAccount shareInstance].password forKey:@"password"];
            if (![fileManger fileExistsAtPath:userInfoPath]) {
                [fileManger createFileAtPath:userInfoPath contents:nil attributes:nil];
            }
            //更新内容
            [userInfoDict writeToFile:userInfoPath atomically:YES];
            [CustomUtil writeLoginState:1];
            //注册推送
            [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];

            NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            if (!tagArray && userId) {
                tagArray = [NSMutableArray array];
                NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7", nil];
                [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 0) {
                        [tagArray addObject:maoTagArray[0]];
                    } else {
                        [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
//            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPushDelay:) userInfo:tagArray repeats:NO];
            //跳转至主页
            TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
            MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
            mainPageViewCtrl.loginFlag = YES; //login进入
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:tabBarCtrl animated:YES];
        } else {
            [CustomUtil showToastWithText:loginModel.msg view:kWindow];
            return;
        }
    } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
        if ((-1009) == [err code]) { //网络连接中断
            [CustomUtil showToastWithText:@"网络中断，启用缓存数据" view:kWindow];
            NSMutableDictionary *dict = (NSMutableDictionary *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:0];
            LoginModel *loginModel = [LoginModel modelWithDict:dict];
            [ModifyUserDataInput shareInstance].userId = loginModel.userId;
            [GetUserInfoInput shareInstance].userId = loginModel.userId;
            //跳转至主页
            TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:tabBarCtrl animated:YES];
        }
#endif
    }];
#else
    //跳转至主页
    TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:tabBarCtrl animated:YES];
#endif
}

- (void)pushDelay:(NSArray *)tagArray
{
    [JPUSHService setTags:[NSSet setWithArray:tagArray] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
}

- (void)timerPushDelay:(NSTimer *)timer
{
    [JPUSHService setTags:[NSSet setWithArray:timer.userInfo] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    if (iResCode != 0) {
        NSLog(@"设置失败");
        [JPUSHService setTags:tags callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        
        NSLog(@"设置成功");
        NSLog(@"%@", tags);
        return;
    }
}

//QQ登录按钮点击事件
- (IBAction)qqLoginBtnClick:(id)sender {
    [CustomUtil qqLogin:NO personOrZone:YES inviteUser:NO imagePath:nil shareContent:@""];
    
//    InformationVC *vc = [[InformationVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

//微信登录按钮点击事件
- (IBAction)weixinBtnClick:(id)sender {
    [CustomUtil weixinLogin:self shareFlag:NO personOrZone:NO inviteUser:NO image:nil shareContent:@""];
}

//新浪登录按钮点击事件
- (IBAction)xinlangBtnClick:(id)sender {
    [CustomUtil sinaLogin:NO viewCtrl:@"LoginVC" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
}

#pragma mark -共通方法
//弹出忘记密码输入手机号对话框
-(void)displayForgetPassAlertView
{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记密码" message:@"请输入你的手机号码" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
//        textField.placeholder = @"手机号码";
//        //设置键盘类型
//        [textField setKeyboardType:UIKeyboardTypeNumberPad];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        //读取输入的手机号码
//        UITextField *phoneNoTextFiled = alertController.textFields.firstObject;
//        //判断输入号码位数
//        if (11 != phoneNoTextFiled.text.length) {
//            [CustomUtil showToastWithText:@"请输入11位有效手机号码" view:kWindow];
//        } else {
//            //弹出确认手机号对话框
//            [self displayConfirmAlertView:phoneNoTextFiled.text];
//        }
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.isRegister = 1;
//    GotoPhotoVC *vc = [[GotoPhotoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//弹出确认手机号对话框
-(void)displayConfirmAlertView:(NSString *)phoneNum
{
    NSString *sendStr = [NSString stringWithFormat:@"我们将发送验证码到该手机\n+86 %@", phoneNum];
    UIAlertController *confirmPhoneNoAlertCtrl = [UIAlertController alertControllerWithTitle:@"确认手机号码" message:sendStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //跳转至忘记密码手机号输入对话框
        [self displayForgetPassAlertView];
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //点击确认时的处理，跳转至验证手机号界面
        ValidatePhoneNoViewController *validatePhoneNoViewCtrl = [[ValidatePhoneNoViewController alloc] initWithNibName:@"ValidatePhoneNoViewController" bundle:nil];
        validatePhoneNoViewCtrl.intoFlag = 1; //从忘记密码入口进入
        validatePhoneNoViewCtrl.phoneNumber = phoneNum;
        [self.navigationController pushViewController:validatePhoneNoViewCtrl animated:YES];
        
    }];
    [confirmPhoneNoAlertCtrl addAction:modifyAction];
    [confirmPhoneNoAlertCtrl addAction:confirmAction];
    [self presentViewController:confirmPhoneNoAlertCtrl animated:YES completion:nil];
}

#pragma delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//通过触摸背景关闭键盘
- (IBAction) backgroundTap:(id)sender
{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


@end
