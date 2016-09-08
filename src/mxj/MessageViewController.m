//
//  MessageViewController.m
//  mxj
//  P8消息实现文件
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableCell.h"
#import "CommentViewController.h"
#import "NoticeViewController.h"
#import "PrivateMessageViewController.h"
#import "EncourageMeViewController.h"
#import "TabBarController.h"

#define ROW_COUNT 4

#define BUTTON_TAG 100

#define LABLE_TAG 200

@interface MessageViewController ()

@property (nonatomic, assign) CGFloat headTop;

@property (nonatomic, strong) UIView *backView;

// 私信
@property (nonatomic, strong) PrivateMessageViewController *privateMessageViewCtrl;

// 评论
@property (nonatomic, strong) CommentViewController *commentViewCtrl;

// 赞赏
@property (nonatomic, strong) EncourageMeViewController *encourageMeViewCtrl;

// 通知
@property (nonatomic, strong) NoticeViewController *noticeViewCtrl;

@end

@implementation MessageViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
//    self.messageTableView.delegate = self;
//    self.messageTableView.dataSource = self;
    [self initView];

}

- (void)initView
{
    CGFloat button_top = 12;
    
    CGFloat button_weight = 50;

    CGFloat button_height = 33;
    
    NSArray *array = @[@"私信", @"评论", @"赞赏", @"通知"];

    CGFloat button_offset_x = (SCREEN_WIDTH - array.count * button_weight) / 5;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 12 * 2 + button_height)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + BUTTON_TAG;
        button.badgeCenterOffset = CGPointMake(-6, 4);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(button_offset_x * (i + 1) + button_weight * i, 12, button_weight, button_height);
        [button setBackgroundImage:[UIImage imageNamed:@"按钮-未选"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"按钮-选中"] forState:UIControlStateSelected];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#a3a3a3"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [buttonView addSubview:button];
    }
    
    _headTop = 64 + button_top * 2 + button_height;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _headTop, SCREEN_WIDTH, SCREEN_HEIGHT - _headTop - TABBAR_HEIGHT)];
    [self.view addSubview:_backView];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:BUTTON_TAG];
    [self buttonClick:button];
    
    [_allReadButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.9] forState:UIControlStateNormal];
    _allReadButton.layer.cornerRadius = 13;
    _allReadButton.layer.borderWidth = 1;
    _allReadButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    [_allReadButton addTarget:self action:@selector(allread) forControlEvents:UIControlEventTouchUpInside];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_privateMessageViewCtrl viewWillAppear:YES];
//    [_commentViewCtrl viewWillAppear:YES];
//    [_encourageMeViewCtrl viewWillAppear:YES];
//    [_noticeViewCtrl viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
#ifdef OPEN_NET_INTERFACE
    [GetUnreadNumInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUnreadNumInput shareInstance]];
    [[NetInterface shareInstance] getUnreadNum:@"getUnreadNum" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUnreadNum *unreadNumData = [GetUnreadNum modelWithDict:responseDict];
        if (RETURN_SUCCESS(unreadNumData.status)) {
            [self refreshUnreadCount];
            //设置消息圆点
            if (([unreadNumData.commentNum intValue] > 0) ||
                ([unreadNumData.noticeNum intValue] > 0)  ||
                ([unreadNumData.messageNum intValue] > 0) ||
                ([unreadNumData.praiseNum intValue] > 0)) {
                [((TabBarController *)_tabBarCtrl).pointImageView setHidden:NO];
            } else {
                [((TabBarController *)_tabBarCtrl).pointImageView setHidden:YES];
            }
            //设置桌面图标右上角的数字
            NSInteger badgeNum = [unreadNumData.commentNum intValue] + [unreadNumData.noticeNum intValue] + [unreadNumData.messageNum intValue] + [unreadNumData.praiseNum intValue];
            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNum;
            [JPUSHService setBadge:badgeNum];
        } else {
            [CustomUtil showCustomAlertView:@"提示" message:unreadNumData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        }
    } failedBlock:^(NSError *err) {
    }];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClickWithType:(NSInteger)type
{
    UIButton *button = (UIButton *)[self.view viewWithTag:type + BUTTON_TAG];
    [self buttonClick:button];
}

#pragma mark - 按钮事件
- (void)allread
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/message/changeAllInformState" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"responseDict:%@",responseDict);

        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]] && [[responseDict objectForKey:@"code"] integerValue] == 1) {
            [GetUnreadNum shareInstance].messageNum = @"0";
            [GetUnreadNum shareInstance].commentNum = @"0";
            [GetUnreadNum shareInstance].praiseNum = @"0";
            [GetUnreadNum shareInstance].noticeNum = @"0";
            
            [self refreshUnreadCount];
            
            //设置消息圆点
            [((TabBarController *)_tabBarCtrl).pointImageView setHidden:YES];

            //设置桌面图标右上角的数字
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [JPUSHService setBadge:0];
        }

    }failedBlock:^(NSError *err) {
        
    }];
    
    NSLog(@"全部已读");
}

