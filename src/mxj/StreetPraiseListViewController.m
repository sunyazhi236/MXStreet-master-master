//
//  StreetPraiseListViewController.m
//  mxj
//
//  Created by shanpengtao on 16/5/21.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "StreetPraiseListViewController.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"

#define ZANUSR_HEIGHT 32

#define CELL_HEIGHTT 54

#define CELL_LEFT 15

#define HEADVIEWHEIGH 55

@interface StreetPraiseListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *data;  //数据
    
    int currentPageNum;    //当前页号
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *streetsnapId;

@end

@implementation StreetPraiseListViewController

- (instancetype)initWithStreetsnapId:(NSString *)streetsnapId
{
    self = [super init];
    
    if (self) {
        _listArray = [[NSMutableArray alloc] initWithCapacity:0];
        
//        [self requestDataWithStreetsnapId:streetsnapId];
        
        _streetsnapId = streetsnapId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"赞过的用户";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    
    currentPageNum = 1; //默认页码从1开始
    //添加上拉加载更多
    __weak StreetPraiseListViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
//    __block NSMutableArray *dataSelf = _listArray;
    //下拉刷新
    [_tableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [dataSelf removeAllObjects];
            [blockSelf reloadData:0 block:^{
                currentPageNumSelf = 1;
                [blockSelf.tableView.pullToRefreshView stopAnimating];
                
                blockSelf.tableView.contentOffset = CGPointMake(0, 0);
                
                blockSelf.tableView.contentSize = CGSizeMake(SCREENWIDTH, MainViewHeight - HEADVIEWHEIGH + 5);
                
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
            [blockSelf reloadData2:currentPageNumSelf block:^{
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
    
    //刷新数据
    [_tableView triggerPullToRefresh];
}
//刷新数据 下拉刷新
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetStreetsnapDetailInput shareInstance].streetsnapId = _streetsnapId;
    [GetStreetsnapDetailInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
    [dict setValue:[NSString stringWithFormat:@"%d",current] forKey:@"index"];
    [dict setValue:@20 forKey:@"pageSize"];
    [CustomUtil showLoading:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getPraiseList" param:dict successBlock:^(NSDictionary *responseDict) {
        block();
        NSLog(@"responseDict:%@",responseDict);
        [_listArray removeAllObjects];
        if ([responseDict objectForKey:@"list"] && [[[responseDict objectForKey:@"list"] objectForKey:@"info"] count] > 0) {
            for (NSDictionary *dict in [[responseDict objectForKey:@"list"] objectForKey:@"info"]) {
                PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
                [_listArray addObject:info];
            }
            [_tableView reloadData];
        }
        else {
            //            [CustomUtil showToast:@"获取失败" view:self.view];
        }
    } failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"获取失败" view:self.view];
        block();
    }];
}

//刷新数据 上拉加载
-(void)reloadData2:(int)current block:(void(^)())block
{
    [GetStreetsnapDetailInput shareInstance].streetsnapId = _streetsnapId;
    [GetStreetsnapDetailInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
    [dict setValue:[NSString stringWithFormat:@"%d",current] forKey:@"index"];
    [dict setValue:@20 forKey:@"pageSize"];
    
    [CustomUtil showLoading:@""];
    
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getPraiseList" param:dict successBlock:^(NSDictionary *responseDict) {
        block();
        NSLog(@"responseDict:%@",responseDict);
        if ([responseDict objectForKey:@"list"] && [[[responseDict objectForKey:@"list"] objectForKey:@"info"] count] > 0) {
            for (NSDictionary *dict in [[responseDict objectForKey:@"list"] objectForKey:@"info"]) {
                PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
                [_listArray addObject:info];
            }
            [_tableView reloadData];
        }
        else {
//            [CustomUtil showToast:@"获取失败" view:self.view];
        }
    } failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"获取失败" view:self.view];
        block();
    }];
}

