//
//  CustomLabelViewController.m
//  mxj
//  P7-2-3自定义标签
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "CustomLabelViewController.h"
#import "CustomLabelCell.h"
#import "EditPhotoViewController.h"

#define LABLE_NAME_LENGTH 10 //标签名称的长度（汉字个数）

@interface CustomLabelViewController ()
{
   // NSArray *labelNameArray; //标签名称数组
    NSMutableArray *popLabelArray; //热门标签
    NSMutableArray *searchResultArray; //检索结果数组
    
    NSMutableArray *historyArray; //检索结果数组

    BOOL intoFlag;                     //表格标记 YES:初始化进入 NO:检索进入
    NSString *addTagName;      //添加或选择的标签名称
    NSString *addTagId;        //添加或选择的标签Id
    int currentPageNum;        //当前page页
    int totalPageNum;          //总页数
}

@end

@implementation CustomLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customLabelTableView.delegate = self;
    self.customLabelTableView.dataSource = self;
    self.customLabelTextFiled.delegate = self;
    self.customLabelTextFiled.returnKeyType = UIReturnKeySearch;
    
//    historyArray = [NSMutableArray arrayWithCapacity:0];
//    historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LabelHistoryData"];
    
    /*
    labelNameArray = [[NSArray alloc] initWithObjects:
                      @"标签1",
                      @"标签2",
                      @"标签3",
                      @"标签4",
                      @"标签5",
                      @"标签6",
                      @"标签7",
                      @"标签8",
                      @"标签9",
                      @"标签10",
                      nil];
     */
    popLabelArray = [[NSMutableArray alloc] init];
    searchResultArray = [[NSMutableArray alloc] init];
    [self.customLabelTableView setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self initUI];
    currentPageNum = 1;
    totalPageNum = 0;
    //添加上拉加载更多
    __weak CustomLabelViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = popLabelArray;
    //下拉刷新
    [_customLabelTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.customLabelTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_customLabelTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ((currentPageNumSelf + 1) <= totalPageNum) {
                currentPageNumSelf++;
                [blockSelf reloadData:currentPageNumSelf block:^{
                    [blockSelf.customLabelTableView.infiniteScrollingView stopAnimating];
                }];
            } else {
                [blockSelf.customLabelTableView.infiniteScrollingView stopAnimating];
            }
        });
    }];
    
//    _customLabelTextFiled.backgroundColor = RGB(231, 232, 235, 1);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //注册文本输入内容监听
    [_customLabelTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
-(void)textFieldDidChange:(UITextField *)textFiled
{
    intoFlag = NO;
    [_customLabelTableView setHidden:NO];
    [SearchInput shareInstance].pagesize = @"100";
    [SearchInput shareInstance].current = @"1";
    [SearchInput shareInstance].type = @"1";  //标签查询
    [SearchInput shareInstance].tagName = _customLabelTextFiled.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SearchInput shareInstance]];
    [[NetInterface shareInstance] search:@"search" param:dict successBlock:^(NSDictionary *responseDict) {
        Search *returnData = [Search modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [searchResultArray removeAllObjects];
            [searchResultArray addObjectsFromArray:returnData.info];
            [_customLabelTableView reloadData];
        }
    } failedBlock:^(NSError *err) {
    }];
}

//重新加载数据
- (void)reloadData:(int)pageNum block:(void(^)())block
{
//    [GetPopTagListInput shareInstance].current = [NSString stringWithFormat:@"%d", pageNum];
//    [GetPopTagListInput shareInstance].pagesize = @"10";
//    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetPopTagListInput shareInstance]];
    //获取当前用户标签列表
    [GetStreetsnapListInput shareInstance].pagesize = @"10";
    [GetStreetsnapListInput shareInstance].current = [NSString stringWithFormat:@"%d", currentPageNum];
    [GetStreetsnapListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetStreetsnapListInput shareInstance].type = @"0";
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapListInput shareInstance]];
//    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [[NetInterface shareInstance] getPopTagList:@"getMyTagList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetPopTagList *returnData = [GetPopTagList modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            totalPageNum = [returnData.totalpage intValue];
            [popLabelArray addObjectsFromArray:returnData.info];
            [_customLabelTableView reloadData];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -按钮点击事件处理
//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    addTagName = @"";
    addTagId = @"";
    ((EditPhotoViewController *)_preViewCtrl).addLabelName = addTagName;
    ((EditPhotoViewController *)_preViewCtrl).addLabelId = addTagId;
    [self.navigationController popViewControllerAnimated:YES];
}

