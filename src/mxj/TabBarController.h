//
//  TabBarController.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController<UITabBarDelegate>

@property (strong, nonatomic) UIImageView *pointImageView;  //消息图标右上角的小圆点
@property (assign, nonatomic) int intoStreetFlag;          //进入街拍前所选中的Item标识
@property (strong, nonatomic) UITabBarController *tabBarCtrl;
//隐藏消息右上角的图标
-(void)hideMessageImageView;
//显示消息右上角的图标
-(void)displayMessageImageView;

@end
