//
//  SearchFriendViewController.h
//  mxj
//  P7-5-1搜索好友
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchFriendViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,TencentSessionDelegate, WXApiDelegate>

@property (strong, nonatomic) IBOutlet UITableView *searchFriendTableView; //搜索好友TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *weiboCell;   //微博Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *weixinCell;  //微信Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *qqCell;      //qq Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *tongxunluCell; //通讯录Cell

@end
