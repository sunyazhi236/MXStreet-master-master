//
//  StoreSetViewController.m
//  mxj
//  P12-1-1店铺设置
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "StoreSetViewController.h"

@interface StoreSetViewController ()

@end

@implementation StoreSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"店铺"];
    [_storeTextField setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _storeTextField.text = [GetUserInfo shareInstance].store;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
//取消按钮点击事件
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//完成按钮点击事件
- (IBAction)finishBtnClick:(id)sender {
#ifdef OPEN_NET_INTERFACE
    [ModifyUserDataInput shareInstance].store = _storeTextField.text;
    [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
    [ModifyUserDataInput shareInstance].userSignFlag = @"0";
    if (YES == [_storeTextField.text isEqualToString:@""]) {
        [ModifyUserDataInput shareInstance].storeFlag = @"1";
    } else {
        [ModifyUserDataInput shareInstance].storeFlag = @"0";
    }
    
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
    [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyUserData *modifyUserData = [ModifyUserData modelWithDict:responseDict];
        if (RETURN_SUCCESS(modifyUserData.status)) {
            [CustomUtil showToastWithText:modifyUserData.msg view:[UIApplication sharedApplication].keyWindow];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CustomUtil showToastWithText:modifyUserData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_storeTextField resignFirstResponder];
    
    return YES;
}

@end
