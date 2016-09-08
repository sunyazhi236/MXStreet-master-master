//
//  NoticeVCViewController.m
//  mxj
//
//  Created by HANNY on 16/8/16.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "NoticeVCViewController.h"

static NoticeVCViewController *_singleManager = nil;

@interface NoticeVCViewController ()

@property (nonatomic, strong)NSMutableArray *mTagArray;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSString *userId;
@end

@implementation NoticeVCViewController

+ (instancetype)shareViewController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleManager = [[NoticeVCViewController allocWithZone:NULL] init];
    });
    return _singleManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self initButten];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationItem setTitle:@"新消息通知"];
    self.index = 0;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    
}

//初始化按钮
- (void)initButten
{
    self.userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    self.mTagArray = [[userdefault valueForKey:@"tagArray"] mutableCopy];
    
    //数组顺序不能变
    NSArray *btnArray = @[self.sixinBtn, self.guanzhuBtn ,self.xinfensiBtn, self.pinglunBtn, self.zanBtn, self.dashangBtn, self.xitongxiaoxiBtn];
    NSArray *proTagArray = @[@"maoxj_3",@"maoxj_2", @"maoxj_5",@"maoxj_7",@"maoxj_4",@"maoxj_6",@"maoxj_1"];
    NSMutableArray *tagArray = [NSMutableArray array];
    [proTagArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 6) {
            [tagArray addObject:@"maoxj_1"];
        } else {
            [tagArray addObject:[NSString stringWithFormat:@"%@_%@", proTagArray[idx], self.userId]];
        }
    }];
    
    [btnArray enumerateObjectsUsingBlock:^(UISwitch *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.tag = 1001 + idx;
//        [btn setBackgroundImage:[UIImage imageNamed:@"off_12"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"on_12"] forState:UIControlStateSelected];
        if (![self.mTagArray containsObject:tagArray[idx]]) {
            btn.on = NO;
        } else {
            btn.on = YES;
        }
//        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ btn addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }];
}

#pragma mark -按钮点击事件处理
//消息推送按钮点击事件
-(void)switchValueChanged:(UISwitch *)btn{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *tagID;
    NSLog(@"%@", self.mTagArray);
    if (btn.tag==1001) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_3", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"sixinFlag"];
            //添加注册私信tag
            [self.mTagArray addObject:tagID];
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"sixinFlag"];
            //删除注册的私信tag
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1002) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_2", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"guanzhuFlag"];
            //添加注册街蜜发布新街拍tag
            [self.mTagArray addObject:tagID];
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"guanzhuFlag"];
            //删除注册的街蜜发布新街拍tag
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1003) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_5", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"xinfensiFlag"];
            //添加新粉丝tag
            [self.mTagArray addObject:tagID];
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"xinfensiFlag"];
            //删除新粉丝tag
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1004) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_7", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"pinglunFlag"];
            [self.mTagArray addObject:tagID];
            
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"pinglunFlag"];
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1005) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_4", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"zanFlag"];
            [self.mTagArray addObject:tagID];

        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"zanFlag"];
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1006) {
        tagID = [NSString stringWithFormat:@"%@_%@", @"maoxj_6", self.userId];
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"dashangFlag"];
            [self.mTagArray addObject:tagID];
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"dashangFlag"];
            [self.mTagArray removeObject:tagID];
        }
    }
    if (btn.tag==1007) {
        tagID = @"maoxj_1";
        if (btn.isOn) {
            btn.on = YES;
            [userdefault setObject:@"kai" forKey:@"xitongxiaoxiFlag"];
            [self.mTagArray addObject:tagID];
        }else{
            btn.on = NO;
            [userdefault setObject:@"guan" forKey:@"xitongxiaoxiFlag"];
            [self.mTagArray removeObject:tagID];
        }
    }
    NSMutableSet *tagSet = [NSMutableSet setWithArray:self.mTagArray];
    [self.timer invalidate];
    self.index = 0;
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayadTime:) userInfo:tagSet repeats:YES];
    [[NSUserDefaults standardUserDefaults] setObject:self.mTagArray forKey:@"tagArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [userdefault synchronize];
}

-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    if (iResCode != 0) {
        NSLog(@"设置失败");
        NSLog(@"%d", iResCode);
        [JPUSHService setTags:[NSSet setWithArray:self.mTagArray] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        NSLog(@"设置成功");
        
    }
}

- (void)delayadTime:(NSTimer *)timer
{
    self.index++;
    if (self.index == 4) {
        [JPUSHService setTags:timer.userInfo callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [self.timer invalidate];
    }
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
    return 7; //10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return self.sixinCell;
        }
            break;
        case 1:{
            return self.guanzhuCell;
        }
            break;
        case 2:{
            return self.xinfensiCell;
        }
            break;
        case 3:{
            return self.pinglunCell;
        }
            break;
        case 4:{
            return self.zanCell;
        }
            break;
        case 5:{
            return self.dashangCell;
        }
            break;
        case 6:{
            return self.xitongXiiaoxiCell;
        }
            break;

        default:
            break;
    }
    return [[UITableViewCell alloc] init];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.text=@"  开启以下消息的通知";
    return headerLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
