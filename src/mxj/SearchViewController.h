//
//  SearchViewController.h
//  mxj
//  P7-1搜索页面
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *labelBtn; //标签按钮
@property (strong, nonatomic) IBOutlet UIButton *doorBtn;  //门牌按钮
@property (strong, nonatomic) IBOutlet UIButton *userBtn;  //用户按钮

@property (strong, nonatomic) IBOutlet UITableView *searchResultTableView;  //搜索结果TableView

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;  //搜索输入框




@end