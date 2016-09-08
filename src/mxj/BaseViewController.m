//
//  BaseViewController.m
//  mxj
//  视图控制器基类实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "NSObject+Crashlytics.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCrashUserInfo];
    
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    //设置导航栏左侧返回按钮-设置文字
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    [backButtonItem setTintColor:[UIColor whiteColor]];
    //设置返回按钮的图片
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    //设置标题栏文字颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回按钮的点击事件处理
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
