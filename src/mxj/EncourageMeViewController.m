//
//  EncourageMeViewController.m
//  mxj
//  P8-4赞我实现文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "EncourageMeViewController.h"
#import "EncourageMeTableCell.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"
#import "StreetPhotoDetailViewController.h"

@interface EncourageMeViewController ()
{
    NSMutableArray *data; //数据
    int currentPageNum;   //当前页号
}
@end

@implementation EncourageMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"赞我"];
    self.encourageMeTableView.delegate = self;
    self.encourageMeTableView.dataSource = self;
    
#ifdef OPEN_NET_INTERFACE
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1; //默认从1开始
    [self reloadData:currentPageNum block:^{
    }];
#endif
    //添加上拉加载更多
    __weak EncourageMeViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_encourageMeTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.encourageMeTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_encourageMeTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.encourageMeTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //刷新列表
    [_encourageMeTableView triggerPullToRefresh];
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
    return data.count;
#else
    return 10;
#endif
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncourageMeTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"EncourageMeTableCell"];
    if (!tableCell) {
        tableCell = [[[NSBundle mainBundle] loadNibNamed:@"EncourageMeTableCell" owner:self options:nil] lastObject];
    }
#ifdef OPEN_NET_INTERFACE
    GetPraiseListInfo *info = [[GetPraiseListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    tableCell.userNameLabel.text = info.userName;
    tableCell.createTimeLabel.text = info.createTime;
    tableCell.personImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    tableCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
    [CustomUtil setImageViewCorner:tableCell.personImageView];
    tableCell.photo1.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    tableCell.photo1.imageURL = [CustomUtil getPhotoURL:info.photo1];
#endif
    tableCell.delegate = self;
    if ([info.status isEqualToString:@"0"]) { //未读
        [tableCell setBackgroundColor:[UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.1f]];
    } else {
        [tableCell setBackgroundColor:[UIColor whiteColor]];
    }
    
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EncourageMeTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (nil == [data objectAtIndexCheck:indexPath.row]) {
        return;
    }
    GetPraiseListInfo *info = [[GetPraiseListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    //跳转至街拍详情
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.streetsnapId = info.streetsnapId;
    [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark -按钮点击事件
//个人头像点击事件
-(void)imageViewClick:(id)sender
{
    if (0 == data.count) {
        return;
    }
    NSIndexPath *indexPath = [_encourageMeTableView indexPathForCell:(UITableViewCell *)(((UIButton *)sender).superview.superview)];
    NSDictionary *dict = [data objectAtIndexCheck:indexPath.row];
    GetPraiseListInfo *info = [[GetPraiseListInfo alloc] initWithDict:dict];
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
    } else {
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
    }
}

#pragma mark -共通方法
//加载数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetPraiseListInput shareInstance].pagesize = @"10";
    [GetPraiseListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetPraiseListInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetPraiseListInput shareInstance]];
    [[NetInterface shareInstance] getPraiseList:@"getPraiseList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetPraiseList *praiseListData = [GetPraiseList modelWithDict:responseDict];
        if (RETURN_SUCCESS(praiseListData.status)) {
            for (int i=0; i<praiseListData.info.count; i++) {
                [data addObject:praiseListData.info[i]];
            }
            [_encourageMeTableView reloadData];
        } else {
            [CustomUtil showToastWithText:praiseListData.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];
}

@end
