//
//  WelcomePageViewController.m
//  mxj
//  P3欢迎页ViewController实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "WelcomePageViewController.h"
//#import "RegisterViewController.h"
#import "TabBarController.h"
#import "LoginVC.h"

@interface WelcomePageViewController ()

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //隐藏状态栏 TODO
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//注册或登录毛线街按钮点击事件处理
- (IBAction)registerOrLoginBtnClick:(id)sender {
    NSLog(@"点击了注册或登录毛线街按钮。");
    //[TKLoginType shareInstance].loginType = YES;
    //跳转到P4注册界面
//    RegisterViewController *registerViewCtrl = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
//    LoginVC *registerViewCtrl = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
//    [self.navigationController pushViewController:registerViewCtrl animated:YES];
    LoginVC *vc = [[LoginVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//随便看看按钮点击事件处理
- (IBAction)seeAnyWayBtnClick:(id)sender {
    NSLog(@"点击了随便看看按钮。");
    //[TKLoginType shareInstance].loginType = NO;
    //设置导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    //跳转至主页
    TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
    [tabBarCtrl setSelectedIndex:1]; //进入街拍界面
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:tabBarCtrl animated:YES];
    //设置其它TabBarItem为不可用状态
    for (int i=0; i<tabBarCtrl.tabBar.items.count; i++) {
        if (1 != i) {
            [tabBarCtrl.tabBar.items[i] setEnabled:NO];
        }
    }
}


@end
