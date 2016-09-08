//
//  AreaSelectViewController.h
//  mxj
//  P12-1-3-1中国地区设置头文件
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface AreaSelectViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *areaSelectTableView; //地区选择TableView
@property (copy, nonatomic) NSString *intoFlag; //入口指示器 0:省份 1:城市
@property (assign, nonatomic) NSInteger mainIntoFlag; //父画面入口标记 0:首页进入 1:个人资料 2:注册
@property (copy, nonatomic) NSString *selectProvinceId; //选中的省份Id
@property (copy, nonatomic) NSString *selectCityId;     //选中的城市Id


@end
