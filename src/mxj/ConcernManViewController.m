//
//  ConcernManViewController.m
//  mxj
//  P10我的关注视图控制器实现文件
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "ConcernManViewController.h"
#import "PersonMainPageViewController.h"
#import "SearchViewController.h"
#import "MyStreetPhotoViewController.h"

#define LINES_PERPAGE @"10"; //每页默认获取的行数

@interface ConcernManViewController ()
{
    NSMutableArray *followList; //数据
    NSMutableArray *followListCopy; //数据副本
    int currentPageNum;         //当前page页
    UILabel *moreLabel;
    UIView *moreView;
}

@end

@implementation ConcernManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([_userId isEqualToString:[LoginModel shareInstance].userId]) {
        [self.navigationItem setTitle:@"我关注的人"];
    }
     else if ([_sex isEqualToString:@"男"]) {
        [self.navigationItem setTitle:@"他关注的人"];
    }
    else  {
        [self.navigationItem setTitle:@"她关注的人"];
    }
    
    [self.concernManTableView setDelegate:self];
    [self.concernManTableView setDataSource:self];
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
    //右上角放大镜按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_10"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    followList = [[NSMutableArray alloc] init];
    followListCopy = [[NSMutableArray alloc] init];
    currentPageNum = 1;
    [self reloadData:currentPageNum block:^(GetFollowList *followInfo) {
        if ([followInfo.totalpage intValue] > currentPageNum) {
            _concernManTableView.tableFooterView = moreView;
        } else {
            _concernManTableView.tableFooterView = nil;
        }
    }];
    //添加上拉加载更多
    __weak ConcernManViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = followList;
    __weak UITableView *concernManTableViewSelf = _concernManTableView;
    __weak UIView *moreViewSelf = moreView;
    //下拉刷新
    [_concernManTableView addPullToRefreshWithActionHandler:^{
        concernManTableViewSelf.tableFooterView = nil;
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^(GetFollowList *followInfo) {
                currentPageNumSelf = 1;
                currentPageNum = currentPageNumSelf;
                [blockSelf.concernManTableView.pullToRefreshView stopAnimating];
                if ([followInfo.totalpage intValue] > currentPageNum) {
                    concernManTableViewSelf.tableFooterView = moreViewSelf;
                } else {
                    concernManTableViewSelf.tableFooterView = nil;
                }
            }];
        });
    }];
    
    //上拉加载更多
    [_concernManTableView addInfiniteScrollingWithActionHandler:^{
        concernManTableViewSelf.tableFooterView = nil;
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            currentPageNum = currentPageNumSelf;
            [blockSelf reloadData:currentPageNumSelf block:^(GetFollowList *followInfo) {
                [blockSelf.concernManTableView.infiniteScrollingView stopAnimating];
                if ([followInfo.totalpage intValue] > currentPageNum) {
                    concernManTableViewSelf.tableFooterView = moreViewSelf;
                } else {
                    concernManTableViewSelf.tableFooterView = nil;
                }
            }];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    return followList.count;
#else
    return 4;
#endif
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
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
            ConcernManTableViewCell *concernManCell = [tableView dequeueReusableCellWithIdentifier:@"ConcernManTableViewCell"];
            if (!concernManCell) {
                concernManCell = [[[NSBundle mainBundle] loadNibNamed:@"ConcernManTableViewCell" owner:self options:nil] lastObject];
            }
            [concernManCell.alreadyConcernBtn setTag:indexPath.row];
            //设置用户名
            GetFollowListInfo *info = [[GetFollowListInfo alloc] initWithDict:[followList objectAtIndexCheck:indexPath.row]];
            concernManCell.userNameLabel.text = info.userName;
            concernManCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
            [CustomUtil setImageViewCorner:concernManCell.personImageView];
            if ([@"0" isEqualToString:info.relation]) { //未关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitle:@"+关注" forState:UIControlStateNormal];
            } else if ([@"1" isEqualToString:info.relation]) { //已关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitle:@"已关注" forState:UIControlStateNormal];
            } else if ([@"2" isEqualToString:info.relation]) { //互为关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"相互关注"] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [concernManCell.alreadyConcernBtn setTitle:@"互为关注" forState:UIControlStateNormal];
            }
            if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [concernManCell.alreadyConcernBtn setHidden:YES];
            } else {
                [concernManCell.alreadyConcernBtn setHidden:NO];
            }
            concernManCell.delegate = self;
            concernManCell.gzDelegate = self;
            return concernManCell;
        }
            break;
        default:
        {
            ConcernManTableCellOne *concernManCell = [tableView dequeueReusableCellWithIdentifier:@"ConcernManTableCellOne"];
            if (!concernManCell) {
                concernManCell = [[[NSBundle mainBundle] loadNibNamed:@"ConcernManTableCellOne" owner:self options:nil] lastObject];
            }
            [concernManCell.alreadyConcernBtn setTag:indexPath.row];
            //设置用户名
            GetFollowListInfo *info = [[GetFollowListInfo alloc] initWithDict:[followList objectAtIndexCheck:indexPath.row]];
            concernManCell.userNameLabel.text = info.userName;
            concernManCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
            [CustomUtil setImageViewCorner:concernManCell.personImageView];
            if ([@"0" isEqualToString:info.relation]) { //未关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
            } else if ([@"1" isEqualToString:info.relation]) { //已关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
            } else if ([@"2" isEqualToString:info.relation]) { //互为关注
                [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"相互关注"] forState:UIControlStateNormal];
            }
            if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [concernManCell.alreadyConcernBtn setHidden:YES];
            } else {
                [concernManCell.alreadyConcernBtn setHidden:NO];
            }
            concernManCell.delegate = self;
            concernManCell.gzBtnDelegate = self;
            return concernManCell;
        }
            break;
    }
