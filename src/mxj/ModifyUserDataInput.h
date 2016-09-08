//
//  ModifyUserDataInput.h
//  mxj
//  用户修改信息
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface ModifyUserDataInput : BaseInput

@property(nonatomic, copy) NSString *image;      //头像
@property(nonatomic, copy) NSString *backgroundImage; //背景图
@property(nonatomic, copy) NSString *userId;     //用户
@property(nonatomic, copy) NSString *userName;   //用户昵称
@property(nonatomic, copy) NSString *fullName;   //用户姓名
@property(nonatomic, copy) NSString *sex;        //性别
@property(nonatomic, copy) NSString *country;    //国家（中国不传）
@property(nonatomic, copy) NSString *province;   //省份
@property(nonatomic, copy) NSString *city;       //城市
@property(nonatomic, copy) NSString *store;      //店铺
@property(nonatomic, copy) NSString *birthday;   //生日
@property(nonatomic, copy) NSString *userSign;   //用户签名
@property(nonatomic, copy) NSString *pushMessage; //推送消息开关
@property(nonatomic, copy) NSString *guanzhuMessage; //关注消息开关
@property(nonatomic, copy) NSString *userSignFlag; //用户签名删除标识(0:未删除 1:删除)
@property(nonatomic, copy) NSString *storeFlag;    //店铺删除标识(0:未删除 1:删除)

+(instancetype)shareInstance;

@end
