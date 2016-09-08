//
//  PersonMainPageViewController.m
//  mxj
//  P9-0个人主页
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PersonMainPageViewController.h"
#import "PrivateMessageViewController.h"
#import "PersonDocViewController.h"
#import "MeFansViewController.h"
#import "ConcernManViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "SendPrivateMessageViewController.h"

@interface PersonMainPageViewController ()
{
    GetUserInfo *userInfo; //用户信息
    int currentPageNum;    //当前页码
    NSMutableArray *dataArray;  //数据数组
    NSMutableArray *arrayImage; //图片数据
    
    NSMutableArray *totalDataArray; //图片数据
}
@end

@implementation PersonMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totalTableView.delegate = self;
    _totalTableView.dataSource = self;
    
    dataArray = [[NSMutableArray alloc] init];
    arrayImage = [[NSMutableArray alloc] init];
    totalDataArray = [[NSMutableArray alloc] init];
    CGRect blackListFrame = _addBlackListView.frame;
    blackListFrame.origin.y = SCREEN_HEIGHT - blackListFrame.size.height;
    _addBlackListView.frame = blackListFrame;
    [_blackNameListView addSubview:_addBlackListView];
    [self.view addSubview:_blackNameListView];
    [_blackNameListView setHidden:YES];
    [_moreBtn setEnabled:YES];
    /*
    if (![TKLoginType shareInstance].loginType) {
        [_moreBtn setEnabled:NO];
    }
     */
    
    if ([_userId isEqualToString:[LoginModel shareInstance].userId]) { //显示登录用户的个人主页
        [_guanzhuBtn setEnabled:NO];
    } else {
        [_guanzhuBtn setEnabled:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    currentPageNum = 1;
    
    [GetUserInfoInput shareInstance].userId = _userId;
    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUserInfo *returnData = [GetUserInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            userInfo = [[GetUserInfo alloc] initWithDict:responseDict];
            _personImageView.imageURL = [CustomUtil getPhotoURL:userInfo.image];
            [CustomUtil setImageViewCorner:_personImageView];
            _bannerImageView.imageURL = [CustomUtil getPhotoURL:userInfo.backgroundImage];
            _levelLabel.text = [NSString stringWithFormat:@"LV%@", userInfo.userLevel];
            _userName.text = userInfo.userName;
            [_fansBtn setTitle:[NSString stringWithFormat:@"%@ 粉丝", userInfo.fansNum] forState:UIControlStateNormal];
            [_concertBtn setTitle:[NSString stringWithFormat:@"%@ 关注", userInfo.followNum] forState:UIControlStateNormal];
            //调整用户名标签尺寸
            CGRect rect = _userName.frame;
            float userNameWidth = [CustomUtil widthForString:userInfo.userName fontSize:15.0f andHeight:21.0f];
            rect.size.width = userNameWidth;
            _userName.frame = rect;
            [_userName setCenter:CGPointMake(_personImageView.center.x, _userName.center.y)];
            //调整奖牌位置
            rect = _jiangPaiImageView.frame;
            rect.origin.x = _userName.frame.origin.x + _userName.frame.size.width + 5;
            _jiangPaiImageView.frame = rect;
            //调整达人标签位置
            rect = _daRenLabel.frame;
            rect.origin.x = _jiangPaiImageView.frame.origin.x + _jiangPaiImageView.frame.size.width + 5;
            _daRenLabel.frame = rect;
            if ([userInfo.userLevel isEqualToString:@"6"]) {
                [_jiangPaiImageView setHidden:NO];
                [_daRenLabel setHidden:NO];
                [_levelImageView setHidden:YES];
                [_levelLabel setHidden:YES];
            } else {
                [_jiangPaiImageView setHidden:YES];
                [_daRenLabel setHidden:YES];
                [_levelImageView setHidden:NO];
                [_levelLabel setHidden:NO];
            }
            if ([userInfo.country isEqualToString:@"中国"]) {
                NSString *provinceStr = userInfo.province;
                if ([provinceStr isEqualToString:@"香港特别行政区"] ||
                    [provinceStr isEqualToString:@"澳门特别行政区"] ||
                    [provinceStr isEqualToString:@"台湾"]) {
                    provinceStr = @"";
                }
                _countryLabel.text = [NSString stringWithFormat:@"%@ %@", provinceStr, userInfo.city];
            } else {
                NSString *provinceStr = userInfo.province;
                if ([provinceStr isEqualToString:@"香港特别行政区"] ||
                    [provinceStr isEqualToString:@"澳门特别行政区"] ||
                    [provinceStr isEqualToString:@"台湾"]) {
                    provinceStr = @"";
                }
                _countryLabel.text = [NSString stringWithFormat:@"%@ %@ %@", userInfo.country, provinceStr, userInfo.city];
            }
            //设置个性签名
            [_personSignLabel setText:userInfo.userSign];
            
            //设置关注按钮
            if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
                [_plusLabel setHidden:NO];
                [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
            } else if([userInfo.followFlag isEqualToString:@"1"]) { //已关注
                [_plusLabel setHidden:YES];
                [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [_guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
    
    [self reloadData:currentPageNum block:^(NSMutableArray *info) {
        NSMutableArray *data = [NSMutableArray arrayWithArray:info];
        totalDataArray = [NSMutableArray arrayWithArray:info];
        if (_waterView) {
            [_waterView removeFromSuperview];
            _waterView = nil;
        }
        [self setSelfWaterView:data];
        [_totalTableView reloadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return _cellOne;
    } else {
        if (totalDataArray.count > 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            if (_waterView.contentSize.height < _waterView.firstView.frame.size.height) {
                CGSize waterViewContentSize = _waterView.contentSize;
                waterViewContentSize.height = _waterView.frame.size.height;
                _waterView.contentSize = waterViewContentSize;
            }
            [cell.contentView addSubview:_waterView];
            return cell;
        } else {
            return _cellTwo;
        }
    }
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return _cellOne.frame.size.height;
    } else {
        if (totalDataArray.count > 0) {
            return SCREEN_HEIGHT;
        } else {
            return _cellTwo.frame.size.height;
        }
    }
    return 0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_waterView == scrollView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *array = [_totalTableView indexPathsForVisibleRows];
        BOOL isDisplay = NO;
        for (NSIndexPath *object in array) {
            if ([path isEqual:object]) {
                isDisplay = YES;
            }
        }
        
        if (NO == isDisplay) {
            if (scrollView.contentOffset.y > 0) {
                return;
            } else {
                [_totalTableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
            }
        } else {
            if ((scrollView.contentOffset.y > 0) &&
                (_totalTableView.contentOffset.y <= _cellOne.frame.size.height)) {
                if (scrollView.contentOffset.y > (_cellOne.frame.size.height - _totalTableView.contentOffset.y)) {
                    [_totalTableView setContentOffset:CGPointMake(0, _cellOne.frame.size.height) animated:NO];
                } else {
                    [_totalTableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
                }
            }
        }
        if (_totalTableView.contentOffset.y < 0) {
            [_totalTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

/*
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_waterView == scrollView) {
        if ((scrollView.contentOffset.y < 0) &&
            (_totalTableView.contentOffset.y != 0)) {
            [_totalTableView setContentOffset:CGPointZero animated:YES];
        }
    }
}
 */

#pragma mark -按钮点击事件处理
//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更多按钮点击事件
- (IBAction)moreBtnClick:(id)sender {
    [_blackNameListView setHidden:NO];
}

//私信按钮点击事件
- (IBAction)messageBtnClick:(id)sender {
//    if ([TKLoginType shareInstance].loginType) {
        //取得私信内容
        [GetMessageInput shareInstance].pagesize = @"10";
        [GetMessageInput shareInstance].current = @"1";
        [GetMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
        [GetMessageInput shareInstance].targetId = _userId;
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetMessageInput shareInstance]];
        SendPrivateMessageViewController *sendPrivateMessageViewCtrl = [[SendPrivateMessageViewController alloc] initWithNibName:@"SendPrivateMessageViewController" bundle:nil];
        sendPrivateMessageViewCtrl.dict = dict;
        sendPrivateMessageViewCtrl.userName = userInfo.userName;
        sendPrivateMessageViewCtrl.receiveId = userInfo.userId;
        [self.navigationController pushViewController:sendPrivateMessageViewCtrl animated:YES];
 //   }
}

//用户头像点击事件
- (IBAction)userImageClick:(id)sender {
  //  if ([TKLoginType shareInstance].loginType) {
        if (YES == _userPhotoView.hidden) {
            [_userPhotoView setHidden:NO];
        } else {
            CGRect rect = _userPhotoView.frame;
            rect.size.width = SCREEN_WIDTH;
            rect.size.height = SCREEN_HEIGHT;
            _userPhotoView.frame = rect;
            _bigPersonPhotoImageView.imageURL = [CustomUtil getPhotoURL:userInfo.image];
            [CustomUtil setImageViewCorner:_bigPersonPhotoImageView];
            [self.view addSubview:_userPhotoView];
        }
   // }
}

//用户大图取消按钮
- (IBAction)userPhotoCancelBtnClick:(id)sender {
    [_userPhotoView setHidden:YES];
}

//用户大图个人资料
- (IBAction)userPhotoPersonDocBtnClick:(id)sender {
    PersonDocViewController *personDocViewCtrl = [[PersonDocViewController alloc] initWithNibName:@"PersonDocViewController" bundle:nil];
    personDocViewCtrl.queryUserId = _userId;
    [self.navigationController pushViewController:personDocViewCtrl animated:YES];
}

//关注按钮点击事件
- (IBAction)guanZhuBtnClick:(id)sender {
    //if (![TKLoginType shareInstance].loginType) {
     //   return;
    //}
    
    [UpdateFollwInput shareInstance].userId = userInfo.userId;
    [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
    if ([userInfo.followFlag isEqualToString:@"0"]) { //未关注
        //加关注
        [UpdateFollwInput shareInstance].flag = @"0";
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
        [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
            UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if ([userInfo.followFlag isEqualToString:@"0"]) {
                    userInfo.followFlag = @"1";
                } else if ([userInfo.followFlag isEqualToString:@"1"]) {
                    userInfo.followFlag = @"0";
                }
                if ([userInfo.followFlag isEqualToString:@"0"]) {
                    [_plusLabel setHidden:NO];
                    [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
                    [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                } else if([userInfo.followFlag isEqualToString:@"1"]) {
                    [_plusLabel setHidden:YES];
                    [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                    [_guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        } failedBlock:^(NSError *err) {
        }];
    } else if ([userInfo.followFlag isEqualToString:@"1"]) { //已关注
        //取消关注
        [CustomUtil showCustomAlertView:nil message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
            [UpdateFollwInput shareInstance].flag = @"1";
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    if ([userInfo.followFlag isEqualToString:@"0"]) {
                        userInfo.followFlag = @"1";
                    } else if ([userInfo.followFlag isEqualToString:@"1"]) {
                        userInfo.followFlag = @"0";
                    }
                    if ([userInfo.followFlag isEqualToString:@"0"]) {
                        [_plusLabel setHidden:NO];
                        [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                        [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
                    } else if([userInfo.followFlag isEqualToString:@"1"]) {
                        [_plusLabel setHidden:YES];
                        [_guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                        [_guanzhuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                    }
                }
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            } failedBlock:^(NSError *err) {
            }];
        } target:self btnCount:2];
    }
}

//粉丝按钮点击事件
- (IBAction)fensiBtnClick:(id)sender {
    //if (![TKLoginType shareInstance].loginType) {
      //  return;
    //}
    MeFansViewController *meFansViewCtrl = [[MeFansViewController alloc] initWithNibName:@"MeFansViewController" bundle:nil];
    meFansViewCtrl.userId = userInfo.userId;
    [self.navigationController pushViewController:meFansViewCtrl animated:YES];
}

//关注按钮点击事件
- (IBAction)concertManBtnClick:(id)sender {
    //if (![TKLoginType shareInstance].loginType) {
      //  return;
    //}
    ConcernManViewController *concernManViewCtrl = [[ConcernManViewController alloc] initWithNibName:@"ConcernManViewController" bundle:nil];
    concernManViewCtrl.userId = userInfo.userId;
    [self.navigationController pushViewController:concernManViewCtrl animated:YES];
}

//取消加入黑名单按钮
- (IBAction)cancelAddBlackListBtnClick:(id)sender {
    [_blackNameListView setHidden:YES];
}

//加入黑名单按钮
- (IBAction)addBlackListBtnClick:(id)sender {
    //弹出确认对话框
    [CustomUtil showCustomAlertView:nil message:[NSString stringWithFormat:@"是否把%@加入黑名单？", _userName.text] leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        //调用接口
        [UpdateBlacklistInput shareInstance].userId = [LoginModel shareInstance].userId;
        [UpdateBlacklistInput shareInstance].blacklistId = _userId;
        [UpdateBlacklistInput shareInstance].flag = @"0"; //拉黑
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateBlacklistInput shareInstance]];
        [[NetInterface shareInstance] updateBlacklist:@"updateBlacklist" param:dict successBlock:^(NSDictionary *responseDict) {
            UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                [_moreBtn setEnabled:NO];
                [_blackNameListView setHidden:YES];
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        } failedBlock:^(NSError *err) {
        }];
    } target:self btnCount:2];
}

#pragma mark -共通方法
//设置瀑布流
-(void)setSelfWaterView:(NSMutableArray *)array
{
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dataD = [array objectAtIndexCheck:i];
        if (dataD) {
            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
            [arrayImage addObject:imageInfo];
        }
    }
    if (!_waterView) {
        self.waterView = [[ImageWaterView alloc] initWithDataArray:arrayImage withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intoFlag:0];
        if (_waterView.contentSize.height < _waterView.frame.size.height) {
            CGSize waterViewContentSize = _waterView.contentSize;
            waterViewContentSize.height = _waterView.frame.size.height;
            _waterView.contentSize = waterViewContentSize;
        }
        [self.waterView setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f]];
        self.waterView.imageViewClickDelegate = self;
        _waterView.delegate = self;
        //添加刷新
        //添加加载更多
        __weak PersonMainPageViewController *blockSelf = self;
        __weak NSMutableArray *dataArraySelf = dataArray;
        __weak NSMutableArray *arrayImageSelf = arrayImage;
        __block int currentPageNumSelf = currentPageNum;
        __weak ImageWaterView *waterViewSelf = _waterView;
        [blockSelf.waterView addPullToRefreshWithActionHandler:^{
            NSLog(@"下拉更新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                currentPageNumSelf = 1;
                [blockSelf reloadData:currentPageNumSelf block:^(NSMutableArray *info) {
                    //if ((info.count > 0) && ([((ImageInfo *)[arrayImageSelf objectAtIndexCheck:0]).thumbURL isEqualToString:[CustomUtil getPhotoURL:[[info objectAtIndexCheck:0] objectForKey:@"photo1"]].absoluteString])) {
                      //  [blockSelf.waterView.pullToRefreshView stopAnimating];
                       // return;
                    //}
                    [dataArraySelf removeAllObjects];
                    [arrayImageSelf removeAllObjects];
                    [dataArraySelf addObjectsFromArray:info];
                    for (int i=0; i<[dataArraySelf count]; i++) {
                        NSDictionary *dataD = [dataArraySelf objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [arrayImageSelf addObject:imageInfo];
                        }
                    }
                    [waterViewSelf refreshView:arrayImageSelf intoFlag:0];
                    if (waterViewSelf.contentSize.height < waterViewSelf.frame.size.height) {
                        CGSize size = waterViewSelf.contentSize;
                        size.height = waterViewSelf.frame.size.height;
                        waterViewSelf.contentSize = size;
                    }
                    [blockSelf.waterView.pullToRefreshView stopAnimating];
                }];
            });
        }];
        
        [blockSelf.waterView addInfiniteScrollingWithActionHandler:^{
            NSLog(@"上拉刷新");
            //使用GCD开启一个线程，使圈圈转2秒
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                currentPageNumSelf++;
                [blockSelf reloadData:currentPageNumSelf block:^(NSMutableArray *info) {
                    [dataArraySelf addObjectsFromArray:info];
                    NSMutableArray *imageArrayCopy = [[NSMutableArray alloc] init];
                    for (int i=0; i<[info count]; i++) {
                        NSDictionary *dataD = [info objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initWithDictionary:dataD];
                            [imageArrayCopy addObject:imageInfo];
                        }
                    }
                    [waterViewSelf loadNextPage:imageArrayCopy intoFlag:0];
                    if (waterViewSelf.contentSize.height < waterViewSelf.frame.size.height) {
                        CGSize size = waterViewSelf.contentSize;
                        size.height = waterViewSelf.frame.size.height;
                        waterViewSelf.contentSize = size;
                    }
                    [blockSelf.waterView.infiniteScrollingView stopAnimating];
                }];
            });
        }];
    }
}

-(void)reloadData:(int)currentNum block:(void(^)(NSMutableArray *info))block
{
    //设置瀑布流 调用接口获取数据
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentNum];
    [GetStreetsnapListInput shareInstance].userId = _userId;
    [GetStreetsnapListInput shareInstance].place = @"";
    [GetStreetsnapListInput shareInstance].type = @"0";
    NSMutableDictionary *dict1 = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:dict1 successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -代理方法
//图片点击事件处理
-(void)imageViewClick:(ImageInfo *)imageInfo
{
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId;
    
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