#else
    switch (indexPath.row) {
        case 0:
        {
            ConcernManTableViewCell *concernManCell = [tableView dequeueReusableCellWithIdentifier:@"ConcernManTableViewCell"];
            if (!concernManCell) {
                concernManCell = [[[NSBundle mainBundle] loadNibNamed:@"ConcernManTableViewCell" owner:self options:nil] lastObject];
            }
            [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
            concernManCell.delegate = self;
            return concernManCell;
        }
            break;
        case 1:
        case 2:
        {
            ConcernManTableCellOne *concernManCell = [tableView dequeueReusableCellWithIdentifier:@"ConcernManTableCellOne"];
            if (!concernManCell) {
                concernManCell = [[[NSBundle mainBundle] loadNibNamed:@"ConcernManTableCellOne" owner:self options:nil] lastObject];
            }
            [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"已经关注"] forState:UIControlStateNormal];
//            [concernManCell.alreadyConcernBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
//            [concernManCell.alreadyConcernBtn setTitle:@"已关注" forState:UIControlStateNormal];
            concernManCell.delegate = self;
            return concernManCell;
        }
            break;
        case 3:
        {
            ConcernManTableCellOne *concernManCell = [tableView dequeueReusableCellWithIdentifier:@"ConcernManTableCellOne"];
            if (!concernManCell) {
                concernManCell = [[[NSBundle mainBundle] loadNibNamed:@"ConcernManTableCellOne" owner:self options:nil] lastObject];
            }
            [concernManCell.alreadyConcernBtn setImage:[UIImage imageNamed:@"相互关注"] forState:UIControlStateNormal];
//            [concernManCell.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [concernManCell.alreadyConcernBtn setTitle:@"互为关注" forState:UIControlStateNormal];
            concernManCell.delegate = self;
            return concernManCell;
        }
            break;
            
        default:
            break;
    }
#endif
    return [[UITableViewCell alloc] init];
}

#ifdef OPEN_NET_INTERFACE
/*
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:_concernManTableView]) {
        result = UITableViewCellEditingStyleDelete;
    }
    
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_concernManTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CustomUtil showCustomAlertView:@"" message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        if (UITableViewCellEditingStyleDelete == editingStyle) {
            if (indexPath.row < followList.count) {
                NSDictionary *infoDict = (NSDictionary *)[[GetFollowList shareInstance].info objectAtIndexCheck:indexPath.row];
                GetFollowListInfo *listInfo = [[GetFollowListInfo alloc] initWithDict:infoDict];
                [UpdateFollwInput shareInstance].userId = listInfo.userId;
                [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
                [UpdateFollwInput shareInstance].flag = @"1";   //取消关注
                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
                //调用接口
                [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                    BaseModel *returnData = [BaseModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(returnData.status)) {
                        [followList removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    [CustomUtil showToastWithText:returnData.msg view:self.view];
                } failedBlock:^(NSError *err) {
                }];
            }
        }
    } target:self btnCount:2];
}
 */
#endif

//右侧放大镜按钮的点击事件
- (void)rightBtnClick
{
    SearchViewController *searchViewCtrl = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewCtrl animated:YES];
}

