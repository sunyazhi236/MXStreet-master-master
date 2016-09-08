//
//  LabelMainViewController.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/26.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface LabelMainViewController : BaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, copy) NSString *userId; //查询的用户Id

@end
