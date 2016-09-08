//
//  EncourageMeViewController.h
//  mxj
//  P8-4赞我头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface EncourageMeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UserImageViewClickProtocol>
@property (strong, nonatomic) IBOutlet UITableView *encourageMeTableView; //赞我TableView

@property (nonatomic, weak) BaseViewController *currentViewController;

@end
