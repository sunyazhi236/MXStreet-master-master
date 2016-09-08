//
//  NickNameViewController.h
//  mxj
//  P12-1-1昵称设置
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface NickNameViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MyTextField *userNameTextField; //用户昵称

@end