//添加按钮点击事件
- (IBAction)addBtnClick:(id)sender {
    if ([CustomUtil CheckParam:_customLabelTextFiled.text]) {
        [CustomUtil showToastWithText:@"请输入标签名称" view:self.view];
        return;
    }
    //检查添加的标签名称是否小于10个汉字（20个字符）
    NSInteger chineseCharCount = [CustomUtil chineseCountOfString:_customLabelTextFiled.text];
    NSInteger charCount = [CustomUtil characterCountOfString:_customLabelTextFiled.text];
    NSInteger totalCount = chineseCharCount * 2 + charCount;
    if (totalCount > LABLE_NAME_LENGTH * 2) {
        [CustomUtil showToastWithText:@"标签名20个字符以内" view:kWindow];
        return;
    }
    
    //添加标签
    [AddTagInput shareInstance].userId = [LoginModel shareInstance].userId;
    [AddTagInput shareInstance].tagName = _customLabelTextFiled.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[AddTagInput shareInstance]];
    [[NetInterface shareInstance] addTag:@"addTag" param:dict successBlock:^(NSDictionary *responseDict) {
        AddTag *resultData = [AddTag modelWithDict:responseDict];
        if (RETURN_SUCCESS(resultData.status)) {
            NSString *returnTagId = resultData.tagId;
            
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>
//            [[NSUserDefaults standardUserDefaults] objectForKey:@"LabelHistoryData"];
            
            //跳转至编辑画面
            [CustomUtil showToastWithText:resultData.msg view:[UIApplication sharedApplication].keyWindow];
            addTagName = _customLabelTextFiled.text;
            addTagId = returnTagId;
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                if ([viewCtrl isKindOfClass:[EditPhotoViewController class]]) {
                    ((EditPhotoViewController *)viewCtrl).addLabelName = addTagName;
                    ((EditPhotoViewController *)viewCtrl).addLabelId = addTagId;
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
            return;
        } else {
            [CustomUtil showToastWithText:resultData.msg view:[UIApplication sharedApplication].keyWindow];
        }
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
    if (intoFlag) {
        return popLabelArray.count;
    } else {
        if (searchResultArray.count) {
            return searchResultArray.count;
        }
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomLabelCell *customLabelCell = [tableView dequeueReusableCellWithIdentifier:@"CustomLabelCell"];
    if (!customLabelCell) {
        customLabelCell = [[[NSBundle mainBundle] loadNibNamed:@"CustomLabelCell" owner:self options:nil] lastObject];
    }
    if (intoFlag) {
        if (popLabelArray.count > 0) {
            GetPopTagListInfo *info = [[GetPopTagListInfo alloc] initWithDict:[popLabelArray objectAtIndexCheck:indexPath.row]];
            [customLabelCell.labelName setText:info.tagName];
        }
    } else {
        if (searchResultArray.count > 0) {
            SearchInfo *info = [[SearchInfo alloc] initWithDict:[searchResultArray objectAtIndexCheck:indexPath.row]];
            [customLabelCell.labelName setText:info.tagName];
        }
        else {
            [customLabelCell.labelName setText:[NSString stringWithFormat:@"添加“%@”标签",_customLabelTextFiled.text]];
        }
    }
    
    return customLabelCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intoFlag) {
        GetPopTagListInfo *info = [[GetPopTagListInfo alloc] initWithDict:[popLabelArray objectAtIndexCheck:indexPath.row]];
        addTagName = info.tagName;
        addTagId = info.tagId;
    } else {
        if (searchResultArray.count > 0) {
            SearchInfo *info = [[SearchInfo alloc] initWithDict:[searchResultArray objectAtIndexCheck:indexPath.row]];
            addTagName = info.tagName;
            addTagId = info.tagId;
        }
        else {
            [self addBtnClick:nil];
            return;
        }
    }
    ((EditPhotoViewController *)_preViewCtrl).addLabelName = addTagName;
    ((EditPhotoViewController *)_preViewCtrl).addLabelId = addTagId;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    intoFlag = YES;
    addTagName = @"";
    addTagId = @"";
    [self.customLabelTableView setHidden:NO];
    [self reloadData:1 block:^{
    }];
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    intoFlag = NO;
    [_customLabelTableView setHidden:NO];
    [SearchInput shareInstance].pagesize = @"10";
    [SearchInput shareInstance].current = @"1";
    [SearchInput shareInstance].type = @"1";  //标签查询
    [SearchInput shareInstance].tagName = _customLabelTextFiled.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SearchInput shareInstance]];
    [[NetInterface shareInstance] search:@"search" param:dict successBlock:^(NSDictionary *responseDict) {
        Search *returnData = [Search modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [searchResultArray removeAllObjects];
            [searchResultArray addObjectsFromArray:returnData.info];
            [_customLabelTableView reloadData];
        }
    } failedBlock:^(NSError *err) {
    }];
    return YES;
}

@end