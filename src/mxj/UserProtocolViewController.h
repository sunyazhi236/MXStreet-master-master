//
//  UserProtocolViewController.h
//  mxj
//  P4-1-1用户协议试图控制头文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

@interface UserProtocolViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userProtocolTableView;  //协议TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;          //行

@end
