//
//  PrivateMessageViewController.m
//  mxj
//  P8-3私信实现文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PrivateMessageViewController.h"
#import "PrivateMessageTableCell.h"
#import "SendPrivateMessageViewController.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"

@interface PrivateMessageViewController ()
{
    NSMutableArray *data; //数据
    int currentPageNum;   //当前页码
    int totalPageNum;     //总页数
}
@end

@implementation PrivateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"私信"];
    self.privateMessageTableView.delegate = self;
    self.privateMessageTableView.dataSource = self;
    
#ifdef OPEN_NET_INTERFACE
    data = [[NSMutableArray alloc] init];
    currentPageNum = 1;
    [self reloadData:currentPageNum block:^{
    }];
#endif
    //添加上拉加载更多
    __weak PrivateMessageViewController *blockSelf = self;
    __block int currentPageNumSelf = currentPageNum;
    __block NSMutableArray *dataSelf = data;
    //下拉刷新
    [_privateMessageTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [dataSelf removeAllObjects];
            [blockSelf reloadData:1 block:^{
                currentPageNumSelf = 1;
                [blockSelf.privateMessageTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
    
    //上拉加载更多
    [_privateMessageTableView addInfiniteScrollingWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ((currentPageNum + 1) <=  totalPageNum) {
                currentPageNumSelf++;
                [blockSelf reloadData:currentPageNumSelf block:^{
                    [blockSelf.privateMessageTableView.infiniteScrollingView stopAnimating];
                }];
            } else {
                [blockSelf.privateMessageTableView.infiniteScrollingView stopAnimating];
            }
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //刷新列表
    [_privateMessageTableView triggerPullToRefresh];
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
    return data.count ;
#else
    return 10;
#endif
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessageTableCell *privateMessageTableCell = [tableView dequeueReusableCellWithIdentifier:@"PrivateMessageTableCell"];
    if (!privateMessageTableCell) {
        privateMessageTableCell = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageTableCell" owner:self options:nil] lastObject];
    }
#ifdef OPEN_NET_INTERFACE
    GetMessageListInfo *info = [[GetMessageListInfo alloc] initWithDict:[data objectAtIndexCheck:indexPath.row]];
    privateMessageTableCell.showUserNameLabel.text = info.showUserName;
    privateMessageTableCell.createTimeLabel.text = info.createTime;
    privateMessageTableCell.contentLabel.text = info.content;
    privateMessageTableCell.personImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
    privateMessageTableCell.personImageView.imageURL = [CustomUtil getPhotoURL:info.showImage];
    [CustomUtil setImageViewCorner:privateMessageTableCell.personImageView];
#endif
    privateMessageTableCell.delegate = self;
    
    if ([info.status isEqualToString:@"0"]) { //未读
        [privateMessageTableCell setBackgroundColor:[UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.1f]];
    } else {
        [privateMessageTableCell setBackgroundColor:[UIColor whiteColor]];
    }
    
    return privateMessageTableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessageTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
#ifdef OPEN_NET_INTERFACE
    //取得私信内容
    [GetMessageInput shareInstance].pagesize = @"10";
    [GetMessageInput shareInstance].current = @"1";
    if (data.count == 0) {
        return;
    }
    NSDictionary *infoData = [data objectAtIndexCheck:indexPath.row];
    GetMessageListInfo *info = [[GetMessageListInfo alloc] initWithDict:infoData];
    [GetMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetMessageInput shareInstance].targetId = info.showUserId;
#endif
    SendPrivateMessageViewController *sendPrivateMessageViewCtrl = [[SendPrivateMessageViewController alloc] initWithNibName:@"SendPrivateMessageViewController" bundle:nil];
#ifdef OPEN_NET_INTERFACE
    sendPrivateMessageViewCtrl.userName = info.showUserName;
    sendPrivateMessageViewCtrl.receiveId = info.showUserId;
#endif
    [_currentViewController.navigationController pushViewController:sendPrivateMessageViewCtrl animated:YES];
}

//删除私信
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:_privateMessageTableView]) {
        result = UITableViewCellEditingStyleDelete;
    }
    
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_privateMessageTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        if (indexPath.row < data.count) {
            NSDictionary *infoData = [data objectAtIndexCheck:indexPath.row];
            GetMessageListInfo *info = [[GetMessageListInfo alloc] initWithDict:infoData];
            [DeleteMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
            [DeleteMessageInput shareInstance].objectId = info.showUserId;
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[DeleteMessageInput shareInstance]];
            [[NetInterface shareInstance] deleteMessage:@"deleteMessage" param:dict successBlock:^(NSDictionary *responseDict) {
                BaseModel *returnData = [BaseModel modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    [data removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
            } failedBlock:^(NSError *err) {
            }];
        }
    }
    /*
    [CustomUtil showCustomAlertView:@"" message:@"确定删除私信？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        if (UITableViewCellEditingStyleDelete == editingStyle) {
            if (indexPath.row < data.count) {
                NSDictionary *infoData = [data objectAtIndexCheck:indexPath.row];
                GetMessageListInfo *info = [[GetMessageListInfo alloc] initWithDict:infoData];
                [DeleteMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
                [DeleteMessageInput shareInstance].objectId = info.showUserId;
                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[DeleteMessageInput shareInstance]];
                [[NetInterface shareInstance] deleteMessage:@"deleteMessage" param:dict successBlock:^(NSDictionary *responseDict) {
                    BaseModel *returnData = [BaseModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(returnData.status)) {
                        [data removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                } failedBlock:^(NSError *err) {
                }];
            }
        }
    } target:self btnCount:2];
     */
}

#pragma mark -按钮点击事件
-(void)imageViewClick:(id)sender
{
    NSIndexPath *indexPath = [_privateMessageTableView indexPathForCell:(UITableViewCell *)(((UIButton *)sender).superview.superview)];
    NSDictionary *dict = [data objectAtIndexCheck:indexPath.row];
    GetMessageListInfo *info = [[GetMessageListInfo alloc] initWithDict:dict];
    if ([CustomUtil CheckParam:info.userId]) {
        return;
    }
    if ([info.showUserId isEqualToString:[LoginModel shareInstance].userId]) {
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
    } else {
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.showUserId;
        [_currentViewController.navigationController pushViewController:viewCtrl animated:YES];
    }
}

#pragma mark -共通方法
//获取数据
-(void)reloadData:(int)current block:(void(^)())block
{
    [GetMessageListInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetMessageListInput shareInstance].pagesize = @"10";
    [GetMessageListInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetMessageListInput shareInstance]];
    [[NetInterface shareInstance] getMessageList:@"getMessageList" param:dict successBlock:^(NSDictionary *responseDict) {
        GetMessageList *messageList = [GetMessageList modelWithDict:responseDict];
        totalPageNum = [messageList.totalpage intValue];
        if (RETURN_SUCCESS(messageList.status)) {
            if ([messageList.info isKindOfClass:[NSArray class]] && messageList.info.count > 0) {
                for (int i=0; i<messageList.info.count; i++) {
                    [data addObject:messageList.info[i]];
                }
                [_privateMessageTableView reloadData];
            } else {
                [CustomUtil showToastWithText:messageList.msg view:kWindow];
            }
        } else {
            [CustomUtil showToastWithText:messageList.msg view:kWindow];
        }
        block();
    } failedBlock:^(NSError *err) {
    }];
}

@end