#pragma mark -按钮点击事件处理
//点击了头像按钮
-(void)imageViewClick:(id)sender
{
    if (0 == followList.count) {
        return;
    }
    NSIndexPath *indexPath = [_concernManTableView indexPathForCell:((UITableViewCell *)(((UIButton *)sender).superview.superview))];
    NSDictionary *info = [followList objectAtIndexCheck:indexPath.row];
    GetFollowListInfo *listInfo = [[GetFollowListInfo alloc] initWithDict:info];
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

//点击了关注按钮
-(void)gzBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:[followList objectAtIndexCheck:button.tag]];
    GetFollowListInfo *info = [[GetFollowListInfo alloc] initWithDict:infoDict];
    
    if ([info.relation integerValue] == 0) {
        // 加关注
        [UpdateFollwInput shareInstance].userId = info.userId;
        [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
        [UpdateFollwInput shareInstance].flag = @"0";   //加关注
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
        
        //调用接口
        [CustomUtil showLoading:@""];
        
        [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                
                if ([info.relation integerValue] == 2) {
                    info.relation = @"2";
                } else {
                    info.relation = @"1";
                }
                [infoDict setValue:info.relation forKey:@"relation"];
                
                [followList replaceObjectAtIndex:button.tag withObject:infoDict];
                
                [_concernManTableView reloadData];
            }
            
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        } failedBlock:^(NSError *err) {
            //                    [CustomUtil showToastWithText:@"网络有问题，请稍后重试！" view:kWindow];
        }];
    }
    else {
        // 已关注 || 相互关注
        
        [CustomUtil showCustomAlertView:@"" message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
            //取消关注
            [UpdateFollwInput shareInstance].userId = info.userId;
            [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
            [UpdateFollwInput shareInstance].flag = @"1";   //取消关注
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
            
            //调用接口
            [CustomUtil showLoading:@""];
            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                BaseModel *returnData = [BaseModel modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    
                    info.relation = @"0";
                    
                    [infoDict setValue:info.relation forKey:@"relation"];

                    [followList replaceObjectAtIndex:button.tag withObject:infoDict];

                    [_concernManTableView reloadData];
                }
                
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            } failedBlock:^(NSError *err) {
            }];
        } target:self btnCount:2];
        
    }
