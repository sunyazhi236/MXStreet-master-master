//
//  SexSetViewController.m
//  mxj
//  P12-1-2性别设置
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SexSetViewController.h"

@interface SexSetViewController ()
{
    BOOL sexFlag;  //用于标记当前选中的性别 YES：男 NO：女
}

@end

@implementation SexSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"性别"];
    self.sexSetTableView.delegate = self;
    self.sexSetTableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[GetUserInfo shareInstance].sex isEqualToString:@"男"]) {
        sexFlag = YES;
        [self.manCellImageView setHidden:NO];
        [self.womenCellImageView setHidden:YES];
    } else {
        sexFlag = NO;
        [self.manCellImageView setHidden:YES];
        [self.womenCellImageView setHidden:NO];
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 54;
            break;
            
        default:
            break;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return self.ManCell;
            break;
        case 1:
            return self.womenCell;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if (NO == sexFlag) {
                [self.manCellImageView setHidden:NO];
                [self.womenCellImageView setHidden:YES];
                sexFlag = YES;
            }
            break;
        case 1:
            if (YES == sexFlag) {
                [self.manCellImageView setHidden:YES];
                [self.womenCellImageView setHidden:NO];
                sexFlag = NO;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -按钮点击事件
//取消按钮点击事件
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//完成按钮点击事件
- (IBAction)finishBtnClick:(id)sender {
    NSString *sexStr;
    if (sexFlag) {
        sexStr = @"男";
    } else {
        sexStr = @"女";
    }
    [ModifyUserDataInput shareInstance].sex = sexStr;
    [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
    [ModifyUserDataInput shareInstance].userSignFlag = @"0";
    [ModifyUserDataInput shareInstance].storeFlag = @"0";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
    [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyUserData *modifyUserData = [ModifyUserData modelWithDict:responseDict];
        if (RETURN_SUCCESS(modifyUserData.status)) {
            [CustomUtil showToastWithText:modifyUserData.msg view:[UIApplication sharedApplication].keyWindow];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CustomUtil showToastWithText:modifyUserData.msg view:self.view];
        }
        return;
    } failedBlock:^(NSError *err) {
    }];
}

@end
