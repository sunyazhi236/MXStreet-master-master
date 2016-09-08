//
//  MessageViewController.h
//  mxj
//  P8消息头文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController

// 已读按钮
@property (strong, nonatomic) IBOutlet UIButton *allReadButton; //tableView

@property (strong, nonatomic) UITabBarController *tabBarCtrl;         //TabBar对象

- (void)buttonClickWithType:(NSInteger)type;

@end
