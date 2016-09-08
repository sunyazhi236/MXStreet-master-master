//
//  GetFansListInfo.h
//  mxj
//  粉丝列表
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetFansListInfo : NSObject

@property(nonatomic, copy)NSString *userId;     //用户Id
@property(nonatomic, copy)NSString *userName;   //用户名
@property(nonatomic, copy)NSString *image;      //用户头像
@property(nonatomic, copy)NSString *relation;   //关系（1：粉丝， 2：互为关注）
@property(nonatomic, copy)NSString *createTime; //关注时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
