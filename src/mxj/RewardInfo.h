//
//  RewardInfo.h
//  mxj
//
//  Created by shanpengtao on 16/6/5.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXJBaseModel.h"

@interface RewardInfo : MXJBaseModel

@property(nonatomic, copy) NSString *userId;        //用户ID
@property(nonatomic, copy) NSString *userName;      //用户名
@property(nonatomic, copy) NSString *image;         //用户头像
@property(nonatomic, copy) NSString *createTime;    //打赏时间
@property(nonatomic, copy) NSString *userSign;      //打赏用户的个性签名
@property(nonatomic, copy) NSNumber *followFlag;    //关注标识(0:未关注， 1：已关注，2：互相关注）

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
