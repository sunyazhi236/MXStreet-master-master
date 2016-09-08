//
//  SetAccountViewController.m
//  mxj
//  P4-2注册-设置账号和密码实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SetAccountViewController.h"
#import "ValidatePhoneNoViewController.h"
//#import "LoginViewController.h"
#import "LoginVC.h"

@interface SetAccountViewController ()

@end

@implementation SetAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置导航栏标题
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"设置账号和密码2/3"];
    //设置导航栏右上角的下一步按钮
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClick)];
    [nextBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nextBtn;
    _phoneTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    
    _phoneTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//下一步按钮的点击事件
-(void)nextBtnClick
{
    //检查参数
    if (![CustomUtil CheckPhoneNumber:_phoneTextField.text viewCtrl:self]) { //检查手机号
        return;
    }
    
    if ([CustomUtil CheckParam:_passwordTextField.text]) { //检查密码
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }

#ifdef OPEN_NET_INTERFACE
    //构造参数
    [CheckRegisterInput shareInstance].phoneNumber = _phoneTextField.text;
    [CheckRegisterInput shareInstance].qqNumber = @"";
    [CheckRegisterInput shareInstance].webchatId = @"";
    [CheckRegisterInput shareInstance].sinaBlog = @"";
    
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CheckRegisterInput shareInstance]];
    //先判断当前手机号是否已注册
    [[NetInterface shareInstance] checkRegister:@"checkRegister" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) { //手机号未注册时
            //弹出确认手机号码对话框
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码到该手机\n+86%@", [CheckRegisterInput shareInstance].phoneNumber] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [RegisterInput shareInstance].phoneNumber = _phoneTextField.text;
                [RegisterInput shareInstance].userPassword = [CustomUtil md5HexDigest:_passwordTextField.text];
                //跳转至验证手机号画面
                ValidatePhoneNoViewController *validatePhoneNoViewCtrl = [[ValidatePhoneNoViewController alloc] initWithNibName:@"ValidatePhoneNoViewController" bundle:nil];
                validatePhoneNoViewCtrl.intoFlag = 0; //从注册界面进入
                validatePhoneNoViewCtrl.phoneNumber = _phoneTextField.text;
                [self.navigationController pushViewController:validatePhoneNoViewCtrl animated:YES];
            }];
            [alertCtrl addAction:modifyAction];
            [alertCtrl addAction:confirmAction];
            [self presentViewController:alertCtrl animated:YES completion:nil];
        } else { //手机号已注册时
            //弹出提示信息对话框
            UIAlertController *messageAlertCtrl = [UIAlertController alertControllerWithTitle:@"" message:returnData.msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *reinputPhoneNumberAction = [UIAlertAction actionWithTitle:@"重填手机号" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *backLoginAction = [UIAlertAction actionWithTitle:@"返回登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳转至登录界面
//                LoginViewController *loginViewCtrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                LoginVC *loginViewCtrl = [[LoginVC alloc] init];
                [self.navigationController pushViewController:loginViewCtrl animated:YES];
            }];
            [messageAlertCtrl addAction:reinputPhoneNumberAction];
            [messageAlertCtrl addAction:backLoginAction];
            [self presentViewController:messageAlertCtrl animated:YES completion:nil];
        }
    } failedBlock:^(NSError *err) {
    }];
#else
    //跳转至验证手机号画面
    ValidatePhoneNoViewController *validatePhoneNoViewCtrl = [[ValidatePhoneNoViewController alloc] initWithNibName:@"ValidatePhoneNoViewController" bundle:nil];
    validatePhoneNoViewCtrl.intoFlag = 0; //从注册界面进入
    validatePhoneNoViewCtrl.phoneNumber = _phoneTextField.text;
    [self.navigationController pushViewController:validatePhoneNoViewCtrl animated:YES];
#endif
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_phoneTextField == textField) { //手机号TextField
        [_passwordTextField becomeFirstResponder];
    } else if (_passwordTextField == textField) { //密码TextField
        [_passwordTextField resignFirstResponder];
    }
    
    return YES;
}

@end
