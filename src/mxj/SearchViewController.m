//
//  SearchViewController.m
//  mxj
//  P7-1搜索页面
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultOneCell.h"
#import "SearchResultTwoCell.h"
#import "SearchResultThreeCell.h"
#import "LabelDetailViewController.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"

@interface SearchViewController ()
{
//    BOOL searchFlag; //搜索切换flag YES：标签 NO：用户
    NSInteger searchFlag; //搜索切换flag 0：标签 1：门牌 2：用户
    NSMutableArray *data; //检索数据
    int currentPageNum;   //当前页码
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //默认选中标签按钮
//    searchFlag = YES;
    searchFlag = 0;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
//    [self.searchResultTableView setHidden:YES];
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1;
    
    //添加上拉加载更多
    __weak SearchViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    
    //上拉加载更多
    [_searchResultTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNumSelf++;
            [blockSelf reloadData:currentPageNumSelf block:^{
                [blockSelf.searchResultTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //注册监听事件
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _searchResultTableView) {
        if ([_searchTextField isFirstResponder]) {
            [_searchTextField resignFirstResponder];
        }
    }
}

#pragma mark -按钮点击事件
//取消按钮点击事件处理
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//标签按钮点击事件处理
- (IBAction)labelBtnClick:(id)sender {
     searchFlag = 0;
    [self.searchResultTableView setHidden:NO];
    [self reloadData:1 block:^{
    }];
    [self.labelBtn setBackgroundImage:[UIImage imageNamed:@"tab-left7_1"] forState:UIControlStateNormal];
    [self.labelBtn setTitleColor:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:26/255.0 alpha:0.7f] forState:UIControlStateNormal];
    
    [self.doorBtn setBackgroundImage:[UIImage imageNamed:@"tab-right7_1"] forState:UIControlStateNormal];
    [self.doorBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.userBtn setBackgroundImage:[UIImage imageNamed:@"tab-right7_1"] forState:UIControlStateNormal];
    [self.userBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.labelBtn];
    
    [self.view insertSubview:self.doorBtn atIndex:self.view.subviews.count - 2];
    
//    self.searchTextField.text = nil;
    self.searchTextField.placeholder = @"搜标签";
    
    if (1 == searchFlag || 2 == searchFlag) {
        currentPageNum = 1;

        [self.searchResultTableView setHidden:YES];
    }
    
//    searchFlag = YES;
    searchFlag = 0;
}

//门牌按钮点击事件处理
- (IBAction)doorBtnClick:(id)sender {
      searchFlag = 1;
    [self.searchResultTableView setHidden:NO];
    [self reloadData:1 block:^{
    }];
    [self.labelBtn setBackgroundImage:[UIImage imageNamed:@"tab-left7-1-1_2"] forState:UIControlStateNormal];
    [self.labelBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.doorBtn setBackgroundImage:[UIImage imageNamed:@"tab-right7-1-1_2"] forState:UIControlStateNormal];
    [self.doorBtn setTitleColor:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:26/255.0 alpha:0.7f] forState:UIControlStateNormal];
    
    [self.userBtn setBackgroundImage:[UIImage imageNamed:@"tab-left7-1-1_2"] forState:UIControlStateNormal];
    [self.userBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.doorBtn];
    
//    self.searchTextField.text = nil;
    self.searchTextField.placeholder = @"搜门牌";
    
    if (0 == searchFlag || 2 == searchFlag) {
        currentPageNum = 1;
        
        [self.searchResultTableView setHidden:YES];
    }
    //    searchFlag = NO;
    searchFlag = 1;
}

//用户按钮点击事件处理
- (IBAction)userBtnClick:(id)sender {
    searchFlag = 2;
    [self.searchResultTableView setHidden:NO];
    [self reloadData:1 block:^{
    }];
    [self.labelBtn setBackgroundImage:[UIImage imageNamed:@"tab-left7-1-1_2"] forState:UIControlStateNormal];
    [self.labelBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.doorBtn setBackgroundImage:[UIImage imageNamed:@"tab-left7-1-1_2"] forState:UIControlStateNormal];
    [self.doorBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    
    [self.userBtn setBackgroundImage:[UIImage imageNamed:@"tab-right7-1-1_2"] forState:UIControlStateNormal];
    [self.userBtn setTitleColor:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:26/255.0 alpha:0.7f] forState:UIControlStateNormal];
    
    [self.view insertSubview:self.labelBtn atIndex:self.view.subviews.count];
    
    [self.view bringSubviewToFront:self.userBtn];
    
//    self.searchTextField.text = nil;
    self.searchTextField.placeholder = @"搜用户";

    if (0 == searchFlag || 1 == searchFlag) {
        currentPageNum = 1;
        
        [self.searchResultTableView setHidden:YES];
    }
//    searchFlag = NO;
    searchFlag = 2;
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchInfo *info = [[SearchInfo alloc] initWithDict:(NSDictionary *)(data[indexPath.row])];
    if (0 == searchFlag) {
        SearchResultOneCell *resultOneCell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultOneCell"];
        if (!resultOneCell) {
            resultOneCell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultOneCell" owner:self options:nil] lastObject];
        }
        resultOneCell.searchResultLabel.text = info.tagName;
        return resultOneCell;
    }
    
    else if (1 == searchFlag) {
        SearchResultTwoCell *resultTwoCell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultTwoCell"];
        if (!resultTwoCell) {
            resultTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTwoCell" owner:self options:nil] lastObject];
        }
        resultTwoCell.searchResultLabel.text = info.userName;
        resultTwoCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
        return resultTwoCell;
    }
    
    else if (2 == searchFlag) {
        SearchResultThreeCell *resultThreeCell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultThreeCell"];
        if (!resultThreeCell) {
            resultThreeCell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultThreeCell" owner:self options:nil] lastObject];
        }
        resultThreeCell.searchResultLabel.text = info.userName;
        resultThreeCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.image];
        return resultThreeCell;
    }
    
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchInfo *info = [[SearchInfo alloc] initWithDict:(NSDictionary *)(data[indexPath.row])];
    if (0 == searchFlag) {
        //跳转至标签列表界面
        LabelDetailViewController *labelListViewCtrl = [[LabelDetailViewController alloc] init];
        labelListViewCtrl.tagId = info.tagId;
        labelListViewCtrl.tagName = info.tagName;
        [self.navigationController pushViewController:labelListViewCtrl animated:YES];
    } else {
        if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) {
            //跳转至我的主页
            MyStreetPhotoViewController *myStreetPhotoViewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
            [self.navigationController pushViewController:myStreetPhotoViewCtrl animated:YES];
        } else {
            //跳转至P9-0个人主页
            MyStreetPhotoViewController *personMainPageViewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
            personMainPageViewCtrl.type = 1;
            personMainPageViewCtrl.userId = info.userId;
            [self.navigationController pushViewController:personMainPageViewCtrl animated:YES];
        }
    }
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchResultTableView setHidden:NO];
    [data removeAllObjects];
    [self reloadData:currentPageNum block:^{
        [_searchTextField resignFirstResponder];
    }];
    
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textFiled
{
    [self.searchResultTableView setHidden:NO];
    [self reloadData:1 block:^{
    }];
}

