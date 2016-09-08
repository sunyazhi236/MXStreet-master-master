//
//  MyLevelViewController.h
//  mxj
//  P12-2我的等级
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "MyLevelCell.h"

@interface MyLevelViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myLevelTableView; //我的等级TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *OneCell;      //一次性奖励成长值规则
@property (strong, nonatomic) IBOutlet UITableViewCell *twoCell;      //每日奖励成长值规则
@property (strong, nonatomic) IBOutlet UITableViewCell *threeCell;    //用户等级与成长值的关系



@end
