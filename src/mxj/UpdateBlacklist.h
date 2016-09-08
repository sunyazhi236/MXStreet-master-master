//
//  UpdateBlacklist.h
//  mxj
//  更新黑名单
//  Created by 齐乐乐 on 15/12/2.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface UpdateBlacklist : BaseModel

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
