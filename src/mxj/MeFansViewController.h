//
//  MeFansViewController.h
//  mxj
//  P11我的粉丝视图控制器头文件
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "UserImageViewClickProtocol.h"

@interface MeFansViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UserImageViewClickProtocol,GuanZhuBtnClickDelegate>

@property (strong, nonatomic) IBOutlet UITableView *meFansTableView; //我的粉丝TableView
@property (nonatomic, copy) NSString *userId; //需要查询的用户Id
@property (nonatomic, copy) NSString *sex;//判断我的他的粉丝的男女
@property (nonatomic, weak) BaseViewController *currentViewController;
@property (nonatomic, assign) NSInteger         type;

@end