- (void)buttonClick:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i + BUTTON_TAG];
        button.selected = NO;
        if (btn.tag == i+BUTTON_TAG) {
            btn.selected = YES;
        }
    }
    
    if (btn.tag == BUTTON_TAG) {
        // 私信
        [_privateMessageViewCtrl viewWillAppear:YES];
        [_backView addSubview:self.privateMessageViewCtrl.view];
        self.privateMessageViewCtrl.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(_backView));
    }
    else if (btn.tag == BUTTON_TAG + 1) {
        // 评论
        [_commentViewCtrl viewWillAppear:YES];
        [_backView addSubview:self.commentViewCtrl.view];
        self.commentViewCtrl.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(_backView));
    }
    else if (btn.tag == BUTTON_TAG + 2) {
        // 赞赏
        [_encourageMeViewCtrl viewWillAppear:YES];
        [_backView addSubview:self.encourageMeViewCtrl.view];
        self.encourageMeViewCtrl.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(_backView));
    }
    else if (btn.tag == BUTTON_TAG + 3) {
        // 通知
        [_noticeViewCtrl viewWillAppear:YES];
        [_backView addSubview:self.noticeViewCtrl.view];
        self.noticeViewCtrl.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(_backView));
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:
                             @[[GetUnreadNum shareInstance].messageNum ? [GetUnreadNum shareInstance].messageNum : @"",
                               [GetUnreadNum shareInstance].commentNum ? [GetUnreadNum shareInstance].commentNum : @"",
                               [GetUnreadNum shareInstance].praiseNum ? [GetUnreadNum shareInstance].praiseNum : @"",
                               [GetUnreadNum shareInstance].noticeNum ? [GetUnreadNum shareInstance].noticeNum : @""]];
    for (int i = 0; i < array.count; i++) {
        NSString *str = array[i];
        if (str.intValue > 0 && i == btn.tag - BUTTON_TAG) {
            if (i == 0) {
                [GetUnreadNum shareInstance].messageNum = @"0";
            }
            else if (i == 1) {
                [GetUnreadNum shareInstance].commentNum = @"0";
            }
            else if (i == 2) {
                [GetUnreadNum shareInstance].praiseNum = @"0";
            }
            else if (i == 3) {
                [GetUnreadNum shareInstance].noticeNum = @"0";
            }
            
            [self refreshUnreadCount];
        }
    }
}

- (void)refreshUnreadCount
{

    NSArray *array = @[[GetUnreadNum shareInstance].messageNum ? [GetUnreadNum shareInstance].messageNum : @"",
                       [GetUnreadNum shareInstance].commentNum ? [GetUnreadNum shareInstance].commentNum : @"",
                       [GetUnreadNum shareInstance].praiseNum ? [GetUnreadNum shareInstance].praiseNum : @"",
                       [GetUnreadNum shareInstance].noticeNum ? [GetUnreadNum shareInstance].noticeNum : @""];

    for (int i = 0; i < array.count; i ++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:BUTTON_TAG + i];
        [button showBadgeWithStyle:WBadgeStyleNumber value:[array[i] integerValue] animationType:WBadgeAnimTypeNone];
    }

}

- (PrivateMessageViewController *)privateMessageViewCtrl
{
    if (!_privateMessageViewCtrl) {
        _privateMessageViewCtrl = [[PrivateMessageViewController alloc] initWithNibName:@"PrivateMessageViewController" bundle:nil];
        _privateMessageViewCtrl.currentViewController = self;
    }
    return _privateMessageViewCtrl;
}

- (CommentViewController *)commentViewCtrl
{
    if (!_commentViewCtrl) {
        _commentViewCtrl = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
        _commentViewCtrl.currentViewController = self;
    }
    return _commentViewCtrl;
}

- (EncourageMeViewController *)encourageMeViewCtrl
{
    if (!_encourageMeViewCtrl) {
        _encourageMeViewCtrl = [[EncourageMeViewController alloc] initWithNibName:@"EncourageMeViewController" bundle:nil];
        _encourageMeViewCtrl.currentViewController = self;
    }
    return _encourageMeViewCtrl;
}

- (NoticeViewController *)noticeViewCtrl
{
    if (!_noticeViewCtrl) {
        _noticeViewCtrl = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        _noticeViewCtrl.currentViewController = self;
    }
    return _noticeViewCtrl;
}

@end
