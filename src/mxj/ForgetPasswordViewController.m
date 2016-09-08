//
//  ForgetPasswordViewController.m
//  mxj
//  P5_1忘记密码实现文件
//  Created by 齐乐乐 on 15/11/10.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginViewController.h"
#import "LoginVC.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"找回密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//完成按钮点击事件
- (IBAction)finishBtnClick:(id)sender {
    //检查是否输入了密码
    if ([CustomUtil CheckParam:_passwordTextField.text]) {
        [CustomUtil showToastWithText:@"请输入新密码" view:kWindow];
        return;
    }
    
    if ([CustomUtil CheckParam:_confirmPasswordTextField.text]) {
        [CustomUtil showToastWithText:@"请输入确认密码" view:kWindow];
        return;
    }
    
    //判断两次输入密码是否相同
    if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        [CustomUtil showToastWithText:@"两次输入密码不相同" view:kWindow];
        return;
    }
    
    //修改用户密码
    [ModifyPasswordInput shareInstance].phoneNumber = _phoneNum;
    [ModifyPasswordInput shareInstance].userPassword = [CustomUtil md5HexDigest:_passwordTextField.text];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyPasswordInput shareInstance]];
    [dict removeObjectForKey:@"oldPassword"];
    [[NetInterface shareInstance] modifyPassword:@"modifyPassword" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyPassword *returnData = [ModifyPassword modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
//                if ([viewCtrl isKindOfClass:[LoginViewController class]]) {
                if ([viewCtrl isKindOfClass:[LoginVC class]]) {
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
        }
        [CustomUtil showToastWithText:returnData.msg view:kWindow];
    } failedBlock:^(NSError *err) {
    }];
}

@end
