//
//  OverSeaSelectViewController.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface OverSeaSelectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *overSeaSelectTableView; //tableView
@property (assign, nonatomic) NSInteger mainIntoFlag; //父界面入口标志 0:首页 1:个人资料 2:注册



@end
