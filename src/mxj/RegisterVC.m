//
//  RegisterVC.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "RegisterVC.h"
#import "Macro.h"
#import "LineTF.h"
#import "InformationVC.h"
#import "LoginVC.h"

#import "TabBarController.h"
#import "MainPageTabBarController.h"

#define TIME 59

@interface RegisterVC () <UITextFieldDelegate>
{
    NSInteger time;
    NSTimer *timer;
    NSString *validateSMSStr;  //获取的短信验证码
//    Boolean isRegister;
    
//    dispatch_queue_t queue;
//    dispatch_source_t _timer;
}

@property (nonatomic, strong) UIImageView   *logoView;
@property (nonatomic, strong) LineTF        *userNameTextField;
@property (nonatomic, strong) LineTF        *codeTextField;
@property (nonatomic, strong) LineTF        *passwordTextField;
@property (nonatomic, strong) UIButton      *codeButton;
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) NSString      *phoneNumber;

@end

@implementation RegisterVC

//-(void)viewWillDisappear:(BOOL)animated{
//    dispatch_source_cancel(_timer);
//}

#pragma viewLife

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isRegister == 0) {
        self.title = @"注册";
    } else {
        self.title = @"重置密码";
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    if (timer) {
        [timer invalidate];
    }
    time = TIME;
    
    [self initView];
}

#pragma initView
-(void)initView{
    UIImage *logo = [UIImage imageNamed:@"logonew"];
    _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 150)/2, 44, 150, 46)];
    _logoView.image = logo;
//    _logoView.frame = CGRectMake(0, 44, SCREENWIDTH, 55);
//    _logoView.frame = CGRectMake(0, 44, 150, 46);
//    _logoView.contentMode =  UIViewContentModeCenter;
    [self.view addSubview:_logoView];
    
    _userNameTextField = [[LineTF alloc] initWithFrame:CGRectMake(55, 150, SCREENWIDTH - 110, 30)];
    [_userNameTextField setBackgroundColor:[UIColor clearColor]];
    _userNameTextField.layer.cornerRadius = 2;
    _userNameTextField.placeholder = @"请输入手机号";
    _userNameTextField.font = [UIFont systemFontOfSize:13.0f];
    [_userNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_userNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _userNameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    _userNameTextField.delegate = self;
    //设置键盘类型
    [_userNameTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_userNameTextField];
    
    _codeTextField = [[LineTF alloc] initWithFrame:CGRectMake(55, 185, SCREENWIDTH - 110, 30)];
    [_codeTextField setBackgroundColor:[UIColor clearColor]];
    _codeTextField.layer.cornerRadius = 2;
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.font = [UIFont systemFontOfSize:13.0f];
    [_codeTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_codeTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _codeTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    _codeTextField.delegate = self;
    [self.view addSubview:_codeTextField];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _codeButton.frame = CGRectMake(SCREENWIDTH - 125, 190, 70, 20);
    _codeButton.backgroundColor = [UIColor colorWithRed:237.0/255 green:58.0/255 blue:59.0/255 alpha:1.0f];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTintColor:[UIColor whiteColor]];
    _codeButton.layer.cornerRadius = 10;
    _codeButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [_codeButton addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    
    _passwordTextField = [[LineTF alloc] initWithFrame:CGRectMake(55, 220, SCREENWIDTH - 110, 30)];
    [_passwordTextField setBackgroundColor:[UIColor clearColor]];
    _passwordTextField.layer.cornerRadius = 2;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = [UIFont systemFontOfSize:13.0f];
    [_passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _passwordTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _registerButton.frame = CGRectMake(55, 300, SCREENWIDTH - 110, 40);
    _registerButton.backgroundColor = [UIColor colorWithRed:237.0/255 green:58.0/255 blue:59.0/255 alpha:1.0f];
    if (_isRegister == 0) {
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerOnClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_registerButton setTitle:@"重置" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(reSetOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [_registerButton setTintColor:[UIColor whiteColor]];
    _registerButton.layer.cornerRadius = 20;
    
    [self.view addSubview:_registerButton];
}

#pragma Action
-(void)startTime{
    
    if (![CustomUtil CheckPhoneNumber:_userNameTextField.text viewCtrl:self]) { //检查手机号
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入手机号" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    //获取验证码
    _phoneNumber = _userNameTextField.text;
    _codeButton.backgroundColor = [UIColor grayColor];
    
    //构造参数
    [CheckRegisterInput shareInstance].phoneNumber = _userNameTextField.text;
    [CheckRegisterInput shareInstance].qqNumber = @"";
    [CheckRegisterInput shareInstance].webchatId = @"";
    [CheckRegisterInput shareInstance].sinaBlog = @"";
    
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CheckRegisterInput shareInstance]];
    
    if (_isRegister == 0) {
        //先判断当前手机号是否已注册
        [[NetInterface shareInstance] checkRegister:@"checkRegister" param:dict successBlock:^(NSDictionary *responseDict) {
            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) { //手机号未注册时
                
                //            __block int timeout=59; //倒计时时间
                //            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                //            dispatch_source_set_event_handler(_timer, ^{
                //                if(timeout<=0){ //倒计时结束，关闭
                //                    dispatch_source_cancel(_timer);
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //                        [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                //                        _codeButton.userInteractionEnabled = YES;
                //                    });
                //                }else{
                //                    int seconds = timeout % 60;
                //                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //                        [UIView beginAnimations:nil context:nil];
                //                        [UIView setAnimationDuration:1];
                //                        [_codeButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
                //                        [UIView commitAnimations];
                //                        _codeButton.userInteractionEnabled = NO;
                //                    });
                //                    timeout--;
                //                }
                //            });
                //            dispatch_resume(_timer);
                
                //倒计时
                timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLable) userInfo:nil repeats:YES];
                
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
                    if (!error) {
                        DLog(@"获取验证码成功");
                    } else {
                        NSString *msg = [error.userInfo objectForKey:@"getVerificationCode"];
                        if (msg) {
                            [CustomUtil showToastWithText:msg view:[UIApplication sharedApplication].keyWindow];
                            //                        dispatch_source_cancel(_timer);
                            [timer invalidate];
                            time = TIME;
                            [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                        }else{
                            [CustomUtil showToastWithText:error.description view:[UIApplication sharedApplication].keyWindow];
                        }
                    }
                }];
            } else { //手机号已注册时
                [CustomUtil showToastWithText:@"该手机号已被注册" view:[UIApplication sharedApplication].keyWindow];
                [_codeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
            }
        } failedBlock:^(NSError *err) {
        }];
    }else{
        //倒计时
        timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLable) userInfo:nil repeats:YES];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                DLog(@"获取验证码成功");
            } else {
                NSString *msg = [error.userInfo objectForKey:@"getVerificationCode"];
                if (msg) {
                    [CustomUtil showToastWithText:msg view:[UIApplication sharedApplication].keyWindow];
                    //                        dispatch_source_cancel(_timer);
                    [timer invalidate];
                    time = TIME;
                    [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                }else{
                    [CustomUtil showToastWithText:error.description view:[UIApplication sharedApplication].keyWindow];
                }
            }
        }];
    }
}

