//
//  BlackListViewController.m
//  mxj
//  P12-7黑名单
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlackListCell.h"

@interface BlackListViewController ()
{
    NSMutableArray *blackList; //黑名单数组
    int currentPageNum;        //当前Page页号
}
@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"黑名单"];
    blackList = [[NSMutableArray alloc] init];
#ifdef OPEN_NET_INTERFACE
    currentPageNum = 1; //默认从1开始
    [self reloadData:currentPageNum block:nil];
#endif
    self.blackListTableView.delegate = self;
    self.blackListTableView.dataSource = self;
    
    //添加上拉加载更多
    __weak BlackListViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = blackList;
    //下拉刷新
    [_blackListTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.blackListTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];

    //上拉加载更多
    [_blackListTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.blackListTableView.infiniteScrollingView stopAnimating];
            }];
        });
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
    return blackList.count;
#else
    return 4;
#endif
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlackListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BlackListCell" owner:self options:nil] lastObject];
    }
#ifdef OPEN_NET_INTERFACE
    BlacklistInfo *info = [[BlacklistInfo alloc] initWithDict:[blackList objectAtIndexCheck:indexPath.row]];
    cell.userNameLabel.text = info.userName;
    cell.userId = [LoginModel shareInstance].userId;
    cell.blacklistId = info.userId;
    cell.flag = @"1";
    cell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
    cell.viewCtrl = self;
#endif
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if (_blackListTableView == tableView) {
        result = UITableViewCellEditingStyleDelete;
    }
    
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_blackListTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        //更新黑名单
        [UpdateBlacklistInput shareInstance].userId = [LoginModel shareInstance].userId;
        BlacklistInfo *info = [[BlacklistInfo alloc] initWithDict:[blackList objectAtIndexCheck:indexPath.row]];
        [UpdateBlacklistInput shareInstance].blacklistId = info.userId;
        [UpdateBlacklistInput shareInstance].flag = @"1";
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateBlacklistInput shareInstance]];
        [[NetInterface shareInstance] updateBlacklist:@"updateBlacklist" param:dict successBlock:^(NSDictionary *responseDict) {
            UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                [blackList removeAllObjects];
                [self reloadData:1 block:^{
                    currentPageNum = 1;
                }];
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        } failedBlock:^(NSError *err) {
        }];
    }
}

#ifdef OPEN_NET_INTERFACE
//重新加载数据并更新画面
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetBlacklistInput shareInstance].pagesize = @"10";
    [GetBlacklistInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetBlacklistInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetBlacklistInput shareInstance]];
    [[NetInterface shareInstance] getBlacklist:@"getBlacklist" param:dict successBlock:^(NSDictionary *responseDict) {
        GetBlacklist *returnBlackList = [GetBlacklist modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnBlackList.status)) {
            for (int i=0; i<returnBlackList.info.count; i++) {
                [blackList addObject:returnBlackList.info[i]];
            }
            [_blackListTableView reloadData];
            if (block) {
                block();
            }
        } else {
            [CustomUtil showToastWithText:returnBlackList.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}
#endif

@end
