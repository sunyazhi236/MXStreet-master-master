//
//  LabelListViewController.m
//  mxj
//  P7-1-2标签列表页
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "LabelListViewController.h"
#import "LabelListTableCell.h"
#import "StreetPhotoDetailViewController.h"
#import "ImageWaterView.h"

@interface LabelListViewController () <imageViewClickDelegate>
{
    NSMutableArray *data;  //数据
//    NSString *totalnum;    //街拍总数
//    NSString *totalUser;   //标签使用用户数
    
    int currentPageNum;    //当前页号
    
    BOOL isLoading;
}

@property (nonatomic, strong) ImageWaterView *waterView;               //瀑布流视图

@end

@implementation LabelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 10, SCREEN_WIDTH, MainViewHeight - HEADVIEWHEIGH - 10);
    if (_type == 1) {
        self.view.frame = CGRectMake(0, 10, SCREEN_WIDTH, MainViewHeight - 10);
    }
    
    self.view.backgroundColor = RGB(236, 236, 236, 1);
    
    self.labelListTableView.delegate = self;
    self.labelListTableView.dataSource = self;
    self.labelListTableView.backgroundColor = RGB(236, 236, 236, 1);
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1; //默认页码从1开始
    //[self reloadData:currentPageNum block:^{
    //}];
    
    __weak LabelListViewController *blockSelf = self;
    
    //添加上拉加载更多
    __block NSMutableArray *dataSelf = data;
    
    //使用GCD开启一个线程，使圈圈转2秒
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [blockSelf reloadData:1 block:^(NSMutableArray *array) {
            
            if (!array) {
                return;
            }
            
            [dataSelf removeAllObjects];
            
            for (int i=0; i<[array count]; i++) {
                NSDictionary *dataD = [array objectAtIndexCheck:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc] initLabelImageWithDictionary:dataD];
                    [dataSelf addObject:imageInfo];
                }
            }
            if (_waterView) {
                [_waterView removeFromSuperview];
                _waterView = nil;
            }
            
            [blockSelf setSelfWaterView];
            
            [blockSelf.labelListTableView reloadData];
        }];
        
    });
    
