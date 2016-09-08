//
//  LabelPhotoViewController.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/26.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LabelPhotoViewController.h"
#import "StreetPhotoDetailViewController.h"

#define HEADVIEWHEIGH 55

#define BTNHEIGH (SCREENWIDTH - 20)/3

@interface LabelPhotoViewController() <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
    
    NSMutableDictionary *dic;
    
    GetUserInfo *userInfo;
}

@end

@implementation LabelPhotoViewController

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
    
    self.title = @"照片";
    
    dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.view.backgroundColor = RGB(236, 236, 236, 1);
    
    self.view.frame = CGRectMake(0, 5, SCREENWIDTH, MainViewHeight- 5);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(236, 236, 236, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    [self.view addSubview:self.tableView];
    
    data = [[NSMutableArray alloc] init];
    currentPageNum = 0; //默认页码从1开始
    
    //添加上拉加载更多
    __weak LabelPhotoViewController *blockSelf = self;
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
                
                blockSelf.tableView.contentSize = CGSizeMake(SCREENWIDTH, MainViewHeight- 5);
                
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
    //获取街拍列表
    [GetStreetsnapListInput shareInstance].pagesize = @"15";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    [GetStreetsnapListInput shareInstance].userId = self.userId;
    [GetStreetsnapListInput shareInstance].type = @"0";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapList:@"getStreetsnapList" param:dict successBlock:^(NSDictionary *responseDict) {
        block();
        
        GetStreetsnapList *returnData = [GetStreetsnapList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
//            [data addObject:returnData.info];
            for (int i=0; i<[returnData.info count]; i++) {
                NSDictionary *dataD = [returnData.info objectAtIndexCheck:i];
                if (dataD) {
                    Info *imageInfo = [[Info alloc] initWithDictionary:dataD];
                    [data addObject:imageInfo];
                }
            }
            [_tableView reloadData];
        } else {
//            [CustomUtil showToastWithText:returnData.msg view:kWindow];
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
    return (int)ceil(data.count/3.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return BTNHEIGH + 5;
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
    
//    if (data.count > 0 ) {
//        int row = (int)indexPath.row + 1;
//        if (row * 3 < [data count]) {
//            for (int i = row * 3; i < [data count]; i ++ ) {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                button.tag = indexPath.row * 1000 + 1;
//                button.frame = CGRectMake(0, 10, BTNHEIGH, BTNHEIGH);
//                Info *info = [data objectAtIndex:row * 3 - 3];
//                EGOImageView *buttonImg = [[EGOImageView alloc] init];
//                buttonImg.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                buttonImg.userInteractionEnabled = YES;
//                buttonImg.imageURL = [CustomUtil getPhotoURL:info.photo1];
//                buttonImg.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                [CustomUtil setImageViewCorner:buttonImg];
//                [button addSubview:buttonImg];
//                [button addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:button];
//                
//                UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//                button1.tag = indexPath.row * 1000 + 2;
//                button1.frame = CGRectMake(BTNHEIGH + 10, 10, BTNHEIGH, BTNHEIGH);
//                Info *info1 = [data objectAtIndex:(int)row * 3 - 2];
//                EGOImageView *buttonImg1 = [[EGOImageView alloc] init];
//                buttonImg1.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                buttonImg1.userInteractionEnabled = YES;
//                buttonImg1.imageURL = [CustomUtil getPhotoURL:info1.photo1];
//                buttonImg1.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                [CustomUtil setImageViewCorner:buttonImg1];
//                [button1 addSubview:buttonImg1];
//                [button1 addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:button1];
//                
//                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//                button2.tag = indexPath.row * 1000 + 3;
//                button2.frame = CGRectMake(BTNHEIGH * 2 + 20, 10, BTNHEIGH, BTNHEIGH);
//                Info *info2 = [data objectAtIndex:row * 3 - 1];
//                EGOImageView *buttonImg2 = [[EGOImageView alloc] init];
//                buttonImg2.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                buttonImg2.userInteractionEnabled = YES;
//                buttonImg2.imageURL = [CustomUtil getPhotoURL:info2.photo1];
//                buttonImg2.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                [CustomUtil setImageViewCorner:buttonImg2];
//                [button2 addSubview:buttonImg2];
//                [button2 addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:button2];
//            }
//        }
//        else {
//            for (int i = 0; i < [data count] % 3; i++) {
//                if ([data count] % 3 == 1) {
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.tag = indexPath.row * 1000 + 1;
//                    button.frame = CGRectMake(0, 10, BTNHEIGH, BTNHEIGH);
//                    Info *info;
//                    if (data.count == 1) {
//                        info = [data objectAtIndex:0];
//                    }
//                    else{
//                        info = [data objectAtIndex:row * 3 - 3];
//                    }
//                    EGOImageView *buttonImg = [[EGOImageView alloc] init];
//                    buttonImg.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                    buttonImg.userInteractionEnabled = YES;
//                    buttonImg.imageURL = [CustomUtil getPhotoURL:info.photo1];
//                    buttonImg.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                    [CustomUtil setImageViewCorner:buttonImg];
//                    [button addSubview:buttonImg];
//                    [button addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.contentView addSubview:button];
//                }
//                if ([data count] % 3 == 2) {
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.tag = indexPath.row * 1000 + 1;
//                    button.frame = CGRectMake(0, 10, BTNHEIGH, BTNHEIGH);
//                    Info *info;
//                    if (data.count == 2) {
//                        info = [data objectAtIndex:0];
//                    }
//                    else{
//                        info = [data objectAtIndex:row * 3 - 3];
//                    }
//                    EGOImageView *buttonImg = [[EGOImageView alloc] init];
//                    buttonImg.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                    buttonImg.userInteractionEnabled = YES;
//                    buttonImg.imageURL = [CustomUtil getPhotoURL:info.photo1];
//                    buttonImg.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                    [CustomUtil setImageViewCorner:buttonImg];
//                    [button addSubview:buttonImg];
//                    [button addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.contentView addSubview:button];
//                    
//                    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button1.tag = indexPath.row * 1000 + 2;
//                    button1.frame = CGRectMake(BTNHEIGH + 10, 10, BTNHEIGH, BTNHEIGH);
//                    Info *info1;
//                    if (data.count == 2) {
//                        info1 = [data objectAtIndex:0];
//                    }
//                    else{
//                        info1 = [data objectAtIndex:row * 3 - 2];
//                    }
//                    EGOImageView *buttonImg1 = [[EGOImageView alloc] init];
//                    buttonImg1.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
//                    buttonImg1.userInteractionEnabled = YES;
//                    buttonImg1.imageURL = [CustomUtil getPhotoURL:info1.photo1];
//                    buttonImg1.frame = CGRectMake(0, 0, BTNHEIGH, BTNHEIGH);
//                    [CustomUtil setImageViewCorner:buttonImg1];
//                    [button1 addSubview:buttonImg1];
//                    [button1 addTarget:self action:@selector(buttonClick:Info:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.contentView addSubview:button1];
//                }
//            }
//        }
//    }
    
    CGFloat offset_x = 5;
    
    CGFloat offset_y = 5;
    
    CGFloat width = (SCREENWIDTH - 4 * offset_x) / 3;
    
    CGFloat height = width;
    int rank = 0;
    for (int i = (int)indexPath.row * 3; i < [data count]; i ++ ) {
        if (rank < 3) {
            Info *info = [data objectAtIndex:i];
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offset_x + (offset_x + width) * (int)(i % 3), offset_y, width, height)];
            backView.backgroundColor = [UIColor whiteColor];
            backView.clipsToBounds = YES;
            backView.userInteractionEnabled = YES;
            [cell.contentView addSubview:backView];
            
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            //        if (![imageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:info.photo1].absoluteString]) {
            imageView.placeholderImage = [UIImage imageNamed:@"pic-bg7-4"];
            imageView.imageURL = [CustomUtil getPhotoURL:info.photo1];
            //        }
            
            [backView addSubview:imageView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [dic setValue:info.streetsnapId forKey:[NSString stringWithFormat:@"%d",i]];
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
    
    Info *info = [data objectAtIndexCheck:sender.tag];

    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
//    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    viewCtrl.streetsnapId = info.streetsnapId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}


@end