//加载数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [SearchInput shareInstance].userDoorId = @"";
    [SearchInput shareInstance].userName = @"";
    [SearchInput shareInstance].tagName = @"";

    [SearchInput shareInstance].pagesize = @"10";
    [SearchInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    if (searchFlag == 0) {
        [SearchInput shareInstance].type = @"1";
        [SearchInput shareInstance].tagName = _searchTextField.text;
    }
    else if (searchFlag == 1) {
        [SearchInput shareInstance].type = @"0";
        [SearchInput shareInstance].userDoorId = _searchTextField.text;
    }
    else if (searchFlag == 2) {
        [SearchInput shareInstance].type = @"0";
        [SearchInput shareInstance].userName = _searchTextField.text;
    }
    
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SearchInput shareInstance]];

    if (searchFlag == 0) {
        // 标签
        [[NetInterface shareInstance] search:@"search" param:dict successBlock:^(NSDictionary *responseDict) {
            Search *returnData = [Search modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if (1 == current) {
                    [data removeAllObjects];
                }
                for (int i=0; i<returnData.info.count; i++) {
                    NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                    [data addObject:infoDict];
                }
                [_searchResultTableView reloadData];
            } else {
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            }
            block();
        } failedBlock:^(NSError *err) {
        }];
    }
    else {
        // 用户&门牌号
        [[NetInterface shareInstance] search:@"newSearch" param:dict successBlock:^(NSDictionary *responseDict) {
            Search *returnData = [Search modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if (1 == current) {
                    [data removeAllObjects];
                }
                for (int i=0; i<returnData.info.count; i++) {
                    NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                    [data addObject:infoDict];
                }
                [_searchResultTableView reloadData];
            } else {
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            }
            block();
        } failedBlock:^(NSError *err) {
        }];
    }
}

@end