//-(void)registerOnClick{
//    InformationVC *vc = [[InformationVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)registerOnClick{
    if ([CustomUtil CheckParam:_userNameTextField.text]) {
        [CustomUtil showToastWithText:@"请输手机号" view:kWindow];
        return;
    }
    if ([CustomUtil CheckParam:_codeTextField.text]) {
        [CustomUtil showToastWithText:@"请输验证码" view:kWindow];
        return;
    }
    if ([CustomUtil CheckParam:_passwordTextField.text]) {
        [CustomUtil showToastWithText:@"请输密码" view:kWindow];
        return;
    }
    
    //组织数据
    [RegisterInput shareInstance].phoneNumber = _userNameTextField.text;
    [RegisterInput shareInstance].userPassword = [CustomUtil md5HexDigest:_passwordTextField.text];
    
    //校验验证码
    [SMSSDK commitVerificationCode:_codeTextField.text phoneNumber:_phoneNumber zone:@"86" result:^(NSError *error) {
        //#ifdef PACKAGEFORTEST
        //        if (error) {   //验证码错误
        //#else
        if (!error) {   //验证码正确
            //#endif
            [timer invalidate];
            time = TIME;
            [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            _codeButton.backgroundColor = [UIColor grayColor];
            InformationVC *vc = [[InformationVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [CustomUtil showToastWithText:@"验证码不正确，请重新输入" view:[UIApplication sharedApplication].keyWindow];
            return;
        }
        //        }
    }];
}

-(void)reSetOnClick{
    //检查是否输入了密码
    if ([CustomUtil CheckParam:_passwordTextField.text]) {
        [CustomUtil showToastWithText:@"请输入新密码" view:kWindow];
        return;
    }
    if ([CustomUtil CheckParam:_userNameTextField.text]) {
        [CustomUtil showToastWithText:@"请输入手机号" view:kWindow];
        return;
    }
    if ([CustomUtil CheckParam:_codeTextField.text]) {
        [CustomUtil showToastWithText:@"请输入验证码" view:kWindow];
        return;
    }
    
    //校验验证码
    [SMSSDK commitVerificationCode:_codeTextField.text phoneNumber:_phoneNumber zone:@"86" result:^(NSError *error) {
        if (!error) {
            [timer invalidate];
            time = TIME;
            [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            _codeButton.backgroundColor = [UIColor grayColor];
            //修改用户密码
            [ModifyPasswordInput shareInstance].phoneNumber = _userNameTextField.text;
            [ModifyPasswordInput shareInstance].userPassword = [CustomUtil md5HexDigest:_passwordTextField.text];
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyPasswordInput shareInstance]];
            [dict removeObjectForKey:@"oldPassword"];
            [[NetInterface shareInstance] modifyPassword:@"modifyPassword" param:dict successBlock:^(NSDictionary *responseDict) {
                ModifyPassword *returnData = [ModifyPassword modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                        if ([viewCtrl isKindOfClass:[LoginVC class]]) {
                            [self.navigationController popToViewController:viewCtrl animated:YES];
                        }
                    }
                }
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            } failedBlock:^(NSError *err) {
            }];
        }
        else {
            [CustomUtil showToastWithText:@"验证码不正确，请重新输入" view:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }];
}

//倒计时
-(void)changeLable
{
    if (time > 1) {
        time--;
        [_codeButton setTitle:[NSString stringWithFormat:@"%ld s",(long)time] forState:UIControlStateNormal];
        [UIView commitAnimations];
        _codeButton.userInteractionEnabled = NO;
    } else {
        //关闭定时器
        [timer invalidate];
        time = TIME;
        [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        _codeButton.userInteractionEnabled = YES;
    }
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
