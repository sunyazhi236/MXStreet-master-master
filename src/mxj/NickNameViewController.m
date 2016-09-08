//
//  NickNameViewController.m
//  mxj
//  P12-1-1昵称设置
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
#define kMinLength 4   //最短字符限制
#define kMaxLength 30  //最长字符限制

#import "NickNameViewController.h"

@interface NickNameViewController ()

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"昵称"];
    _userNameTextField.delegate = self;
    
    _userNameTextField.text = [GetUserInfo shareInstance].userName;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_userNameTextField];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:_userNameTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件处理
//取消按钮点击
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//完成按钮点击
- (IBAction)finishBtnClick:(id)sender {
#ifdef OPEN_NET_INTERFACE
    //检查参数
    if ([CustomUtil CheckParam:_userNameTextField.text]) {
        [CustomUtil showToastWithText:@"请输入昵称" view:kWindow];
        return;
    }
    BOOL isInputStrValid = [CustomUtil isInputStrValid:_userNameTextField.text minLength:kMinLength maxLength:kMaxLength];
    if (!isInputStrValid) {
        return;
    }
    [ModifyUserDataInput shareInstance].userName = _userNameTextField.text;
    [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
    [ModifyUserDataInput shareInstance].userSignFlag = @"0";
    [ModifyUserDataInput shareInstance].storeFlag = @"0";
    //调用接口
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
    [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [CustomUtil showToastWithText:returnData.msg view:[UIApplication sharedApplication].keyWindow];
            [LoginModel shareInstance].userName = _userNameTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
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
    [_userNameTextField resignFirstResponder];
    return YES;
}

/*
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    UITextInputMode *currentInputMode = textField.textInputMode;
    NSString *lang = currentInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [CustomUtil showToastWithText:@"最多可输入16个字符" view:kWindow];
            }
        } else {
            //TODO
            
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            [CustomUtil showToastWithText:@"最多可输入16个字符" view:kWindow];
        }
        //TODO
    }
}
 */

/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _userNameTextField) {
        UITextInputMode *inputMode = textField.textInputMode;
        NSString *lang = inputMode.primaryLanguage;
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                BOOL basic = [string isEqualToString:filtered];
                if (NO == basic) {
                    return NO;
                } else {
                    if (toBeString.length > kMaxLength) {
                        [CustomUtil showToastWithText:@"最多可输入16个字符" view:kWindow];
                        return NO;
                    }
                    return YES;
                }
            } else {
                //TODO
                DLog(@"进入这里");
            }
        } else {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basic = [string isEqualToString:filtered];
            if (NO == basic) {
                return NO;
            } else {
                if (toBeString.length > kMaxLength) {
                    [CustomUtil showToastWithText:@"最多可输入16个字符" view:kWindow];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}
 */

@end
