//
//  TabBarController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "TabBarController.h"
#import "MainPageTabBarController.h"
#import "MessageViewController.h"
#import "MyViewController.h"
#import "PublishStreetPhotoViewController.h"
#import "StreetPhotoViewController.h"

#import "NewMyVC.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view from its nib.
    MainPageTabBarController *viewCtrl1 = [[MainPageTabBarController alloc] initWithNibName:@"MainPageTabBarController" bundle:nil];
    UIViewController *viewCtrl2 = [[StreetPhotoViewController alloc] initWithNibName:@"StreetPhotoViewController" bundle:nil];
    UIViewController *viewCtrl3 = [[PublishStreetPhotoViewController alloc] initWithNibName:@"PublishStreetPhotoViewController" bundle:nil];
    ((PublishStreetPhotoViewController *)viewCtrl3).intoFlag = 1;
    MessageViewController *viewCtrl4 = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    viewCtrl4.tabBarCtrl = self;
//    MyViewController *viewCtrl5 = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    NewMyVC *viewCtrl5 = [[NewMyVC alloc] init];
    [self setViewControllers:[NSArray arrayWithObjects:viewCtrl1, viewCtrl2, viewCtrl3, viewCtrl4, viewCtrl5, nil]];
    NSString *itemTitle = @"";
    NSString *defaultImageName = @"";
    NSString *selectImageName = @"";
    for (int i=0; i<self.tabBar.items.count; i++) {
        switch (i) {
            case 0:
            {
                itemTitle = @"首页";
                defaultImageName = @"home";
                selectImageName = @"home02";
            }
                break;
            case 1:
            {
                itemTitle = @"发线";
                defaultImageName = @"eye";
                selectImageName = @"eye02";
            }
                break;
            case 2:
            {
                itemTitle = @"";
                defaultImageName = @"camera";
                selectImageName = @"camera";
            }
                break;
            case 3:
            {
                itemTitle = @"消息";
                defaultImageName = @"mail";
                selectImageName = @"mail02";
            }
                break;
            case 4:
            {
                itemTitle = @"我的";
                defaultImageName = @"user";
                selectImageName = @"user02";
            }
                break;
            default:
                break;
        }
        [[self.tabBar.items objectAtIndex:i] setTitle:itemTitle];
        UIImage * normalImage = [[UIImage imageNamed:defaultImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [[self.tabBar.items objectAtIndex:i] setImage:normalImage];
        [[self.tabBar.items objectAtIndex:i] setSelectedImage:selectImage];
        if (2 == i) {
            //修改发布街拍按钮的风格
            [self.tabBar.items objectAtIndex:i].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            UIImage * normalImage = [[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [[self.tabBar.items objectAtIndex:i] setImage:normalImage];
            [[self.tabBar.items objectAtIndex:i] setSelectedImage:normalImage];
        }
//        if (1 == i) {
//            //修改发现按钮的风格
//            [self.tabBar.items objectAtIndex:i].imageInsets = UIEdgeInsetsMake(0, -6, 0, 6);
//        }
//        if (3 == i) {
//            //修改消息按钮的风格
//            [self.tabBar.items objectAtIndex:i].imageInsets = UIEdgeInsetsMake(0, 6, 0, -6);
//        }
    }
    UIColor *titleHighlightedColor = [UIColor colorWithRed:187/255.0 green:9/255.0 blue:23/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //选中tabBar的首个Item
    //[se setSelectedItem:(tabBarCtrl.tabBar.items)[0]];
    self.pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/TABBAR_ITEM_COUNT * 4 - (SCREEN_WIDTH/TABBAR_ITEM_COUNT/2 - 5), 7, 10, 10)];
    [self.pointImageView setImage:[UIImage imageNamed:@"dian"]];
    [self.tabBar addSubview:self.pointImageView];
    [self.pointImageView setHidden:YES];
    
   //////////////////////////////////////////////////小红点进入首页就显示消息的
    
    
//    [GetUnreadNumInput shareInstance].userId = [LoginModel shareInstance].userId;
//    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUnreadNumInput shareInstance]];
//    [[NetInterface shareInstance] getUnreadNum:@"getUnreadNum" param:dict successBlock:^(NSDictionary *responseDict) {
//        GetUnreadNum *unreadNumData = [GetUnreadNum modelWithDict:responseDict];
//        if (RETURN_SUCCESS(unreadNumData.status)) {
//            //设置消息圆点
//            if (([unreadNumData.commentNum intValue] > 0) ||
//                ([unreadNumData.noticeNum intValue] > 0)  ||
//                ([unreadNumData.messageNum intValue] > 0) ||
//                ([unreadNumData.praiseNum intValue] > 0)) {
//                [self.pointImageView setHidden:NO];
//            } else {
//                [self.pointImageView setHidden:YES];
//            }
//            //设置桌面图标右上角的数字
//            NSInteger badgeNum = [unreadNumData.commentNum intValue] + [unreadNumData.noticeNum intValue] + [unreadNumData.messageNum intValue] + [unreadNumData.praiseNum intValue];
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNum;
//            [JPUSHService setBadge:badgeNum];
//        }
//    } failedBlock:^(NSError *err) {
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏消息右上角的图标
-(void)hideMessageImageView
{
    [self.pointImageView setHidden:YES];
}

//显示消息右上角的图标
-(void)displayMessageImageView
{
    [self.pointImageView setHidden:NO];
}

//tabBar切换时的代理方法
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"首页"]) {
        _intoStreetFlag = 0;
    } else if ([item.title isEqualToString:@"发线"]) {
        _intoStreetFlag = 1;
    } else if ([item.title isEqualToString:@"消息"]) {
        _intoStreetFlag = 3;
    } else if ([item.title isEqualToString:@"我的"]) {
        _intoStreetFlag = 4;
    } else {
        /*
        PublishStreetPhotoViewController *viewCtrl = (PublishStreetPhotoViewController *)self.viewControllers[2];
        [viewCtrl.labelArray removeAllObjects];
         */
    }
}

@end
