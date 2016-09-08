//
//  MyFriendsFansViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/28.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyFollowFansViewController.h"

#import "ConcernManViewController.h"
#import "MeFansViewController.h"

#define HEADVIEWHEIGH 55

#define BUTTON_TAG 100

@interface MyFollowFansViewController ()
{
    BOOL flag;
}

@property (nonatomic, strong) UIView        *headView;
@property (nonatomic, strong) UIView        *backView;
//@property (nonatomic, strong) UILabel       *followLabel;
//@property (nonatomic, strong) UILabel       *fansLabel;
//@property (nonatomic, strong) UIImageView   *followBtnIcon;
//@property (nonatomic, strong) UIImageView   *fansBtnIcon;

@property (nonatomic, strong) ConcernManViewController    *followView;
@property (nonatomic, strong) MeFansViewController        *fansView;
@end

@implementation MyFollowFansViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的好友";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    flag = YES;
    
    [self.view addSubview:self.headView];
    
    [self initContent];
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEADVIEWHEIGH)];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        
//        _followBtnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
//        _followBtnIcon.frame = CGRectMake(SCREENWIDTH/2 - 120, 8, 100, 40);
//        _followBtnIcon.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction)];
//        [_followBtnIcon addGestureRecognizer:singleFollow];
//        [_headView addSubview:_followBtnIcon];
//        
//        _followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//        _followLabel.text = @"我的关注";
//        _followLabel.textColor = [UIColor whiteColor];
//        _followLabel.backgroundColor = [UIColor clearColor];
//        _followLabel.font = [UIFont systemFontOfSize:13.0f];
//        _followLabel.textAlignment = NSTextAlignmentCenter;
//        [_followBtnIcon addSubview:_followLabel];
//        
//        
//        _fansBtnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unselect"]];
//        _fansBtnIcon.frame = CGRectMake(SCREENWIDTH/2 + 20, 8, 100, 40);
//        _fansBtnIcon.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleFans = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction)];
//        [_fansBtnIcon addGestureRecognizer:singleFans];
//        [_headView addSubview:_fansBtnIcon];
//        
//        _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//        _fansLabel.text = @"粉丝";
//        _fansLabel.textColor = [UIColor blackColor];
//        _fansLabel.backgroundColor = [UIColor clearColor];
//        _fansLabel.font = [UIFont systemFontOfSize:13.0f];
//        _fansLabel.textAlignment = NSTextAlignmentCenter;
//        [_fansBtnIcon addSubview:_fansLabel];

        CGFloat button_top = (HEADVIEWHEIGH - 30)/2;
        
        CGFloat button_weight = 100;
        
        CGFloat button_height = 30;
        
        NSArray *array = @[@"我的关注", @"粉丝"];
        
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
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y + HEADVIEWHEIGH - 10, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH)];
        [self.view addSubview:_backView];
    }
    return _headView;
}

-(void)initContent{
    [self.backView addSubview:self.followView.view];
    self.followView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
}

-(ConcernManViewController *)followView{
    if (!_followView) {
        _followView = [[ConcernManViewController alloc] initWithNibName:@"ConcernManViewController" bundle:nil];
        _followView.userId = [LoginModel shareInstance].userId;
        _followView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
        _followView.currentViewController = self;
        _followView.type = 1;
    }
    
    _followView.userId = [LoginModel shareInstance].userId;

    return _followView;
}

-(MeFansViewController *)fansView{
    if (!_fansView) {
        _fansView = [[MeFansViewController alloc] initWithNibName:@"MeFansViewController" bundle:nil];
        _fansView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
        _fansView.userId = [LoginModel shareInstance].userId;
        _fansView.currentViewController = self;
        _fansView.type = 1;
    }
    return _fansView;
}

//-(void)btnAction{
//    if (flag) {
//        flag = NO;
//        _followBtnIcon.image = [UIImage imageNamed:@"unselect"];
//        _followLabel.textColor = [UIColor blackColor];
//        
//        _fansBtnIcon.image = [UIImage imageNamed:@"select"];
//        _fansLabel.textColor = [UIColor whiteColor];
//        
//        [self.backView addSubview:self.fansView.view];
//        self.fansView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
//    }
//    else {
//        flag = YES;
//        _followBtnIcon.image = [UIImage imageNamed:@"select"];
//        _followLabel.textColor = [UIColor whiteColor];
//        
//        _fansBtnIcon.image = [UIImage imageNamed:@"unselect"];
//        _fansLabel.textColor = [UIColor blackColor];
//        
//        [self.backView addSubview:self.followView.view];
//        self.followView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH);
//    }
//    
//    
//}

- (void)buttonClick:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i + BUTTON_TAG];
        button.selected = NO;
        if (btn.tag == i+BUTTON_TAG) {
            btn.selected = YES;
        }
    }
    
    if (btn.tag == BUTTON_TAG) {
        // 我的关注
        [self.backView addSubview:self.followView.view];
    }
    else {
        // 粉丝
        [self.backView addSubview:self.fansView.view];
    }
}


@end
