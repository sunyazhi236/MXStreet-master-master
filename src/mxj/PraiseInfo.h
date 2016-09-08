//
//  PraiseInfo.h
//  mxj
//  点赞信息
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXJBaseModel.h"

@interface PraiseInfo : MXJBaseModel
//{
//    "createTime": "2016-06-10 00:30:33",
//    "USER_SIGN": "难得糊涂",
//    "status": "0",
//    "userId": "f21e3f77-9099-4af9-87b0-52d570cca873",
//    "userName": "vc妈妈",
//    "image": "/maoxj/upload/image/2016-05-19/14ca1900-4298-4397-8c65-f7aed13d96c6.jpg"
//},

@property(nonatomic, copy) NSString *userId;        //用户ID
@property(nonatomic, copy) NSString *userName;      //用户名
@property(nonatomic, copy) NSString *image;         //用户头像
@property(nonatomic, copy) NSString *status;        //点赞状态（0：未读，1：已读）
@property(nonatomic, copy) NSString *createTime;    //点赞时间
@property(nonatomic, copy) NSString *USER_SIGN;     //打赏用户的个性签名
@property(nonatomic, copy) NSNumber *followFlag;    //关注标识(0:未关注， 1：已关注，2：互相关注）

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
