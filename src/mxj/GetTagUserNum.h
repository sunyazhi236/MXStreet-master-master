//
//  GetTagUserNum.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetTagUserNum : BaseModel

@property(nonatomic, copy) NSString *userNum; //该标签使用用户数
@property(nonatomic, copy) NSString *tagName; //标签名

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
