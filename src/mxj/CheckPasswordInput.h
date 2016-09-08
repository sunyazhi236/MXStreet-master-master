//
//  CheckPasswordInput.h
//  mxj
//  校验密码是否变更用输入模型
//  Created by 齐乐乐 on 16/1/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface CheckPasswordInput : BaseInput

@property(nonatomic, copy) NSString *phoneNumber; //手机号
@property(nonatomic, copy) NSString *userPassword; //密码（MD5加密）

+(instancetype)shareInstance;

@end
