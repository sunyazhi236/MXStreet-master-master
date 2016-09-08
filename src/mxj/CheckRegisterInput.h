//
//  CheckRegisterInput.h
//  mxj
//  校验是否已经注册
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface CheckRegisterInput : BaseInput

@property(nonatomic, copy) NSString *phoneNumber;  //手机号
@property(nonatomic, copy) NSString *qqNumber;     //QQ
@property(nonatomic, copy) NSString *webchatId;    //微信
@property(nonatomic, copy) NSString *sinaBlog;     //新浪微博

+(instancetype)shareInstance;

@end
