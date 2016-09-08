//
//  CommentViewController.h
//  mxj
//  P8-1评论头文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserImageViewClickProtocol>

@property (strong, nonatomic) IBOutlet UITableView *commentTableView; //评论TableView
@property (strong, nonatomic) IBOutlet UIView *commentView; //回复栏

@property (nonatomic, weak) BaseViewController *currentViewController;

@end
