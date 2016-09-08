//
//  ValidatePhoneNoViewController.m
//  mxj
//  P4-3验证手机号实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ValidatePhoneNoViewController.h"
#import "ForgetPasswordViewController.h"
#import "TabBarController.h"
#import "MainPageTabBarController.h"

#define TIME 59 //倒计时时间

@interface ValidatePhoneNoViewController ()
{
    NSInteger time;
    NSTimer *timer;
    NSString *validateSMSStr;  //获取的短信验证码
}

@end

@implementation ValidatePhoneNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (0 == self.intoFlag) { //注册进入
        [self.navigationItem setTitle:@"验证手机号(3/3)"];
    } else { //忘记密码进入
        [self.navigationItem setTitle:@"验证手机"];
    }
    
    _validateNoTextFiled.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (timer) {
        [timer invalidate];
    }
    time = TIME;
    [self.timeLabel setText:[NSString stringWithFormat:@"(%ds)", time]];
    [self getValidateNoBtnClick:_getValidateBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//获取验证码按钮点击事件
- (IBAction)getValidateNoBtnClick:(id)sender {
    //按钮置灰
    UIButton *validateBtn = (UIButton *)sender;
    [validateBtn setEnabled:NO];
    //倒计时
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeNum) userInfo:nil repeats:YES];
    
    //获取验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            DLog(@"获取验证码成功");
        } else {
            [CustomUtil showToastWithText:error.description view:[UIApplication sharedApplication].keyWindow];
        }
    }];
}

//倒计时
-(void)changeNum
{
    if (time > 1) {
        time--;
        [self.timeLabel setText:[NSString stringWithFormat:@"(%ds)", time]];
    } else {
        //关闭定时器
        [timer invalidate];
        time = TIME;
        [self.timeLabel setText:[NSString stringWithFormat:@"(%ds)", time]];
        [self.getValidateBtn setEnabled:YES];
    }
}

//完成按钮点击事件
- (IBAction)completeBtnClick:(id)sender {
    NSLog(@"点击了完成按钮");
    
    if ([CustomUtil CheckParam:_validateNoTextFiled.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入验证码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }

    //校验验证码
    [SMSSDK commitVerificationCode:_validateNoTextFiled.text phoneNumber:_phoneNumber zone:@"86" result:^(NSError *error) {
#ifdef PACKAGEFORTEST
        if (error) {   //验证码错误
#else
        if (!error) {   //验证码正确
#endif
            //跳转至首页
            if (0 == self.intoFlag) { //注册进入
#ifdef OPEN_NET_INTERFACE
                //调用注册接口进行注册
                [RegisterInput shareInstance].phoneType = @"0"; //1：安卓 0：iOS
                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[RegisterInput shareInstance]];
                [[NetInterface shareInstance] registerUser:@"register" param:dict successBlock:^(NSDictionary *responseDict) {
                    RegisterModel *returnData = [RegisterModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(returnData.status)) { //注册成功
                        //调用登录接口
                        [LoginInput shareInstance].phoneNumber = [RegisterInput shareInstance].phoneNumber;
                        [LoginInput shareInstance].userPassword = [RegisterInput shareInstance].userPassword;
                        [LoginInput shareInstance].qqNumber = @"";
                        [LoginInput shareInstance].webchatId = @"";
                        [LoginInput shareInstance].sinaBlog = @"";
                        [LoginInput shareInstance].registerId = [LoginModel shareInstance].registerId;
                        [LoginInput shareInstance].phoneType = @"0";
                        // app版本
                        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                        [LoginInput shareInstance].verison=app_Version;
                        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                        [CustomUtil showLoading:@"正在登录中..."];

                        [[NetInterface shareInstance] login:@"login" param:dict successBlock:^(NSDictionary *responseDict) {
                            LoginModel *returnData = [LoginModel modelWithDict:responseDict];
                            if (RETURN_SUCCESS(returnData.status)) {
                                //跳转至主页
                                TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                                 MainPageTabBarController *viewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                                viewCtrl.loginFlag = YES;
                                [self.navigationController pushViewController:tabBarCtrl animated:YES];
                            } else {
                                [CustomUtil showToastWithText:returnData.msg view:self.view];
                            }
                        } failedBlock:^(NSError *err) {
                        }];
                    } else { //注册失败
                        [CustomUtil showCustomAlertView:@"提示" message:returnData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
                    }
                } failedBlock:^(NSError *err) {
                }];
#else
                //跳转至主页
                TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                [self.navigationController pushViewController:tabBarCtrl animated:YES];
#endif
            } else {  //忘记密码进入
                //跳转至P5_1忘记密码界面
                ForgetPasswordViewController *forgetPaswordViewCtrl = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
                forgetPaswordViewCtrl.phoneNum = _phoneNumber;
                [self.navigationController pushViewController:forgetPaswordViewCtrl animated:YES];
            }
        } else {
            [CustomUtil showToastWithText:@"验证码不正确，请重新获取" view:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }];
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_validateNoTextFiled resignFirstResponder];
    
    return YES;
}

@end
