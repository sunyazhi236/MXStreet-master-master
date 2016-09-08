//
//  GuideViewController.m
//  mxj
//  P2引导页
//  Created by 齐乐乐 on 15/11/20.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "GuideViewController.h"
#import "WelcomePageViewController.h"
#import "LoginVC.h"

#define ADVANCE_COUNT 3 //引导图片的数量

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化ScrollView
    [self initScrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化ScrollView
- (void)initScrollView
{
    //设置ScrollView的Frame
    CGRect scrollViewFrame = self.guideScrollView.frame;
    scrollViewFrame.size.width = SCREEN_WIDTH;
    scrollViewFrame.size.height = SCREEN_HEIGHT;
    self.guideScrollView.frame = scrollViewFrame;
    
    //设置pageCtroller的风格
    _guidePageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    _guidePageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    CGRect rect = _guidePageCtrl.frame;
    rect.origin.x = (int)((_guideScrollView.frame.size.width - rect.size.width)/2);
    rect.origin.y = _guideScrollView.frame.size.height - _guidePageCtrl.frame.size.height;
    _guidePageCtrl.frame = rect;
    
    //设置ScrollView的内容区域
    [self.guideScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*ADVANCE_COUNT, SCREEN_HEIGHT)];
    //设置ScrollView的属性
    self.guideScrollView.delegate = self;
    [self.guideScrollView setShowsHorizontalScrollIndicator:NO];
    [self.guideScrollView setShowsVerticalScrollIndicator:NO];
    [self.guideScrollView setCanCancelContentTouches:NO];
    
    //添加ImageView
    UIImage *advanceImage;
    for (int i=0; i<ADVANCE_COUNT; i++) {
        switch ((int)SCREEN_HEIGHT) {
            case 480:
            {
                advanceImage = [UIImage imageNamed:[NSString stringWithFormat:@"advance%d_960", (i+1)]];
                
            }
                break;
            case 568:
            {
                advanceImage = [UIImage imageNamed:[NSString stringWithFormat:@"advance%d_1136", (i+1)]];
            }
                break;
            case 736:
            {
                advanceImage = [UIImage imageNamed:[NSString stringWithFormat:@"advance%d_2208", (i+1)]];
            }
                break;
            default:
            {
                advanceImage = [UIImage imageNamed:[NSString stringWithFormat:@"advance%d_1334", (i+1)]];
            }
                break;
        }
        UIImageView *advanceImageView = [[UIImageView alloc] initWithImage:advanceImage];
        CGRect frame = advanceImageView.frame;
        frame.origin.x = i * SCREEN_WIDTH;
        frame.origin.y = 0;
        frame.size.height = SCREEN_HEIGHT;
        frame.size.width = SCREEN_WIDTH;
        advanceImageView.frame = frame;
        
        [self.guideScrollView addSubview:advanceImageView];
        if ((ADVANCE_COUNT - 1) == i) {
            [advanceImageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advanceImageClick)];
            [advanceImageView addGestureRecognizer:tapGesture];
        }
    }
}

#pragma mark -ScrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)fabs(scrollView.contentOffset.x/SCREEN_WIDTH);
    [self.guidePageCtrl setCurrentPage:index];
}

#pragma mark -点击事件处理
//引导图片点击事件处理
-(void)advanceImageClick
{
    //跳转至欢迎页面
//    WelcomePageViewController *viewCtrl = [[WelcomePageViewController alloc] initWithNibName:@"WelcomePageViewController" bundle:nil];
    LoginVC *viewCtrl = [[LoginVC alloc] init];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
