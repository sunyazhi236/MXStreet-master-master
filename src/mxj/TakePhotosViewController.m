//
//  TakePhotosViewController.m
//  mxj
//  P7-2拍照
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "TakePhotosViewController.h"
#import "EditPhotoViewController.h"

@interface TakePhotosViewController ()

@end

@implementation TakePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    //调整布局
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    self.view.frame = rect;
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

@end
