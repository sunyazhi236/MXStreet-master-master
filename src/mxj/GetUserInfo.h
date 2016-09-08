//
//  GetUserInfo.h
//  mxj
//  查询用户信息
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetUserInfo : BaseModel

@property(nonatomic, copy) NSString *userId;      //用户ID
@property(nonatomic, copy) NSString *userDoorId;  //门牌号
@property(nonatomic, copy) NSString *userName;    //昵称
@property(nonatomic, copy) NSString *userLevel;   //用户级别
@property(nonatomic, copy) NSString *userPoint;   //用户积分
@property(nonatomic, copy) NSString *fullName;    //会员姓名
@property(nonatomic, copy) NSString *sex;         //性别
@property(nonatomic, copy) NSString *phoneNumber; //手机号码
@property(nonatomic, copy) NSString *country;     //所属国家
@property(nonatomic, copy) NSString *province;    //所属省
@property(nonatomic, copy) NSString *city;        //所属市
@property(nonatomic, copy) NSString *store;       //店铺
@property(nonatomic, copy) NSString *qqNumber;    //QQ号
@property(nonatomic, copy) NSString *webchatId;   //微信号
@property(nonatomic, copy) NSString *sinaBlog;    //新浪微博
@property(nonatomic, copy) NSString *birthday;    //出生年月
@property(nonatomic, copy) NSString *userSign;    //个性签名
@property(nonatomic, copy) NSString *image;           //用户头像
@property(nonatomic, copy) NSString *backgroundImage; //背景图
@property(nonatomic, copy) NSString *pushMessage; //信息推送
@property(nonatomic, copy) NSString *fansNum;     //粉丝数
@property(nonatomic, copy) NSString *followNum;   //关注数
@property(nonatomic, copy) NSString *userPassword; //用户密码
@property(nonatomic, copy) NSString *followFlag;   //关注标识(0:未关注， 1：已关注）
@property(nonatomic, copy) NSString *createTime;   //注册时间
@property(nonatomic, copy) NSString *lessPoint;    //剩余积分

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
