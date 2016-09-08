//
//  GetCountryList.h
//  mxj
//  查询国家列表输出模型
//  Created by 齐乐乐 on 15/12/22.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetCountryList : BaseModel

@property(nonatomic, copy) NSString *totalnum;  //总行数
@property(nonatomic, copy) NSString *totalpage; //总页数
@property(nonatomic, copy) NSArray<GetCountryListInfo *> *info;

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
