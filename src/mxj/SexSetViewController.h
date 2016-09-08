//
//  SexSetViewController.h
//  mxj
//  P12-1-2性别设置
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SexSetViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *sexSetTableView; //性别设置TableView
@property (strong, nonatomic) IBOutlet UITableViewCell *ManCell;     //男Cell
@property (strong, nonatomic) IBOutlet UIImageView *manCellImageView;//男Cell图标
@property (strong, nonatomic) IBOutlet UITableViewCell *womenCell;   //女Cell
@property (strong, nonatomic) IBOutlet UIImageView *womenCellImageView; //女Cell图标

@end
