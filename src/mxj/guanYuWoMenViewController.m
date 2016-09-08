//
//  guanYuWoMenViewController.m
//  mxj
//  P12-6关于我们视图控制器实现文件
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "guanYuWoMenViewController.h"
#import "UserProtocolViewController.h"

@interface guanYuWoMenViewController ()

@end

@implementation guanYuWoMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"关于我们"];
    
    _guanYuTableView.delegate = self;
    _guanYuTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
//用户协议按钮点击事件
- (IBAction)userProtocolBtnClick:(id)sender {
    UserProtocolViewController *viewCtrl = [[UserProtocolViewController alloc] initWithNibName:@"UserProtocolViewController" bundle:nil];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellOne.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellOne;
}

@end