//    //添加上拉加载更多
//    __weak LabelListViewController *blockSelf = self;
//    __block int currentPageNumSelf = currentPageNum;
//    __block NSMutableArray *dataSelf = data;
//    //下拉刷新
//    [_labelListTableView addPullToRefreshWithActionHandler:^{
//        //使用GCD开启一个线程，使圈圈转2秒
//        int64_t delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [dataSelf removeAllObjects];
//            [blockSelf reloadData:1 block:^{
//                currentPageNumSelf = 1;
//                [blockSelf.labelListTableView.pullToRefreshView stopAnimating];
//            }];
//        });
//    }];
//    
//    //上拉加载更多
//    [_labelListTableView addInfiniteScrollingWithActionHandler:^{
//        //使用GCD开启一个线程，使圈圈转2秒
//        int64_t delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            currentPageNumSelf++;
//            [blockSelf reloadData:currentPageNumSelf block:^{
//                [blockSelf.labelListTableView.infiniteScrollingView stopAnimating];
//            }];
//        });
//    }];
//    
//    //刷新数据
//    [_labelListTableView triggerPullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelfWaterView
{
    if (!_waterView) {
        
        CGFloat heigth = MainViewHeight - HEADVIEWHEIGH - 10;
        if (_type == 1) {
            heigth = MainViewHeight - 10;
        }
        
        self.waterView = [[ImageWaterView alloc] initWithDataArray:data withFrame:CGRectMake(0, 10, SCREEN_WIDTH, heigth) intoFlag:0];
        if (_waterView.contentSize.height < _waterView.frame.size.height) {
            CGSize waterViewContentSize = _waterView.contentSize;
            waterViewContentSize.height = _waterView.frame.size.height;
            _waterView.contentSize = waterViewContentSize;
        }
        [self.waterView setBackgroundColor:RGB(236, 236, 236, 1)];
        self.waterView.imageViewClickDelegate = self;
        _waterView.delegate = self;
        
        _waterView.delegate = self;
        //添加刷新
        //添加加载更多
        __weak LabelListViewController *blockSelf = self;
        __weak NSMutableArray *dataArraySelf = data;
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
                    
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    [array addObjectsFromArray:info];
                    for (int i=0; i<[array count]; i++) {
                        NSDictionary *dataD = [array objectAtIndexCheck:i];
                        if (dataD) {
                            ImageInfo *imageInfo = [[ImageInfo alloc] initLabelImageWithDictionary:dataD];
                            [dataArraySelf addObject:imageInfo];
                        }
                    }
                    [waterViewSelf refreshView:dataArraySelf intoFlag:0];
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
                            ImageInfo *imageInfo = [[ImageInfo alloc] initLabelImageWithDictionary:dataD];
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

//加载数据
-(void)reloadData:(int)current block:(void(^)(NSMutableArray *array))block
{
    if (isLoading) {
        block(nil);
        return;
    }
    
    isLoading = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSString *interface = @"getMyStreetsnapListForTagId";
    [dict setValue:@"10" forKey:@"pagesize"];
    [dict setValue:[NSString stringWithFormat:@"%d", current] forKey:@"current"];
    [dict setValue:_tagId forKey:@"tagId"];
    
    if (_type == 0) {
        
//        [SearchByTagInput shareInstance].userId = [LoginModel shareInstance].userId;
//        [SearchByTagInput shareInstance].userId = nil;
    }
    else {

        [dict setValue:_userId forKey:@"userId"];

//        [SearchByTagInput shareInstance].userId = _userId;
    }

//    dict = [CustomUtil modelToDictionary:[SearchByTagInput shareInstance]];

    [[NetInterface shareInstance] searchByTag:interface param:dict successBlock:^(NSDictionary *responseDict) {
        isLoading = NO;
        
        SearchByTag *returnData = [SearchByTag modelWithDict:responseDict];
        _superViewController.totalnum = returnData.totalnum;
        if (RETURN_SUCCESS(returnData.status)) {
            block(returnData.info);
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
        
    } failedBlock:^(NSError *err) {
        isLoading = NO;
        
        block(nil);
    }];
}

////刷新数据
//-(void)reloadData:(int)current block:(void(^)())block
//{
//    NSMutableDictionary *dict;
//    
//    NSString *interface = @"";
//
//    [SearchByTagInput shareInstance].pagesize = @"10";
//    [SearchByTagInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
//    [SearchByTagInput shareInstance].tagId = _tagId;
//
//    if (_type == 0) {
//        
//        interface = @"searchByTag";
//        [SearchByTagInput shareInstance].userId = [LoginModel shareInstance].userId;
//
//        dict = [CustomUtil modelToDictionary:[SearchByTagInput shareInstance]];
//
//    }
//    else {
//        interface = @"getMyStreetsnapListForTagId";
//        
//        [SearchByTagInput shareInstance].userId = _userId;
//
//        dict = [CustomUtil modelToDictionary:[SearchByTagInput shareInstance]];
//    }
//
//    [[NetInterface shareInstance] searchByTag:interface param:dict successBlock:^(NSDictionary *responseDict) {
//
//        SearchByTag *returnData = [SearchByTag modelWithDict:responseDict];
//        _superViewController.totalnum = returnData.totalnum;
//        if (RETURN_SUCCESS(returnData.status)) {
//            for (SearchByTagInfo *info in returnData.info) {
//                [data addObject:info];
//            }
//            
//            [_labelListTableView reloadData];
//
//        } else {
//            [CustomUtil showToastWithText:returnData.msg view:kWindow];
//        }
//
//        block();
//    } failedBlock:^(NSError *err) {
//        block();
//    }];
//}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;// (int)ceil(data.count/2.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        return MainViewHeight - 10;
    }
    return MainViewHeight - HEADVIEWHEIGH - 10;
    
//    switch (indexPath.row) {
//        case 0:
////            return 50;
////            break;
////        case 1:
//            return 185;
//            break;
//        default:
//            break;
//    }
//    return 180;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = MainViewHeight - HEADVIEWHEIGH - 10;
    if (_type == 1) {
        heigth = MainViewHeight - 10;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, heigth)];
    cell.backgroundColor = RGB(236, 236, 236, 1);
    
    if (_waterView.contentSize.height < _waterView.firstView.frame.size.height) {
        CGSize waterViewContentSize = _waterView.contentSize;
        waterViewContentSize.height = _waterView.frame.size.height;
        _waterView.contentSize = waterViewContentSize;
    }
    [cell.contentView addSubview:_waterView];
    return cell;
    
    switch (indexPath.row) {
        case 0:
        {
//            [_photoNumLabel setText:totalnum];
//            [_userNumLabel setText:totalUser];
//            return self.labelListOneCell;
//        }
//            break;
//        case 1:
//        {

            self.labelListTwoCell.backgroundColor = RGB(236, 236, 236, 1);

            self.labelListTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;

            self.firstBackImageView.layer.cornerRadius = 5;
            self.secondeBackImageView.layer.cornerRadius = 5;
           
            self.firstBackImageView.clipsToBounds = YES;
            self.secondeBackImageView.clipsToBounds = YES;
            self.firstBackImageView.layer.masksToBounds = YES;
            self.secondeBackImageView.layer.masksToBounds = YES;
            
            UIGestureRecognizer *firstTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            UIGestureRecognizer *secondeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [self.firstImageView addGestureRecognizer:firstTapGesture];
            [self.secondeImageView addGestureRecognizer:secondeTapGesture];
            
            SearchByTagInfo *info = [[SearchByTagInfo alloc] initWithDict:[data objectAtIndexCheck:0]];
            if (![_firstImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:info.photo1].absoluteString]) {
                _firstImageView.imageURL = [CustomUtil getPhotoURL:info.photo1];
            }
            if (![[_firstPersonImageView.imageURL absoluteString] isEqualToString:[CustomUtil getPhotoURL:info.image].absoluteString]) {
                _firstPersonImageView.imageURL = [CustomUtil getPhotoURL:info.image];
            }
            [CustomUtil setImageViewCorner:_firstPersonImageView];
            [_firstZanImageView setImage:[UIImage imageNamed:@"shade7-1-2"]];
            if ([info.status isEqualToString:@"1"]) { //已赞
                [_firstZanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
            } else if ([info.status isEqualToString:@"0"]) { //未赞
                [_firstZanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-1-2"] forState:UIControlStateNormal];
            }
            [_firstZanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            /*
            if (![TKLoginType shareInstance].loginType) {
                [_firstZanBtn setEnabled:NO];
                [_secondeZanBtn setEnabled:NO];
            }
             */
            [_firstPersonName setText:info.userName];
            if (data.count >= 2) {
                [_secondeImageView setHidden:NO];
                [_secondeBackImageView setHidden:NO];
                
                [_secondeZanImageView setHidden:NO];
                [_secondeZanBtn setHidden:NO];
                [_secondePersonImageView setHidden:NO];
                [_secondePersonName setHidden:NO];
                info = [[SearchByTagInfo alloc] initWithDict:[data objectAtIndexCheck:1]];
                if (![[_secondeImageView.imageURL absoluteString] isEqualToString:[CustomUtil getPhotoURL:info.photo1].absoluteString]) {
                    _secondeImageView.imageURL = [CustomUtil getPhotoURL:info.photo1];
                }
                //是否已点赞
                if ([info.status isEqualToString:@"1"]) { //已赞
                    [_secondeZanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
                } else if([info.status isEqualToString:@"0"]) { //未赞
                    [_secondeZanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-1-2"] forState:UIControlStateNormal];
                }
                [_secondeZanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_secondeZanImageView setImage:[UIImage imageNamed:@"shade7-1-2"]];
                if (![_secondePersonImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:info.image].absoluteString]) {
                    _secondePersonImageView.imageURL = [CustomUtil getPhotoURL:info.image];
                }
                [CustomUtil setImageViewCorner:_secondePersonImageView];
                [_secondePersonName setText:info.userName];
            } else {
                [_secondeImageView setHidden:YES];
                [_secondeBackImageView setHidden:YES];
                [_secondeZanImageView setHidden:YES];
                [_secondeZanBtn setHidden:YES];
                [_secondePersonImageView setHidden:YES];
                [_secondePersonName setHidden:YES];
            }
            
            //调整控件位置及尺寸
            CGRect rect = _firstBackImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = 5;
            _firstBackImageView.frame = rect;
            
            rect = _firstImageView.frame;
            rect.origin.x = 5;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            _firstImageView.frame = rect;
            
            rect = _secondeBackImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = SCREEN_WIDTH/2.0f + 5;
            _secondeBackImageView.frame = rect;
            
            rect = _secondeImageView.frame;
            rect.origin.x = SCREEN_WIDTH/2.0f + 5;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            _secondeImageView.frame = rect;
            
            rect = _secondePersonName.frame;
            rect.origin.x = _secondeImageView.frame.origin.x + 10 + _secondePersonImageView.frame.size.width + 2;
            _secondePersonName.frame = rect;
        }
            return self.labelListTwoCell;
        default:
        {
            LabelListTableCell *labelListTableCell = [tableView dequeueReusableCellWithIdentifier:@"LabelListTableCell"];
            if (!labelListTableCell) {
                labelListTableCell = [[[NSBundle mainBundle] loadNibNamed:@"LabelListTableCell" owner:self options:nil] lastObject];
            }
            
            labelListTableCell.backgroundColor = RGB(236, 236, 236, 1);
            labelListTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITapGestureRecognizer *tapGestureRecognizerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [labelListTableCell.firstImageView addGestureRecognizer:tapGestureRecognizerOne];
            UITapGestureRecognizer *tapGestureRecognizerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [labelListTableCell.secondeImageView addGestureRecognizer:tapGestureRecognizerTwo];
            NSDictionary *infoDict = [data objectAtIndexCheck:(2*(indexPath.row + 1) - 2)];
            SearchByTagInfo *infoData = [[SearchByTagInfo alloc] initWithDict:infoDict];
            if (![labelListTableCell.firstImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:infoData.photo1].absoluteString]) {
                labelListTableCell.firstImageView.imageURL = [CustomUtil getPhotoURL:infoData.photo1];
            }
            if (![labelListTableCell.firstPersonImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:infoData.image].absoluteString]) {
                labelListTableCell.firstPersonImageView.imageURL = [CustomUtil getPhotoURL:infoData.image];
            }
            [labelListTableCell.firstPersonName setText:infoData.userName];
            [labelListTableCell.firstZanImageView setImage:[UIImage imageNamed:@"shade7-1-2"]];
            if ([infoData.status isEqualToString:@"1"]) { //已赞
                [labelListTableCell.firstZanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
            } else if ([infoData.status isEqualToString:@"0"]) { //未赞
                [labelListTableCell.firstZanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-1-2"] forState:UIControlStateNormal];
            }
            [labelListTableCell.firstZanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            /*
            if (![TKLoginType shareInstance].loginType) {
                [labelListTableCell.firstZanBtn setEnabled:NO];
                [labelListTableCell.secondeZanBtn setEnabled:NO];
            }
             */
            if ((data.count%2 != 0) && ((int)(ceil(data.count/2.0f) == (indexPath.row + 1)))) {
                [labelListTableCell.secondeCellBackImageView setHidden:YES];
                [labelListTableCell.secondeImageView setHidden:YES];
                [labelListTableCell.secondePersonImageView setHidden:YES];
                [labelListTableCell.secondePersonName setHidden:YES];
                [labelListTableCell.secondeZanBtn setHidden:YES];
                [labelListTableCell.secondeZanImageView setHidden:YES];
            } else {
                [labelListTableCell.secondeCellBackImageView setHidden:NO];
                [labelListTableCell.secondeImageView setHidden:NO];
                [labelListTableCell.secondePersonImageView setHidden:NO];
                [labelListTableCell.secondePersonName setHidden:NO];
                [labelListTableCell.secondeZanBtn setHidden:NO];
                [labelListTableCell.secondeZanImageView setHidden:NO];
                NSDictionary *infoDic = [data objectAtIndexCheck:(2*(indexPath.row + 1) - 1)];
                SearchByTagInfo *infoData = [[SearchByTagInfo alloc] initWithDict:infoDic];
                if (![labelListTableCell.secondeImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:infoData.photo1].absoluteString]) {
                    labelListTableCell.secondeImageView.imageURL = [CustomUtil getPhotoURL:infoData.photo1];
                }
                if (![labelListTableCell.secondePersonImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:infoData.image].absoluteString]) {
                    labelListTableCell.secondePersonImageView.imageURL = [CustomUtil getPhotoURL:infoData.image];
                }
                [labelListTableCell.secondePersonName setText:infoData.userName];
                [labelListTableCell.secondeZanImageView setImage:[UIImage imageNamed:@"shade7-1-2"]];
                if ([infoData.status isEqualToString:@"1"]) { //已赞
                    [labelListTableCell.secondeZanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
                } else if ([infoData.status isEqualToString:@"0"]) { //未赞
                    [labelListTableCell.secondeZanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-1-2"] forState:UIControlStateNormal];
                }
                [labelListTableCell.secondeZanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //调整布局
            CGRect rect = labelListTableCell.firstBackImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = 5;
            labelListTableCell.firstBackImageView.frame = rect;
            
            rect = labelListTableCell.firstImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = 5;
            labelListTableCell.firstImageView.frame = rect;
            
            rect = labelListTableCell.secondeCellBackImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = SCREEN_WIDTH/2.0f + 5;
            labelListTableCell.secondeCellBackImageView.frame = rect;
            
            rect = labelListTableCell.secondeImageView.frame;
            rect.size.width = (SCREEN_WIDTH - 5 * 4)/2.0f;
            rect.origin.x = SCREEN_WIDTH/2.0f + 5;
            labelListTableCell.secondeImageView.frame = rect;
            
            rect = labelListTableCell.secondePersonName.frame;
            rect.origin.x = labelListTableCell.secondeImageView.frame.origin.x + 10 + labelListTableCell.secondePersonImageView.frame.size.width + 2;
            labelListTableCell.secondePersonName.frame = rect;
            
            labelListTableCell.firstBackImageView.layer.cornerRadius = 5;
            labelListTableCell.secondeCellBackImageView.layer.cornerRadius = 5;
            
            labelListTableCell.firstBackImageView.clipsToBounds = YES;
            labelListTableCell.secondeCellBackImageView.clipsToBounds = YES;
            labelListTableCell.firstBackImageView.layer.masksToBounds = YES;
            labelListTableCell.secondeCellBackImageView.layer.masksToBounds = YES;

            return labelListTableCell;
        }
            break;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark -按钮点击事件
//点赞
- (void)zanBtnClick:(id)sender {
    UIButton *zanBtn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)(zanBtn.superview.superview);
    NSIndexPath *indexPath = [_labelListTableView indexPathForCell:cell];
    NSString *_streetsnapId = @"";
    NSDictionary *infoDict;
    SearchByTagInfo *infoData;
    if (zanBtn.frame.origin.x <= SCREEN_WIDTH/2) { //点击了第一幅图片的赞按钮
        infoDict = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 2)];
        infoData = [[SearchByTagInfo alloc] initWithDict:infoDict];
        _streetsnapId = infoData.streetsnapId;
    } else { //点击了第二幅图片
        infoDict = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 1)];
        infoData = [[SearchByTagInfo alloc] initWithDict:infoDict];
        _streetsnapId = infoData.streetsnapId;
    }
    
    //点赞或取消赞
    [PublishPraiseInput shareInstance].streetsnapId = _streetsnapId;
    [PublishPraiseInput shareInstance].streetsnapUserId = infoData.userId;
    [PublishPraiseInput shareInstance].userId = [LoginModel shareInstance].userId;
    [PublishPraiseInput shareInstance].flag = infoData.status;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishPraiseInput shareInstance]];
    [[NetInterface shareInstance] publishPraise:@"publishPraise" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        __block NSDictionary *dic = nil;
        if (RETURN_SUCCESS(returnData.status)) {
            if (zanBtn.frame.origin.x <= SCREEN_WIDTH/2) {
                dic = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 2)];
            } else {
                dic = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 1)];
            }
            SearchByTagInfo *tagInfo = [[SearchByTagInfo alloc] initWithDict:dic];
            if ([infoData.status isEqualToString:@"0"]) {
                tagInfo.status = @"1";
                [zanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-1-2"] forState:UIControlStateNormal];
            } else if ([infoData.status isEqualToString:@"1"]) {
                tagInfo.status = @"0";
                [zanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-1-2"] forState:UIControlStateNormal];
            }
            if (zanBtn.frame.origin.x <= SCREEN_WIDTH/2) {
                data[(2 * (indexPath.row + 1) - 2)] = [CustomUtil modelToDictionary:tagInfo];;
            } else {
                data[(2 * (indexPath.row + 1) - 1)] = [CustomUtil modelToDictionary:tagInfo];;
            }
            //[_labelListTableView reloadData];
        }
        [CustomUtil showToastWithText:returnData.msg view:self.view];
    } failedBlock:^(NSError *err) {
    }];
}

