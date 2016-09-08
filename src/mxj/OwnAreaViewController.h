//
//  OwnAreaViewController.h
//  mxj
//  P12-1-3所在地区头文件
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface OwnAreaViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *ownAreaTableView;       //区域TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *chinaTableCell;     //中国TableCell
@property (strong, nonatomic) IBOutlet UITableViewCell *overSeaTableCell;   //海外TableCell
@property (assign, nonatomic) int intoFlag; //入口标志: 0:首页进入 1:个人资料进入 2:注册进入

@end
