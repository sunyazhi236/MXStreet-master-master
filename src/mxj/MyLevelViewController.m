//
//  MyLevelViewController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MyLevelViewController.h"

@interface MyLevelViewController ()
{
    NSMutableArray *onceDataArray;     //一次性奖励成长值规则数组
    NSMutableArray *everyDayDataArray; //每日奖励成长值规则数组
    NSMutableArray *levelDataArray;    //用户等级与成长值的关系
}

@end

@implementation MyLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    // Do any additional setup after loading the view from its nib.
    self.myLevelTableView.delegate = self;
    self.myLevelTableView.dataSource = self;
    [self.navigationItem setTitle:@"我的等级"];
#ifdef OPEN_NET_INTERFACE
    onceDataArray = [[NSMutableArray alloc] init];
    everyDayDataArray = [[NSMutableArray alloc] init];
    levelDataArray = [[NSMutableArray alloc] init];
#endif
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = onceDataArray.count;
            break;
        case 1:
            number = everyDayDataArray.count;
            break;
        case 2:
            number = levelDataArray.count;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (2 == section) {
        return 24;
    }
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _OneCell;
        case 1:
            return _twoCell;
        case 2:
            return _threeCell;
        default:
            break;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLevelCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyLevelCell" owner:self options:nil] lastObject];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            GetUserLevelInfoOnceData *data = (GetUserLevelInfoOnceData *)[onceDataArray objectAtIndexCheck:indexPath.row];
            cell.nameLabel.text = data.userAction;
            cell.scollLabel.text = data.levelValue;
            cell.contentLabel.text = data.levelInfo;
        }
            break;
        case 1:
        {
            GetUserLevelInfoEveryDayData *data = (GetUserLevelInfoEveryDayData *)[everyDayDataArray objectAtIndexCheck:indexPath.row];
            cell.nameLabel.text = data.userAction;
            cell.scollLabel.text = data.levelValue;
            cell.contentLabel.text = data.levelInfo;
        }
            break;
        case 2:
        {
            GetUserLevelInfoLevelData *data = (GetUserLevelInfoLevelData *)[levelDataArray objectAtIndexCheck:indexPath.row];
            cell.nameLabel.text = data.gradeName;
            cell.scollLabel.text = data.gradePoint;
            cell.contentLabel.text = data.gradeDesc;
        }
            break;
        default:
            break;
    }
    return cell;
}

//加载数据
-(void)reloadData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [[NetInterface shareInstance] getUserLevelInfo:@"getUserLevelInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUserLevelInfo *returnData = [GetUserLevelInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            int i=0;
            for (i=0; i<returnData.onceData.count; i++) {
                GetUserLevelInfoOnceData *onceData = [[GetUserLevelInfoOnceData alloc] initWithDict:(NSDictionary *)(returnData.onceData[i])];
                [onceDataArray addObject:onceData];
            }
            for (i=0; i<returnData.everyDayData.count; i++) {
                GetUserLevelInfoEveryDayData *everyDayData = [[GetUserLevelInfoEveryDayData alloc] initWithDict:(NSDictionary *)(returnData.everyDayData[i])];
                [everyDayDataArray addObject:everyDayData];
            }
            for (i=0; i<returnData.levelData.count; i++) {
                GetUserLevelInfoLevelData *levelData = [[GetUserLevelInfoLevelData alloc] initWithDict:(NSDictionary *)(returnData.levelData[i])];
                [levelDataArray addObject:levelData];
            }
            [_myLevelTableView reloadData];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

@end
