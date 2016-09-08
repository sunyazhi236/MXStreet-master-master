//
//  MeFansViewController.m
//  mxj
//  P11我的粉丝视图控制器实现文件
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MeFansViewController.h"
#import "MeFansTableViewOneCell.h"
#import "MeFansTableViewTwoCell.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"

@interface MeFansViewController ()

@end

@implementation MeFansViewController
{
    NSMutableArray *infoList; //数据
    NSInteger *clickRowIndex; //点击的行
    int currentPageNum;       //当前页号
    UILabel *moreLabel;       //查看更多标签
    UIView *moreView;         //查看更多背景
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([_userId isEqualToString:[LoginModel shareInstance].userId]) {
        [self.navigationItem setTitle:@"我的粉丝"];
    }else if ([_sex isEqualToString:@"男"]) {
        [self.navigationItem setTitle:@"他的粉丝"];
    }else  {
        [self.navigationItem setTitle:@"她的粉丝"];
    }
    
    self.meFansTableView.delegate = self;
    self.meFansTableView.dataSource = self;
    
    //添加查看更多标签
    if (!moreLabel) {
        moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [moreLabel setText:@"查看更多"];
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
        [moreLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [moreLabel setTextColor:[UIColor darkGrayColor]];
    }
    if (!moreView) {
        moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    }
    [moreView addSubview:moreLabel];
    [moreLabel setCenter:CGPointMake(SCREEN_WIDTH/2.0f, moreView.center.y)];
    
    infoList = [[NSMutableArray alloc] init];
    
    currentPageNum = 1;
    //添加上拉加载更多
    __weak MeFansViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __weak UITableView *meFansTableViewSelf = _meFansTableView;
    __block NSMutableArray *dataSelf = infoList;
    __weak UIView *moreViewSelf = moreView;
    //下拉刷新
    [_meFansTableView addPullToRefreshWithActionHandler:^{
        meFansTableViewSelf.tableFooterView = nil;
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^(GetFansList *fansList) {
                currentPageNumSelf = 1;
                currentPageNum = currentPageNumSelf;
                [blockSelf.meFansTableView.pullToRefreshView stopAnimating];
                if ([fansList.totalpage intValue] > currentPageNum) {
                    meFansTableViewSelf.tableFooterView = moreViewSelf;
                } else {
                    meFansTableViewSelf.tableFooterView = nil;
                }
            }];
        });
    }];
    
    //上拉加载更多
    [_meFansTableView addInfiniteScrollingWithActionHandler:^{
        meFansTableViewSelf.tableFooterView = nil;
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            currentPageNum = currentPageNumSelf;
            [blockSelf reloadData:currentPageNumSelf block:^(GetFansList *fansList) {
                [blockSelf.meFansTableView.infiniteScrollingView stopAnimating];
                if ([fansList.totalpage intValue] > currentPageNum) {
                    meFansTableViewSelf.tableFooterView = moreViewSelf;
                } else {
                    meFansTableViewSelf.tableFooterView = nil;
                }
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self reloadData:currentPageNum block:^(GetFansList *fansList) {
        if ([fansList.totalpage intValue] > currentPageNum) {
            _meFansTableView.tableFooterView = moreView;
        } else {
            _meFansTableView.tableFooterView = nil;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef OPEN_NET_INTERFACE
    return infoList.count;
#else
    return 4;
#endif
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //首行
            return 54;
        default:
            break;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef OPEN_NET_INTERFACE
    switch (indexPath.row) {
        case 0:
        {
            MeFansTableViewOneCell *meFansTableViewOneCell = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewOneCell"];
            if (!meFansTableViewOneCell) {
                meFansTableViewOneCell = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewOneCell" owner:self options:nil] lastObject];
            }
            GetFansListInfo *fansListInfo = [[GetFansListInfo alloc] initWithDict:[infoList objectAtIndexCheck:indexPath.row]];
            meFansTableViewOneCell.userName.text = fansListInfo.userName;
            meFansTableViewOneCell.userImageView.imageURL = [CustomUtil getPhotoURL:fansListInfo.image];
            meFansTableViewOneCell.userImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
            meFansTableViewOneCell.delegate = self;
            if ([@"1" isEqualToString:fansListInfo.relation]) { //粉丝
//                [meFansTableViewOneCell.guanZhuBtn setBackgroundImage:[UIImage imageNamed:@"btn_11"] forState:UIControlStateNormal];
                [meFansTableViewOneCell.guanZhuBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
//                [meFansTableViewOneCell.guanZhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else if ([@"2" isEqualToString:fansListInfo.relation]) { //互为关注
//                [meFansTableViewOneCell.guanZhuBtn setBackgroundImage:[UIImage imageNamed:@"btn02_11"] forState:UIControlStateNormal];
                if ([_userId isEqualToString:[LoginModel shareInstance].userId]) {
                    [meFansTableViewOneCell.guanZhuBtn setImage:[UIImage imageNamed:@"相互关注"] forState:UIControlStateNormal];
                } else {
                    [meFansTableViewOneCell.guanZhuBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
                }
//                [meFansTableViewOneCell.guanZhuBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
            }
            if ([fansListInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [meFansTableViewOneCell.guanZhuBtn setHidden:YES];
            } else {
                [meFansTableViewOneCell.guanZhuBtn setHidden:NO];
            }
            meFansTableViewOneCell.guanZhuBtn.tag = indexPath.row;
            [meFansTableViewOneCell.guanZhuBtn addTarget:self action:@selector(guanZhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [CustomUtil setImageViewCorner:meFansTableViewOneCell.userImageView];
            
            return meFansTableViewOneCell;
        }
            break;
        default:
        {
            MeFansTableViewTwoCell *meFansTableViewTwoCell = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewTwoCell"];
            if (!meFansTableViewTwoCell) {
                meFansTableViewTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewTwoCell" owner:self options:nil] lastObject];
            }
            
            GetFansListInfo *fansListInfo = [[GetFansListInfo alloc] initWithDict:[infoList objectAtIndexCheck:indexPath.row]];
            meFansTableViewTwoCell.userName.text = fansListInfo.userName;
            meFansTableViewTwoCell.userImageView.imageURL = [CustomUtil getPhotoURL:fansListInfo.image];
            meFansTableViewTwoCell.userImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
            if ([@"1" isEqualToString:fansListInfo.relation]) { //粉丝
//                [meFansTableViewTwoCell.fansBtn setBackgroundImage:[UIImage imageNamed:@"btn_11"] forState:UIControlStateNormal];
                [meFansTableViewTwoCell.fansBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
//                [meFansTableViewTwoCell.fansBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else if ([@"2" isEqualToString:fansListInfo.relation]) { //互为关注
//                [meFansTableViewTwoCell.fansBtn setBackgroundImage:[UIImage imageNamed:@"btn02_11"] forState:UIControlStateNormal];
                if ([_userId isEqualToString:[LoginModel shareInstance].userId]) {
                    [meFansTableViewTwoCell.fansBtn setImage:[UIImage imageNamed:@"相互关注"] forState:UIControlStateNormal];
                } else {
                    [meFansTableViewTwoCell.fansBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
                }
//                [meFansTableViewTwoCell.fansBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
            }
            if ([fansListInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [meFansTableViewTwoCell.fansBtn setHidden:YES];
            } else {
                [meFansTableViewTwoCell.fansBtn setHidden:NO];
            }
            meFansTableViewTwoCell.fansBtn.tag = indexPath.row;
            [meFansTableViewTwoCell.fansBtn addTarget:self action:@selector(guanZhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            meFansTableViewTwoCell.delegate = self;
            [CustomUtil setImageViewCorner:meFansTableViewTwoCell.userImageView];
            
            return meFansTableViewTwoCell;
        }
            break;
    }
#else
    switch (indexPath.row) {
        case 0:
        {
            MeFansTableViewOneCell *meFansTableViewOneCell = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewOneCell"];
            if (!meFansTableViewOneCell) {
                meFansTableViewOneCell = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewOneCell" owner:self options:nil] lastObject];
            }
            meFansTableViewOneCell.delegate = self;
            return meFansTableViewOneCell;
        }
            break;
        case 1:
        {
            MeFansTableViewTwoCell *meFansTableViewTwoCell = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewTwoCell"];
            if (!meFansTableViewTwoCell) {
                meFansTableViewTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewTwoCell" owner:self options:nil] lastObject];
            }
            meFansTableViewTwoCell.delegate = self;
            return meFansTableViewTwoCell;
        }
        case 2:
        {
            MeFansTableViewTwoCell *meFansTableViewTwoCell1 = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewTwoCell"];
            if (!meFansTableViewTwoCell1) {
                meFansTableViewTwoCell1 = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewTwoCell" owner:self options:nil] lastObject];
            }
            [meFansTableViewTwoCell1.fansBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];

//            [meFansTableViewTwoCell1.fansBtn setBackgroundImage:[UIImage imageNamed:@"btn02_11"] forState:UIControlStateNormal];
//            [meFansTableViewTwoCell1.fansBtn setTitle:@"互为关注" forState:UIControlStateNormal];
//            [meFansTableViewTwoCell1.fansBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
            meFansTableViewTwoCell1.delegate = self;
            return meFansTableViewTwoCell1;
        }
        case 3:
        {
            MeFansTableViewTwoCell *meFansTableViewTwoCell = [tableView dequeueReusableCellWithIdentifier:@"MeFansTableViewTwoCell"];
            if (!meFansTableViewTwoCell) {
                meFansTableViewTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"MeFansTableViewTwoCell" owner:self options:nil] lastObject];
            }
            meFansTableViewTwoCell.delegate = self;
            return meFansTableViewTwoCell;
        }
        default:
            break;
    }
#endif
    return [[UITableViewCell alloc] init];
}

//点击cell上用户头像时的处理
-(void)imageViewClick:(id)sender
{
    if (0 == infoList.count) {
        return;
    }
    NSIndexPath *indexPath = [_meFansTableView indexPathForCell:(UITableViewCell *)(((UIButton *)sender).superview.superview)];
    NSDictionary *dict = [infoList objectAtIndexCheck:indexPath.row];
    GetFansListInfo *listInfo = [[GetFansListInfo alloc] initWithDict:dict];
    
    if ([listInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        if (_type == 0) {
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
        else {
            [self.currentViewController.navigationController pushViewController:viewCtrl animated:YES];
        }
    } else {
        MyStreetPhotoViewController *personMainPageViewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        personMainPageViewCtrl.type = 1;
        personMainPageViewCtrl.userId = listInfo.userId;
        if (_type == 0) {
            [self.navigationController pushViewController:personMainPageViewCtrl animated:YES];
        }
        else {
            [self.currentViewController.navigationController pushViewController:personMainPageViewCtrl animated:YES];
        }
    }
}

//加关注按钮点击事件(首行以外）
-(void)guanZhuBtnClick:(UIButton *)button
{
#ifdef OPEN_NET_INTERFACE
    NSLog(@"button.tag = %d", button.tag);
    //调用接口
    NSDictionary *infoDict = [infoList objectAtIndexCheck:button.tag];
    GetFansListInfo *info = [[GetFansListInfo alloc] initWithDict:infoDict];
    [UpdateFollwInput shareInstance].userId = info.userId;
    [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
    
    if ([info.relation isEqualToString:@"1"]) {  //加关注
        [UpdateFollwInput shareInstance].flag = @"0"; //加关注
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
        [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                //刷新界面
                info.relation = @"2";
                infoList[button.tag] = [CustomUtil modelToDictionary:info];
                [_meFansTableView reloadData];
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        } failedBlock:^(NSError *err) {
        }];
    } else if ([info.relation isEqualToString:@"2"]) { //取消关注
        [CustomUtil showCustomAlertView:nil message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
            [UpdateFollwInput shareInstance].flag = @"1"; //取消关注
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                BaseModel *returnData = [BaseModel modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    //刷新界面
                    info.relation = @"1";
                    infoList[button.tag] = [CustomUtil modelToDictionary:info];
                    [_meFansTableView reloadData];
                }
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            } failedBlock:^(NSError *err) {
            }];
        } target:self btnCount:2];
    }
#endif
}

//重新加载数据
-(void)reloadData:(int)current block:(void(^)(GetFansList *fansList))block
{
#ifdef OPEN_NET_INTERFACE
    [GetFansListInput shareInstance].pagesize = @"10";
    [GetFansListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetFansListInput shareInstance].userId = _userId;
    [GetFansListInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetFansListInput shareInstance]];
    [[NetInterface shareInstance] getFansList:@"getFansList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetFansList *getFansList = [GetFansList modelWithDict:responseDict];
        if (RETURN_SUCCESS(getFansList.status)) {
            if (1 == current) {
                [infoList removeAllObjects];
            }
            for (int i=0; i<getFansList.info.count; i++) {
                [infoList addObject:getFansList.info[i]];
            }
            [_meFansTableView reloadData];
        } else {
            [CustomUtil showToastWithText:getFansList.msg view:kWindow];
        }
        block(getFansList);
    } failedBlock:^(NSError *err) {
        
    }];
#endif
}

@end
