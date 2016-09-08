//
//  SetViewController.h
//  mxj
//  P12设置
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SetViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *setTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *geRenZiliaoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bangZhuZhongXinCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *banBenGengXinCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *keFuReXianCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *guanYuWoMenCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *yiJianFanKuiCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *qingChuHuanCunCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *xiaoXiTuiSongCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *heiMingDanCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *xiuGaiMiMaCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *woDeDengJiCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *geiHaoPingCell;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel; //缓存大小标签


@end
