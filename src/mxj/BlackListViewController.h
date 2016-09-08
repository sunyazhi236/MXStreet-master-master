//
//  BlackListViewController.h
//  mxj
//  P12-7黑名单
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface BlackListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *blackListTableView; //黑名单TableView

@end
