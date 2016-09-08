//
//  LabelUserViewController.h
//  mxj
//
//  Created by shanpengtao on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "LabelDetailViewController.h"

@interface LabelUserViewController : BaseViewController

@property (nonatomic, copy) NSString *tagId;   //标签Id

@property (weak, nonatomic) LabelDetailViewController *superViewController;

@property (strong, nonatomic) UITableView *labelListTableView; //标签列表TableView

@property (strong, nonatomic) UIView *backView;

@end
