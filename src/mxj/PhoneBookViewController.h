//
//  PhoneBookViewController.h
//  mxj
//  P7-5-1-1手机通讯录
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PhoneBookViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, InvisteUserBtnDelegate>

@property (strong, nonatomic) IBOutlet UITableView *phoneBookTableView; //手机通讯录TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *headOneCell;    //section头Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *headTwoCell;    //section头Cell
@property (nonatomic, assign) int intoFlag;   //入口标记 1：微博好友 2:微信好友 3:QQ好友 4:手机通讯录 

@end
