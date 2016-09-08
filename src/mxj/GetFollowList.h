//
//  GetFollowList.h
//  mxj
//  关注的人列表
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"
#import "GetFollowListInfo.h"

@interface GetFollowList : BaseModel

@property(nonatomic, copy)NSString *totalnum;               //总行数
@property(nonatomic, copy)NSString *totalpage;              //总页数
@property(nonatomic, copy)NSArray<GetFollowListInfo *> *info; //关注的人列表

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
