//
//  GetBlacklist.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetBlacklist : BaseModel

@property(nonatomic, copy) NSString *totalnum;
@property(nonatomic, copy) NSString *totalpage;
@property(nonatomic, copy) NSArray<BlacklistInfo *> *info; //黑名单信息

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