//
//    UIButton *button = (UIButton *)sender;
//    if (([button.titleLabel.text isEqualToString:@"已关注"]) ||
//        ([button.titleLabel.text isEqualToString:@"互为关注"])) {
//        [CustomUtil showCustomAlertView:@"" message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
//            //取消关注
//            if (button.tag < followList.count) {
//                //NSDictionary *infoDict = (NSDictionary *)[[GetFollowList shareInstance].info objectAtIndexCheck:button.tag];
//                NSDictionary *infoDict = [followList objectAtIndexCheck:button.tag];
//                GetFollowListInfo *listInfo = [[GetFollowListInfo alloc] initWithDict:infoDict];
//                [UpdateFollwInput shareInstance].userId = listInfo.userId;
//                [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
//                [UpdateFollwInput shareInstance].flag = @"1";   //取消关注
//                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
//                //调用接口
//                [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
//                    BaseModel *returnData = [BaseModel modelWithDict:responseDict];
//                    if (RETURN_SUCCESS(returnData.status)) {
//                        if ([listInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
//                            UITableViewCell *cell = (UITableViewCell *)(button.superview.superview);
//                            NSIndexPath *indexPath = [_concernManTableView indexPathForCell:cell];
//                            [_concernManTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                        } else {
//                            //[followList removeAllObjects];
//                            //[self reloadData:1 block:^(GetFollowList *followInfo) {
//                            //}];
//                            listInfo.relation = @"0";
//                            [followList setObject:[CustomUtil modelToDictionary:listInfo] atIndexedSubscript:button.tag];
//                            UITableViewCell *cell = (UITableViewCell *)(button.superview.superview);
//                            NSIndexPath *indexPath = [_concernManTableView indexPathForCell:cell];
//                            if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableViewCell class]]) {
//                                ConcernManTableViewCell *tableViewCell = (ConcernManTableViewCell *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                                [tableViewCell.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn_11"] forState:UIControlStateNormal];
//                                [tableViewCell.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                                [tableViewCell.alreadyConcernBtn setTitle:@"+关注" forState:UIControlStateNormal];
//                            } else if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableCellOne class]]) {
//                                ConcernManTableCellOne *tableViewCellOne = (ConcernManTableCellOne *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                                [tableViewCellOne.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn_11"] forState:UIControlStateNormal];
//                                [tableViewCellOne.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                                [tableViewCellOne.alreadyConcernBtn setTitle:@"+关注" forState:UIControlStateNormal];
//                            }
//                        }
//                    }
//                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
//                } failedBlock:^(NSError *err) {
//                }];
//            }
//        } target:self btnCount:2];
//    } else if ([button.titleLabel.text isEqualToString:@"+关注"]) { //加关注
//        //取消关注
//        if (button.tag < followList.count) {
//            //NSDictionary *infoDict = (NSDictionary *)[[GetFollowList shareInstance].info objectAtIndexCheck:button.tag];
//            NSDictionary *infoDict = [followList objectAtIndexCheck:button.tag];
//            GetFollowListInfo *listInfo = [[GetFollowListInfo alloc] initWithDict:infoDict];
//            [UpdateFollwInput shareInstance].userId = listInfo.userId;
//            [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
//            [UpdateFollwInput shareInstance].flag = @"0";   //加关注
//            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
//            //调用接口
//            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
//                BaseModel *returnData = [BaseModel modelWithDict:responseDict];
//                if (RETURN_SUCCESS(returnData.status)) {
//                    //[followList removeAllObjects];
//                    //[self reloadData:1 block:^(GetFollowList *followInfo) {
//                    //}];
//                    NSDictionary *infoDictCopy = [followListCopy objectAtIndex:button.tag];
//                    GetFollowListInfo *listInfoCopy = [[GetFollowListInfo alloc] initWithDict:infoDictCopy];
//                    if ([listInfoCopy.relation isEqualToString:@"2"]) {
//                        listInfo.relation = @"2";
//                    } else {
//                        listInfo.relation = @"1";
//                    }
//                    [followList setObject:[CustomUtil modelToDictionary:listInfo] atIndexedSubscript:button.tag];
//                    UITableViewCell *cell = (UITableViewCell *)(button.superview.superview);
//                    NSIndexPath *indexPath = [_concernManTableView indexPathForCell:cell];
//                    if ([listInfo.relation isEqualToString:@"1"]) {
//                        if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableViewCell class]]) {
//                            ConcernManTableViewCell *tableViewCell = (ConcernManTableViewCell *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                            [tableViewCell.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn02_10"] forState:UIControlStateNormal];
//                            [tableViewCell.alreadyConcernBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
//                            [tableViewCell.alreadyConcernBtn setTitle:@"已关注" forState:UIControlStateNormal];
//                        } else if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableCellOne class]]) {
//                            ConcernManTableCellOne *tableViewCellOne = (ConcernManTableCellOne *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                            [tableViewCellOne.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn02_10"] forState:UIControlStateNormal];
//                            [tableViewCellOne.alreadyConcernBtn setTitleColor:[UIColor colorWithRed:198/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
//                            [tableViewCellOne.alreadyConcernBtn setTitle:@"已关注" forState:UIControlStateNormal];
//                        }
//                    } else if ([listInfo.relation isEqualToString:@"2"]) {
//                        if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableViewCell class]]) {
//                            ConcernManTableViewCell *tableViewCell = (ConcernManTableViewCell *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                            [tableViewCell.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn_10"] forState:UIControlStateNormal];
//                            [tableViewCell.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                            [tableViewCell.alreadyConcernBtn setTitle:@"互为关注" forState:UIControlStateNormal];
//                        } else if ([[_concernManTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ConcernManTableCellOne class]]) {
//                            ConcernManTableCellOne *tableViewCellOne = (ConcernManTableCellOne *)[_concernManTableView cellForRowAtIndexPath:indexPath];
//                            [tableViewCellOne.alreadyConcernBtn setBackgroundImage:[UIImage imageNamed:@"btn_10"] forState:UIControlStateNormal];
//                            [tableViewCellOne.alreadyConcernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                            [tableViewCellOne.alreadyConcernBtn setTitle:@"互为关注" forState:UIControlStateNormal];
//                        }
//                    }
//                }
//                [CustomUtil showToastWithText:returnData.msg view:kWindow];
//            } failedBlock:^(NSError *err) {
//            }];
//        }
//    }
}

#pragma mark -共通方法
//加载数据
-(void)reloadData:(int)current block:(void(^)(GetFollowList *followInfo))block
{
    [GetFollowListInput shareInstance].pagesize = LINES_PERPAGE;
    [GetFollowListInput shareInstance].current = [NSString stringWithFormat:@"%d", current]; //当前页码从1开始
    [GetFollowListInput shareInstance].userId = _userId;
    [GetFollowListInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetFollowListInput shareInstance]];
    //加载数据
    [[NetInterface shareInstance] getFollowList:@"getFollowList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetFollowList *getFollowList = [GetFollowList modelWithDict:responseDict];
        if (RETURN_SUCCESS(getFollowList.status)) {
            for (int i=0; i<getFollowList.info.count; i++) {
                [followList addObject:getFollowList.info[i]];
            }
            followListCopy = [[NSMutableArray alloc] initWithArray:followList];
            [_concernManTableView reloadData];
        } else {
            [CustomUtil showToastWithText:getFollowList.msg view:self.view];
        }
        block(getFollowList);
    } failedBlock:^(NSError *err) {
    }];
}

@end
