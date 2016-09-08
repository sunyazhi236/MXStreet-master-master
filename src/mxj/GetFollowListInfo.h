//
//  GetFollowListInfo.h
//  mxj
//  关注的人列表结构体
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//
@interface GetFollowListInfo : NSObject

@property(nonatomic, copy)NSString *userId;     //用户Id
@property(nonatomic, copy)NSString *userName;   //用户名
@property(nonatomic, copy)NSString *image;      //用户头像
@property(nonatomic, copy)NSString *relation;   //关系(1:关注 2:互为关注)
@property(nonatomic, copy)NSString *createTime; //关注时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
