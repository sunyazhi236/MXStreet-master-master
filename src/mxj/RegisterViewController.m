//
//  RegisterViewController.m
//  mxj
//  P4注册ViewController实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterCreatePersonInfViewController.h"
//#import "LoginViewController.h"
#import "LoginVC.h"
#import "WelcomePageViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 按钮点击事件处理
//删除按钮点击事件
- (IBAction)deleteBtnClick:(id)sender {
    for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
        if ([viewCtrl isKindOfClass:[WelcomePageViewController class]]) {
            [self.navigationController popToViewController:viewCtrl animated:YES];
        }
    }
}

//注册按钮点击事件
- (IBAction)registerBtnClick:(id)sender {
    //跳转至注册界面
    RegisterCreatePersonInfViewController *registerCreatePersonInfViewCtrl = [[RegisterCreatePersonInfViewController alloc] initWithNibName:@"RegisterCreatePersonInfViewController" bundle:nil];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:registerCreatePersonInfViewCtrl animated:YES];
}

//登录按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    //判断用户是否已登录过
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.plist"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:userInfoPath]) {
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile:userInfoPath];
        [TKLoginAccount shareInstance].phoneNum = [userInfoDict objectForKey:@"phoneNum"];
        [TKLoginAccount shareInstance].password = [userInfoDict objectForKey:@"password"];
    } else {
        [TKLoginAccount shareInstance].phoneNum = @"";
        [TKLoginAccount shareInstance].password = @"";
    }
    //跳转至登录界面
//    LoginViewController *loginViewCtrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    LoginVC *loginViewCtrl = [[LoginVC alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:loginViewCtrl animated:YES];
}

//QQ按钮点击事件
- (IBAction)qqBtnClick:(id)sender {
    [CustomUtil qqLogin:NO personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
}

//微信按钮点击事件
- (IBAction)weixinBtnClick:(id)sender {
    [CustomUtil weixinLogin:self shareFlag:NO personOrZone:NO inviteUser:NO image:nil shareContent:@""];
}

//新浪登录按钮点击事件
- (IBAction)xinlangBtnClick:(id)sender {
    [CustomUtil sinaLogin:NO viewCtrl:@"RegisterViewController" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
}

@end
