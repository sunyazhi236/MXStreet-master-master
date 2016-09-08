//
//  NoticeViewController.m
//  mxj
//  P8-2通知实现文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableCell.h"

@interface NoticeViewController ()
{
    NSMutableArray *data; //数据
    int currentPageNum;   //当前页号
    NoticeTableCell *noticeCell;
}
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"通知"];
    UIBarButtonItem *clearBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnClick)];
    [clearBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = clearBarButtonItem;
    self.noticeTableView.delegate = self;
    self.noticeTableView.dataSource = self;
#ifdef OPEN_NET_INTERFACE
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1;
    [self reloadData:currentPageNum block:^{
    }];
#endif
    
    //添加上拉加载更多
    __weak NoticeViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_noticeTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.noticeTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_noticeTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.noticeTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //刷新列表
    [_noticeTableView triggerPullToRefresh];
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
    return 4;
#endif
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetNoticeListInfo *info = [[GetNoticeListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@", info.noticeTitle, info.noticeContent];
    if (!noticeCell) {
        noticeCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeTableCell" owner:self options:nil] lastObject];
    }
    float height = [self heightForString:contentStr fontSize:14.0f andWidth:noticeCell.noticeTitleAndContext.frame.size.width];
    return noticeCell.noticeTitleAndContext.frame.origin.y + height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableCell *noticeTableCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableCell"];
    if (!noticeTableCell) {
        noticeTableCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeTableCell" owner:self options:nil] lastObject];
    }
#ifdef OPEN_NET_INTERFACE
    GetNoticeListInfo *info = [[GetNoticeListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    //设置通知文本的位置
    NSString *contentStr = [NSString stringWithFormat:@"%@%@", info.noticeTitle, info.noticeContent];
    if (!noticeCell) {
        noticeCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeTableCell" owner:self options:nil] lastObject];
    }
    float height = [self heightForString:contentStr fontSize:14.0f andWidth:noticeCell.noticeTitleAndContext.frame.size.width];
    CGRect textFrame = noticeTableCell.noticeTitleAndContext.frame;
    textFrame.size.height = height;
    noticeTableCell.noticeTitleAndContext.frame = textFrame;
    CGRect lineFrame = noticeTableCell.lineImageView.frame;
    lineFrame.origin.y = noticeTableCell.frame.size.height - 1;
    noticeTableCell.lineImageView.frame = lineFrame;
    noticeTableCell.noticeTitleAndContext.text = [NSString stringWithFormat:@"%@:%@", info.noticeTitle, info.noticeContent];
    noticeTableCell.publishTimeLabel.text = info.publishTime;
#endif
    if ((data.count - 1) == indexPath.row) {
        //隐藏下方的下划线
        [noticeTableCell.lineImageView setHidden:YES];
    } else {
        [noticeTableCell.lineImageView setHidden:NO];
    }
    
    if ([info.status isEqualToString:@"0"]) { //未读
        [noticeTableCell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0 blue:0 alpha:0.1f]];
    } else {
        [noticeTableCell setBackgroundColor:[UIColor whiteColor]];
    }
    
    return noticeTableCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}
#pragma mark -按钮点击事件处理
//右上角清空按钮点击事件
-(void)clearBtnClick
{
    [data removeAllObjects];
    [_noticeTableView reloadData];
    //调用清空通知接口
    [DeleteNoticeInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[DeleteNoticeInput shareInstance]];
    [[NetInterface shareInstance] deleteNotice:@"deleteNotice" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -共通方法
//获取数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetNoticeListInput shareInstance].pagesize = @"10";
    [GetNoticeListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetNoticeListInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetNoticeListInput shareInstance]];
    [[NetInterface shareInstance] getNoticeList:@"getNoticeList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetNoticeList *infoListData = [GetNoticeList modelWithDict:responseDict];
        if (RETURN_SUCCESS(infoListData.status)) {
            for (int i=0; i<infoListData.info.count; i++) {
                [data addObject:infoListData.info[i]];
            }
            [_noticeTableView reloadData];
        } else {
            [CustomUtil showToastWithText:infoListData.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];
}

//获取文字高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return deSize.height;
}

@end
