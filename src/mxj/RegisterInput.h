//
//  RegisterInput.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/25.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

@interface RegisterInput : BaseInput
@property(nonatomic, copy) NSString *image;        //头像
@property(nonatomic, copy) NSString *phoneNumber;  //电话
@property(nonatomic, copy) NSString *userName;     //用户名
@property(nonatomic, copy) NSString *sex;          //性别
@property(nonatomic, copy) NSString *userPassword; //密码(MD5加密）
@property(nonatomic, copy) NSString *country;      //国家
@property(nonatomic, copy) NSString *province;     //省
@property(nonatomic, copy) NSString *city;         //市
@property(nonatomic, copy) NSString *store;        //店铺
@property(nonatomic, copy) NSString *qqNumber;     //QQ
@property(nonatomic, copy) NSString *webchatId;    //微信
@property(nonatomic, copy) NSString *sinaBlog;     //新浪微博
@property(nonatomic, copy) NSString *source;       //来源 0:微信 1:QQ 2:手机 3:微博
@property(nonatomic, copy) NSString *registerId;   //极光推送设备号
@property(nonatomic, copy) NSString *phoneType;    //0:iOS 1：安卓
@property(nonatomic, copy) NSString *authNumber;   //验证码

+(instancetype)shareInstance;

@end
