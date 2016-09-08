//
//  CommentViewController.m
//  mxj
//  P8-1评论实现文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "PersonMainPageViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "MyStreetPhotoViewController.h"

@interface CommentViewController ()
{
    NSMutableArray *data;
    int currentPageNum;   //当前页号
    
}
@property (nonatomic, assign) BOOL isLoading;   //正在loading

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationItem setTitle:@"评论"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    currentPageNum = 1; //默认从1开始
//#ifdef OPEN_NET_INTERFACE
    data = [[NSMutableArray alloc] init];
//    [self reloadData:currentPageNum block:^{
//    }];
//#endif
    //添加上拉加载更多
    __weak CommentViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_commentTableView addPullToRefreshWithActionHandler:^{
        if (blockSelf.isLoading) {
            [blockSelf.commentTableView.pullToRefreshView stopAnimating];
            return;
        }
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.commentTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_commentTableView addInfiniteScrollingWithActionHandler:^{
        if (blockSelf.isLoading) {
            [blockSelf.commentTableView.infiniteScrollingView stopAnimating];
            return;
        }
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.commentTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //刷新列表
    [_commentTableView triggerPullToRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return 20;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (!tableCell) {
        tableCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] lastObject];
    }
#ifdef OPEN_NET_INTERFACE
    GetCommentListInfo *commentListInfo = [[GetCommentListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    tableCell.userNameLabel.text = commentListInfo.userName;
    tableCell.commentTimeLabel.text = commentListInfo.commentTime;
    tableCell.commentContextLabel.text = commentListInfo.commentContent;
    tableCell.photo1.imageURL = [CustomUtil getPhotoURL:commentListInfo.photo1];
    tableCell.photo1.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    tableCell.personImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    tableCell.personImageView.imageURL = [CustomUtil getPhotoURL:commentListInfo.image];
    [CustomUtil setImageViewCorner:tableCell.personImageView];
#endif
    if ([commentListInfo.status isEqualToString:@"0"]) { //未读
        [tableCell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0 blue:0 alpha:0.1f]];
    } else {
        [tableCell setBackgroundColor:[UIColor whiteColor]];
    }
    tableCell.delegate = self;
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (nil == [data objectAtIndexCheck:indexPath.row]) {
        return;
    }

    CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    //进入街拍详情
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    GetCommentListInfo *commentListInfo = [[GetCommentListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    viewCtrl.streetsnapId = commentListInfo.streetsnapId;
    [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark -按钮点击事件
//cell上用户头像按钮点击事件
-(void)imageViewClick:(id)sender
{
    if (0 == data.count) {
        return;
    }
    NSIndexPath *indexPath = [_commentTableView indexPathForCell:(UITableViewCell *)(((EGOImageView *)sender).superview.superview)];
    NSDictionary *dict = [data objectAtIndexCheck:indexPath.row];
    GetCommentListInfo *info = [[GetCommentListInfo alloc] initWithDict:dict];
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
-(void)reloadData:(int)pageNum block:(void(^)())block
{
    _isLoading = YES;
    
    [GetCommentListInput shareInstance].pagesize = @"10";
    [GetCommentListInput shareInstance].current = [NSString stringWithFormat:@"%d", pageNum];
    [GetCommentListInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetCommentListInput shareInstance]];
    [[NetInterface shareInstance] getCommentList:@"getCommentList" param:dict successBlock:^(NSDictionary *responseDict) {
        if (pageNum==1) {
            [data removeAllObjects];
        }
        _isLoading = NO;
        GetCommentList *commentListData = [GetCommentList modelWithDict:responseDict];
        if (RETURN_SUCCESS(commentListData.status)) {
            for (int i=0; i<commentListData.info.count; i++) {
                [data addObject:commentListData.info[i]];
            }
            [_commentTableView reloadData];
        } else {
            [CustomUtil showToastWithText:commentListData.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];
}

@end
