//
//  ChangePasswordViewController.h
//  mxj
//  P12-3修改密码头文件
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MyTextField *orginPassword;   //原密码输入框
@property (weak, nonatomic) IBOutlet MyTextField *changedPassword; //新密码输入框
@property (weak, nonatomic) IBOutlet MyTextField *confrimPassword; //确认密码框

@end
