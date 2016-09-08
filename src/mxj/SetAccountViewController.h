//
//  SetAccountViewController.h
//  mxj
//  P4-2注册-设置账号和密码头文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

@interface SetAccountViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField; //手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField; //密码输入框


@end
