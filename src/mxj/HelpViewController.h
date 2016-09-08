//
//  HelpViewController.h
//  mxj
//  P12-5帮助中心
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface HelpViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *helpTableView;  //帮助TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;  //行

@end
