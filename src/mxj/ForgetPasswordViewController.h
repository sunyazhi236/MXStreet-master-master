//
//  ForgetPasswordViewController.h
//  mxj
//  P5_1忘记密码头文件
//  Created by 齐乐乐 on 15/11/10.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgetPasswordViewController : BaseViewController

@property(nonatomic, copy) NSString *phoneNum; //电话号码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;         //新密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;  //确认新密码

@end
