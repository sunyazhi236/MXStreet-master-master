//
//  ConcernManViewController.h
//  mxj
//  P10我的关注视图控制器头文件
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "ConcernManTableViewCell.h"
#import "ConcernManTableCellOne.h"

@interface ConcernManViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UserImageViewClickProtocol, myContactManGuanZhuBtnClickDelegate>
@property (strong, nonatomic) IBOutlet UITableView *concernManTableView; //关注的人TableView
@property (nonatomic, copy) NSString *userId; //查询的用户Id
@property (nonatomic, copy) NSString *sex;//判断我的他的关注的人的男女
@property (nonatomic, weak) BaseViewController *currentViewController;
@property (nonatomic, assign) NSInteger         type;

@end
