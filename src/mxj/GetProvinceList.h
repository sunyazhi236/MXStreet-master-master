//
//  GetProvinceList.h
//  mxj
//  查询省份列表
//  Created by 齐乐乐 on 15/12/8.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetProvinceList : BaseModel

@property(nonatomic, copy) NSString *totalnum;  //总行数
@property(nonatomic, copy) NSString *totalpage; //总页数
@property(nonatomic, copy) NSArray<GetProvinceListInfo *> *info;

@end
