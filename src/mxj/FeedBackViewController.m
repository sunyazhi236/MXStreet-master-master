//
//  FeedBackViewController.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"意见反馈"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
    [self.feedBackBackImage addGestureRecognizer:gesture];
    _contactMethodTextField.delegate = self;
    _feedBackTextView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomUtil shareInstance].view = self.view;
    [[CustomUtil shareInstance] registerKeyBoardNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CustomUtil shareInstance] removeKeyBoardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
//空白区域点击事件处理
-(void)backImageClick
{
    //隐藏键盘
    [_feedBackTextView resignFirstResponder];
    [_contactMethodTextField resignFirstResponder];
}

//提交按钮点击
- (IBAction)submitBtnClick:(id)sender {
#ifdef OPEN_NET_INTERFACE
    //检查参数
    if ([CustomUtil CheckParam:_feedBackTextView.text]) {
        [CustomUtil showToastWithText:@"请输入意见" view:kWindow];
        return;
    }
    //检查联系方式是否合法
    if (![CustomUtil CheckParam:_contactMethodTextField.text]) {
        NSString *regex = @"[A-Za-z0-9_.@]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![pred evaluateWithObject:_contactMethodTextField.text]) {
            [CustomUtil showToastWithText:@"请输入有效的联系方式" view:kWindow];
            return;
        }
    }
    
    //提交数据
    [SaveFeedbackInput shareInstance].userId = [LoginModel shareInstance].userId;
    [SaveFeedbackInput shareInstance].userName = [LoginModel shareInstance].userName;
    if ([CustomUtil CheckParam:_contactMethodTextField.text]) {
        [SaveFeedbackInput shareInstance].phoneNumber = @"";
    } else {
        [SaveFeedbackInput shareInstance].phoneNumber = _contactMethodTextField.text;
    }
    [SaveFeedbackInput shareInstance].feedbackDetail = _feedBackTextView.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SaveFeedbackInput shareInstance]];
    [[NetInterface shareInstance] saveFeedback:@"saveFeedback" param:dict successBlock:^(NSDictionary *responseDict) {
        SaveFeedback *saveFeedback = [SaveFeedback modelWithDict:responseDict];
        if (RETURN_SUCCESS(saveFeedback.status)) {
            [CustomUtil showToastWithText:saveFeedback.msg view:kWindow];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CustomUtil showToastWithText:saveFeedback.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
        
    }];
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

#pragma mark -TextFiled代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contactMethodTextField resignFirstResponder];
    return YES;
}

@end
