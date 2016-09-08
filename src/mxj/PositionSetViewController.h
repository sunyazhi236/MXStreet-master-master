//
//  PositionSetViewController.h
//  mxj
//  P7-3-1设置位置信息
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PositionSetViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MAMapViewDelegate, AMapSearchDelegate>

@property (strong, nonatomic) IBOutlet UITableView *positionSetTableView; //TableView
@property (strong, nonatomic) IBOutlet UITextField *positionSetTextFiled; //搜索TextField
@property (weak, nonatomic) IBOutlet UIImageView *mapBackGroundView;      //地图背景

@end
