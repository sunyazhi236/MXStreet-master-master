//
//  LabelUserViewController.m
//  mxj
//
//  Created by shanpengtao on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LabelUserViewController.h"
#import "MyStreetPhotoViewController.h"
#import "PersonMainPageViewController.h"
#import "MJRefresh.h"

@interface LabelUserViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
}
@end

@implementation LabelUserViewController

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
    
    self.view.backgroundColor = RGB(236, 236, 236, 1);
    
    self.view.frame = CGRectMake(0, 5, SCREENWIDTH, MainViewHeight - HEADVIEWHEIGH + 5);
    
    self.labelListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    self.labelListTableView.contentOffset = CGPointMake(0, 0);
    self.labelListTableView.delegate = self;
    self.labelListTableView.dataSource = self;
    self.labelListTableView.backgroundColor = RGB(236, 236, 236, 1);
    self.labelListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.labelListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    self.labelListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    [self.view addSubview:self.labelListTableView];

    data = [[NSMutableArray alloc] init];
    currentPageNum = 1; //默认页码从1开始
//    [self reloadData:currentPageNum block:^{
//    }];
    
    //添加上拉加载更多
    __weak LabelUserViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_labelListTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.labelListTableView.pullToRefreshView stopAnimating];
                
                blockSelf.labelListTableView.contentOffset = CGPointMake(0, 0);
                
                blockSelf.labelListTableView.contentSize = CGSizeMake(SCREENWIDTH, MainViewHeight - HEADVIEWHEIGH + 5);

            }];
        });
    }];
    
    //上拉加载更多
    [_labelListTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.labelListTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];

    //刷新数据
    [_labelListTableView triggerPullToRefresh];
}

- (void)setTagId:(NSString *)tagId
{
    _tagId = tagId;
    
    //刷新数据
//    [self reloadData:currentPageNum block:^{
//    }];
}


//刷新数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [SearchByTagInput shareInstance].pagesize = @"10";
    [SearchByTagInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [SearchByTagInput shareInstance].userId = [LoginModel shareInstance].userId;
    [SearchByTagInput shareInstance].tagId = _tagId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SearchByTagInput shareInstance]];
    [[NetInterface shareInstance] searchByTag:@"searchTagByUser" param:dict successBlock:^(NSDictionary *responseDict) {
        block();
        
        SearchByTag *returnData = [SearchByTag modelWithDict:responseDict];
        _superViewController.totalnum = returnData.totalnum;
        if (RETURN_SUCCESS(returnData.status)) {
            for (SearchByTagInfo *info in returnData.info) {
                [data addObject:info];
            }
            
            [_labelListTableView reloadData];
            
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
        block();
    }];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (int)ceil(data.count/4.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 105 + 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cellId"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = RGB(236, 236, 236, 1);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }

    CGFloat offset_x = 10;

    CGFloat offset_y = 8;
    
    CGFloat width = (SCREENWIDTH - 5 * offset_x) / 4;

    CGFloat height = 105;

    CGFloat button_top = 80;

    CGFloat head_height = 60;

    int rank = 0;

    for (int i = (int)indexPath.row * 4; i < [data count]; i ++ ) {
        if (rank < 4) {

            SearchByTagInfo *info = [[SearchByTagInfo alloc] initWithDict:[data objectAtIndexCheck:i]];
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offset_x + (offset_x + width) * (int)(i % 4), offset_y, width, height)];
            backView.layer.cornerRadius = 4;
            backView.layer.masksToBounds = YES;
            backView.backgroundColor = [UIColor whiteColor];
            backView.userInteractionEnabled = YES;
            [cell.contentView addSubview:backView];
            
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake((width - head_height)/2, (button_top - head_height) / 2, head_height, head_height)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.layer.cornerRadius = head_height / 2;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            if (![imageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:info.image].absoluteString]) {
                imageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
                imageView.imageURL = [CustomUtil getPhotoURL:info.image];
            }
            [backView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button_top, width, height - button_top)];
            label.text = info.userName;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT(11);
            label.backgroundColor = [UIColor colorWithHexString:@"ee3e2f"];
            [backView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, width, height);
            [backView addSubview:button];
            rank++;
        }
    }
    
    return cell;

}

- (void)buttonClick:(UIButton *)sender
{
    SearchByTagInfo *info = [[SearchByTagInfo alloc] initWithDict:[data objectAtIndexCheck:sender.tag]];

    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [_superViewController.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [_superViewController.navigationController pushViewController:viewCtrl animated:YES];
    }

}

@end
