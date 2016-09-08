//
//  ModifyPasswordInput.h
//  mxj
//  修改密码
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface ModifyPasswordInput : BaseInput

@property(nonatomic, copy) NSString *phoneNumber;   //电话号码
@property(nonatomic, copy) NSString *oldPassword;   //旧密码(MD5加密）
@property(nonatomic, copy) NSString *userPassword;  //密码(MD5加密）

+(instancetype)shareInstance;

@end
