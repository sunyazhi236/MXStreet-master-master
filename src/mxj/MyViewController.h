//
//  MyViewController.h
//  mxj
//  P9我的 视图控制器头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface MyViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;              //我的 TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *firstTableCell;       //首行Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *guangzhuTableCell;    //关注Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *fensiTableCell;       //粉丝Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *shoucangTableCell;    //收藏Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *shezhiTableCell;      //设置Cell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;        //用户昵称
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;           //级别标签
@property (weak, nonatomic) IBOutlet UILabel *userDoorIdLabel;      //门牌号
@property (weak, nonatomic) IBOutlet UILabel *lessPointLabel;       //升级点数

@end
