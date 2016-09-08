//
//  LabelMainViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/26.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LabelMainViewController.h"
#import "LabelDetailViewController.h"

#define HEADVIEWHEIGH 55

#define CELLHEIGH 44

@interface LabelMainViewController() <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
    
    int cellidi;
}

@end

@implementation LabelMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
    
    self.view.backgroundColor = RGB(236, 236, 236, 1);
    
    self.view.frame = CGRectMake(0, 5, SCREENWIDTH, MainViewHeight - 5);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(236, 236, 236, 1);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    [self.view addSubview:self.tableView];
    
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1; //默认页码从1开始
    //    [self reloadData:currentPageNum block:^{
    //    }];
    
    //添加上拉加载更多
    __weak LabelMainViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_tableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.tableView.pullToRefreshView stopAnimating];
                
                blockSelf.tableView.contentOffset = CGPointMake(0, 0);
                
                blockSelf.tableView.contentSize = CGSizeMake(SCREENWIDTH, MainViewHeight - 5);
                
            }];
        });
    }];
    
    //上拉加载更多
    [_tableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
    
    //刷新数据
    [_tableView triggerPullToRefresh];
}

//刷新数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetPopTagListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetPopTagListInput shareInstance].pagesize = @"15";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetPopTagListInput shareInstance]];
    [dict setValue:_userId ? _userId : [LoginModel shareInstance].userId forKey:@"userId"];
    [[NetInterface shareInstance] getPopTagList:@"getMyTagList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetPopTagList *returnData = [GetPopTagList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [data addObjectsFromArray:returnData.info];
            [_tableView reloadData];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];

}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CELLHEIGH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cellId%d",(int)indexPath.row];
//    cellidi++;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [data objectAtIndexCheck:indexPath.row];
    if (!dic) {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"label7-1-1"];
    UIButton *imButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imButton.frame = CGRectMake(15, CELLHEIGH / 4, CELLHEIGH / 2, CELLHEIGH / 2);
    [imButton setImage:image forState:UIControlStateNormal];
    [imButton setImage:image forState:UIControlStateHighlighted];
    [cell.contentView addSubview:imButton];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + CELLHEIGH / 2, 0, SCREENWIDTH - (30 + CELLHEIGH / 2), CELLHEIGH)];
    label.text = [dic objectForKey:@"tagName"];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30 + CELLHEIGH / 2, 0, SCREENWIDTH - (30 + CELLHEIGH / 2), CELLHEIGH)];
//    label2.text = [dic objectForKey:@"tagName"];
//    label2.textAlignment = NSTextAlignmentLeft;
//    label2.font = [UIFont systemFontOfSize:13.0f];
//    label2.textColor = [UIColor blackColor];
//    [cell.contentView addSubview:label2];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [data objectAtIndexCheck:indexPath.row];
    if (!dic) {
        return;
    }
    
    LabelDetailViewController *viewCtrl = [[LabelDetailViewController alloc] init];
    viewCtrl.tagId = [dic objectForKey:@"tagId"];
    viewCtrl.type = 1;
    viewCtrl.userId = self.userId;
    viewCtrl.tagName = [dic objectForKey:@"tagName"];
    [self.navigationController pushViewController:viewCtrl animated:YES];

}
@end
