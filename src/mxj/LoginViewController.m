//
//  LoginViewController.m
//  mxj
//  P5登录实现文件
//  Created by 齐乐乐 on 15/11/10.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidatePhoneNoViewController.h"
#import "TabBarController.h"
#import "MainPageTabBarController.h"

#import "LoginVC.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ((![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) && (1 == [CustomUtil readLoginState])) {
        //自动登录
        [self loginBtnClick:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//忘记密码按钮点击事件
- (IBAction)forgetPassBtnClick:(id)sender {
    //弹出输入手机号码对话框
    [self displayForgetPassAlertView];
#warning test
//    LoginVC *vc = [[LoginVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];

}

//登录按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) {
        _loginPhoneNumber.text = [TKLoginAccount shareInstance].phoneNum;
    }
    if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].password]) {
        _loginPassword.text = [TKLoginAccount shareInstance].password;
    }
#ifdef PACKAGEFORTEST
#else
    //检查手机号是否为空
    if ([CustomUtil CheckParam:_loginPhoneNumber.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入手机号" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    //检查密码是否为空
    if ([CustomUtil CheckParam:_loginPassword.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
#endif
#ifdef OPEN_NET_INTERFACE
    [_loginPhoneNumber resignFirstResponder];
    [_loginPassword resignFirstResponder];
    //调用登录接口
    [[CustomUtil shareInstance] clearLoginData];
#ifdef PACKAGEFORTEST
#else
    [LoginInput shareInstance].phoneNumber = _loginPhoneNumber.text;
    [LoginInput shareInstance].userPassword = [CustomUtil md5HexDigest:_loginPassword.text];
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
            [TKLoginAccount shareInstance].phoneNum = _loginPhoneNumber.text;
            [TKLoginAccount shareInstance].password = _loginPassword.text;
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
            //跳转至主页
            TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
            MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
            mainPageViewCtrl.loginFlag = YES; //login进入
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:tabBarCtrl animated:YES];
            
            //注册推送
            [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];

            NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            if (!tagArray && userId) {
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
            [self performSelector:@selector(pushDelay:) withObject:tagArray afterDelay:1];
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

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    if (iResCode != 0) {
        NSLog(@"设置失败");
        [JPUSHService setTags:tags callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        NSLog(@"设置成功");
        return;
    }
    
}

//QQ登录按钮点击事件
- (IBAction)qqLoginBtnClick:(id)sender {
    [CustomUtil qqLogin:NO personOrZone:YES inviteUser:NO imagePath:nil shareContent:@""];
}

//微信登录按钮点击事件
- (IBAction)weixinBtnClick:(id)sender {
    [CustomUtil weixinLogin:self shareFlag:NO personOrZone:NO inviteUser:NO image:nil shareContent:@""];
}

//新浪登录按钮点击事件
- (IBAction)xinlangBtnClick:(id)sender {
//    [CustomUtil sinaLogin:NO viewCtrl:@"LoginViewController" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
    [CustomUtil sinaLogin:NO viewCtrl:@"LoginVC" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
}

#pragma mark -共通方法
//弹出忘记密码输入手机号对话框
-(void)displayForgetPassAlertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记密码" message:@"请输入你的手机号码" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"手机号码";
        //设置键盘类型
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //读取输入的手机号码
        UITextField *phoneNoTextFiled = alertController.textFields.firstObject;
        //判断输入号码位数
        if (11 != phoneNoTextFiled.text.length) {
            [CustomUtil showToastWithText:@"请输入11位有效手机号码" view:kWindow];
        } else {
            //弹出确认手机号对话框
            [self displayConfirmAlertView:phoneNoTextFiled.text];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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


@end