- (void)requestDataWithStreetsnapId:(NSString *)streetsnapId
{
    [GetStreetsnapDetailInput shareInstance].streetsnapId = streetsnapId;
    [GetStreetsnapDetailInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
    [dict setValue:@0 forKey:@"index"];
    [dict setValue:@999 forKey:@"pageSize"];
    
    [CustomUtil showLoading:@""];
  
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getPraiseList" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"responseDict:%@",responseDict);
        if ([responseDict objectForKey:@"list"] && [[[responseDict objectForKey:@"list"] objectForKey:@"info"] count] > 0) {
            
            [_listArray removeAllObjects];
            
            for (NSDictionary *dict in [[responseDict objectForKey:@"list"] objectForKey:@"info"]) {
                PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
                [_listArray addObject:info];
            }
            [_tableView reloadData];
        }
        else {
            [CustomUtil showToast:@"获取失败" view:self.view];
        }
    } failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"获取失败" view:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHTT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cellId%ld", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    PraiseInfo *info = _listArray[indexPath.row];
    
    EGOImageView *zanUserImageView = [[EGOImageView alloc] init];
    zanUserImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    zanUserImageView.userInteractionEnabled = YES;
    zanUserImageView.imageURL = [CustomUtil getPhotoURL:info.image];
    zanUserImageView.frame = CGRectMake(CELL_LEFT, (CELL_HEIGHTT - ZANUSR_HEIGHT) / 2, ZANUSR_HEIGHT, ZANUSR_HEIGHT);
    [CustomUtil setImageViewCorner:zanUserImageView];
    [cell.contentView addSubview:zanUserImageView];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, ZANUSR_HEIGHT, ZANUSR_HEIGHT);
    button2.tag = indexPath.row + 100;
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [zanUserImageView addSubview:button2];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image;
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
        button.hidden = YES;
    }
    else {
        button.hidden = NO;
    }
    switch ([info.followFlag integerValue]) {
        case 0:
            image = [UIImage imageNamed:[NSString stringWithFormat:@"加关注"]];
            break;
        case 1:
            image = [UIImage imageNamed:[NSString stringWithFormat:@"已经关注"]];
            break;
        case 2:
            image = [UIImage imageNamed:[NSString stringWithFormat:@"相互关注"]];
            break;
        default:
            break;
    }
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
        [button setHidden:YES];
    } else {
        [button setHidden:NO];
    }

    button.frame = CGRectMake(SCREENWIDTH - 12 - image.size.width, 0, image.size.width, CELL_HEIGHTT);
    [button setImage:image forState:UIControlStateNormal];
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ZANUSR_HEIGHT + 2 * CELL_LEFT, 8, GetX(button) - ZANUSR_HEIGHT - 2 * CELL_LEFT, 20)];
    label.text = info.userName;
    label.font = FONT(14);
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ZANUSR_HEIGHT + 2 * CELL_LEFT, GetY(label) + GetHeight(label), GetWidth(label), 20)];
    label2.text = info.USER_SIGN;
    label2.font = FONT(12);
    label2.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    [cell.contentView addSubview:label2];
    
    
    cell.detailTextLabel.text = info.userName;
    
    return cell;
}

//关注
- (void)notice:(UIButton *)button
{
    PraiseInfo *info = _listArray[button.tag];
    if (info) {
        
        if ([info.followFlag integerValue] == 0) {
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
                    
                    if ([info.followFlag integerValue] == 2) {
                        info.followFlag = @2;
                    } else {
                        info.followFlag = @1;
                    }
                    [_tableView reloadData];
                }
                
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            } failedBlock:^(NSError *err) {
                //                    [CustomUtil showToastWithText:@"网络有问题，请稍后重试！" view:kWindow];
            }];
        }
        else {
            // 已关注
            // 相互关注
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
                        
                        info.followFlag = @0;
                        
                        [_tableView reloadData];
                    }
                    
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                } failedBlock:^(NSError *err) {
                }];
            } target:self btnCount:2];
            
        }
    }
}


- (void)buttonClick:(UIButton *)button
{
    RewardInfo *info = _listArray[button.tag - 100];
    
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
    
}

@end
