//
//  OwnAreaViewController.m
//  mxj
//  P12-1-3所在地区实现文件
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "OwnAreaViewController.h"
#import "AreaSelectViewController.h"
#import "OverSeaSelectViewController.h"

@interface OwnAreaViewController ()

@end

@implementation OwnAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"地区"];
    self.ownAreaTableView.delegate = self;
    self.ownAreaTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return self.chinaTableCell;
        case 1:
            return self.overSeaTableCell;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:              //中国地区列表
        {
            //跳转至P12-1-3-1中国地区设置画面
            AreaSelectViewController *areaSelectViewCtrl = [[AreaSelectViewController alloc] initWithNibName:@"AreaSelectViewController" bundle:nil];
            areaSelectViewCtrl.intoFlag = @"0";
            areaSelectViewCtrl.mainIntoFlag = _intoFlag;
            [RegisterInput shareInstance].country = @"中国";
            [self.navigationController pushViewController:areaSelectViewCtrl animated:YES];
        }
            break;
        case 1:              //海外地区列表
        {
            OverSeaSelectViewController *overSeaSelectViewCtrl = [[OverSeaSelectViewController alloc] initWithNibName:@"OverSeaSelectViewController" bundle:nil];
            overSeaSelectViewCtrl.mainIntoFlag = _intoFlag;
            [self.navigationController pushViewController:overSeaSelectViewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