//标签图片点击事件
- (void)imageClick:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UITableViewCell *cell = (UITableViewCell *)(gesture.view.superview.superview);
    NSIndexPath *indexPath = [_labelListTableView indexPathForCell:cell];
    CGPoint point = [gesture locationInView:gesture.view.superview.superview];
    NSString *_streetsnapId = @"";
    NSLog(@"indexPath.row = %ld", (long)indexPath.row);
    if (point.x <= SCREEN_WIDTH/2) { //点击了第一幅图片
        NSDictionary *infoDict = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 2)];
        SearchByTagInfo *infoData = [[SearchByTagInfo alloc] initWithDict:infoDict];
        _streetsnapId = infoData.streetsnapId;
    } else { //点击了第二幅图片
        NSDictionary *infoDict = [data objectAtIndexCheck:(2 * (indexPath.row + 1) - 1)];
        SearchByTagInfo *infoData = [[SearchByTagInfo alloc] initWithDict:infoDict];
        _streetsnapId = infoData.streetsnapId;
    }
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = _streetsnapId;
    [_superViewController.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - imageViewClickDelegate
//图片点击事件处理
- (void)imageViewClick:(ImageInfo *)imageInfo
{
    StreetPhotoDetailViewController *viewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.streetsnapId = imageInfo.streetsnapId;
    [_superViewController.navigationController pushViewController:viewCtrl animated:YES];

}

@end
