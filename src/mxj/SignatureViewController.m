//
//  SignatureViewController.m
//  mxj
//  P12-1-4个性签名
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"个性签名"];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
    [self.backImageView addGestureRecognizer:gusture];
    _signatureTextView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _signatureTextView.text = [GetUserInfo shareInstance].userSign;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
//空白处点击事件
-(void)backImageClick
{
    //隐藏键盘
    [self.signatureTextView resignFirstResponder];
}

//取消按钮点击事件
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//完成按钮点击事件
- (IBAction)finishBtnClick:(id)sender {
#ifdef OPEN_NET_INTERFACE
    [ModifyUserDataInput shareInstance].userSign = _signatureTextView.text;
    [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
    if (YES == [_signatureTextView.text isEqualToString:@""]) {
        [ModifyUserDataInput shareInstance].userSignFlag = @"1";
    } else {
        [ModifyUserDataInput shareInstance].userSignFlag = @"0";
    }
    [ModifyUserDataInput shareInstance].storeFlag = @"0";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
    [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyUserData *modifyUserData = [ModifyUserData modelWithDict:responseDict];
        if (RETURN_SUCCESS(modifyUserData.status)) {
            [LoginModel shareInstance].userSign = _signatureTextView.text;
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

@end
