//
//  guanYuWoMenViewController.h
//  mxj
//  P12-6关于我们视图控制器头文件
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface guanYuWoMenViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *guanYuTableView;  //tableview
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;    //行

@end
