//
//  ChangePasswordViewController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"修改密码"];
    _orginPassword.delegate = self;
    _changedPassword.delegate = self;
    _confrimPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//完成按钮点击事件
- (IBAction)finishBtnClick:(id)sender {
#ifdef OPEN_NET_INTERFACE
    //检查密码是否均已输入
    if ([CustomUtil CheckParam:_orginPassword.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入原始密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    if ([CustomUtil CheckParam:_changedPassword.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入新密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    if ([CustomUtil CheckParam:_confrimPassword.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入确认密码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    //判断原始密码是否正确
    if (![[LoginInput shareInstance].userPassword isEqualToString:[CustomUtil md5HexDigest:_orginPassword.text]]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"原始密码不正确" leftTitle:@"重新输入" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    //判断输入的新密码与确认密码是否相同
    if (![_changedPassword.text isEqualToString:_confrimPassword.text]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"两次输入的新密码不一致" leftTitle:@"重新输入" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    
    //调用修改密码接口
    [ModifyPasswordInput shareInstance].phoneNumber = [LoginInput shareInstance].phoneNumber;
    [ModifyPasswordInput shareInstance].oldPassword = [CustomUtil md5HexDigest:_orginPassword.text];
    [ModifyPasswordInput shareInstance].userPassword = [CustomUtil md5HexDigest:_confrimPassword.text];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyPasswordInput shareInstance]];
    [[NetInterface shareInstance] modifyPassword:@"modifyPassword" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyPassword *returnData = [ModifyPassword modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [LoginInput shareInstance].userPassword = _confrimPassword.text; //更新password
            [CustomUtil showCustomAlertView:@"提示" message:returnData.msg leftTitle:@"确定" rightTitle:nil leftHandle:^(UIAlertAction *action) {
                //跳转至设置页面
                [LoginModel shareInstance].userPassword = [CustomUtil md5HexDigest:_confrimPassword.text];
                [self.navigationController popViewControllerAnimated:YES];
            } rightHandle:nil target:self btnCount:1];
        } else {
            [CustomUtil showCustomAlertView:@"提示" message:returnData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
            return;
        }
    } failedBlock:^(NSError *err) {
    }];
#else
    //跳转至设置页面
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_orginPassword == textField) {
        [_changedPassword becomeFirstResponder];
    }
    
    if (_changedPassword == textField) {
        [_confrimPassword becomeFirstResponder];
    }
    
    if (_confrimPassword == textField) {
        [_confrimPassword resignFirstResponder];
    }
    
    return YES;
}

@end
