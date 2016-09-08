//
//  LoginInput.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/28.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

@interface LoginInput : BaseInput

@property(nonatomic, copy) NSString *phoneNumber;  //手机号
@property(nonatomic, copy) NSString *userPassword; //密码
@property(nonatomic, copy) NSString *qqNumber;     //QQ
@property(nonatomic, copy) NSString *webchatId;    //微信
@property(nonatomic, copy) NSString *sinaBlog;     //新浪微博
@property(nonatomic, copy) NSString *userName;     //用户名
@property(nonatomic, copy) NSString *registerId;   //极光推送设备号
@property(nonatomic, copy) NSString *phoneType;    //设备类型 0:iOS 1:安卓
@property(nonatomic, copy) NSString *verison;
+(instancetype)shareInstance;

@end
