//
//  LabelDetailViewController.m
//  mxj
//
//  Created by shanpengtao on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LabelDetailViewController.h"
#import "LabelListViewController.h"
#import "LabelUserViewController.h"

#define BUTTON_TAG 100

@interface LabelDetailViewController ()

@property (nonatomic, strong) LabelListViewController *listVC;

@property (nonatomic, strong) LabelUserViewController *userVC;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *backView;

@end

@implementation LabelDetailViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:_tagName];

    self.view.backgroundColor = RGB(236, 236, 236, 1);;
    
    [self initContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initContent {
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - 10, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH)];
    [self.view addSubview:_backView];

    if (_type == 0) {
        _backView.frame = CGRectMake(0, self.headView.frame.origin.y + HEADVIEWHEIGH - 10, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
        
        [self.view addSubview:self.headView];
        
        //查询标签使用用户数
        [GetTagUserNumInput shareInstance].tagId = _tagId;
        NSMutableDictionary *dictInput = [CustomUtil modelToDictionary:[GetTagUserNumInput shareInstance]];
        [[NetInterface shareInstance] getTagUserNum:@"getTagUserNum" param:dictInput successBlock:^(NSDictionary *responseDict) {
            GetTagUserNum *returnData = [GetTagUserNum modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                
                GetTagUserNum *returnData = [GetTagUserNum modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    self.totalUser = returnData.userNum;
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
            }
            else {
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            }
        } failedBlock:^(NSError *err) {
            
        }];
    }
    
    [self.backView addSubview:self.listVC.view];
}

#pragma mark - Set

- (void)setTotalnum:(NSString *)totalnum
{
    _totalnum = totalnum;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:0 + BUTTON_TAG];
  
    
    if ([_totalnum integerValue] > 0) {
        [button setTitle:[NSString stringWithFormat:@"街拍 %@",_totalnum] forState:UIControlStateNormal];
    }
}

- (void)setTotalUser:(NSString *)totalUser
{
    _totalUser = totalUser;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1 + BUTTON_TAG];
   
    if ([_totalUser integerValue] > 0) {
        [button setTitle:[NSString stringWithFormat:@"用户 %@",_totalUser] forState:UIControlStateNormal];
    }
}

#pragma mark - Get

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEADVIEWHEIGH)];
        
        _headView.backgroundColor = RGB(236, 236, 236, 1);
        
        CGFloat button_top = (HEADVIEWHEIGH - 30)/2;
        
        CGFloat button_weight = 100;
        
        CGFloat button_height = 30;
        
        NSArray *array = @[@"街拍", @"用户"];
        
        CGFloat button_offset_x = (SCREEN_WIDTH - array.count * button_weight) / 3;
        
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                button.selected = YES;
            }
            button.tag = i + BUTTON_TAG;
            button.badgeCenterOffset = CGPointMake(-6, 4);
            button.titleLabel.font = FONT(12);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(button_offset_x * (i + 1) + button_weight * i, button_top, button_weight, button_height);
            
            UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 0, 10);
            
            UIImage *img1 = [UIImage imageNamed:@"按钮-未选"];
            img1 = [img1 resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
            
            [button setBackgroundImage:img1 forState:UIControlStateNormal];
            
            UIImage *img2 = [UIImage imageNamed:@"按钮-选中"];
            img2 = [img2 resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
            
            [button setBackgroundImage:img2 forState:UIControlStateSelected];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#a3a3a3"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_headView addSubview:button];
        }
    }
    return _headView;
}

- (LabelListViewController *)listVC
{
    if (!_listVC) {
        _listVC = [[LabelListViewController alloc] initWithNibName:@"LabelListViewController" bundle:nil];
        _listVC.tagId = self.tagId;
        _listVC.type = self.type;
        _listVC.userId = self.userId;
        _listVC.superViewController = self;
    }
    return _listVC;
}

- (LabelUserViewController *)userVC
{
    if (!_userVC) {
        _userVC = [[LabelUserViewController alloc] init];
        _userVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
        _userVC.tagId = self.tagId;
        _userVC.superViewController = self;
    }
    return _userVC;
}

#pragma mark - Action

- (void)buttonClick:(UIButton *)btn
{
    for (int i = 0; i < 2; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i + BUTTON_TAG];
        button.selected = NO;
        if (btn.tag == i + BUTTON_TAG) {
            btn.selected = YES;
        }
    }
    
    if (btn.tag == BUTTON_TAG) {
        // 街拍
        [self.backView addSubview:self.listVC.view];
    }
    else {
        // 用户
        [self.backView addSubview:self.userVC.view];
    }
}


@end
