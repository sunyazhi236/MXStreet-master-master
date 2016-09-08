//
//  GetCityListInput.h
//  mxj
//  查询城市列表
//  Created by 齐乐乐 on 15/12/8.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetCityListInput : BaseInput

@property(nonatomic, copy) NSString *pagesize;    //每页行数
@property(nonatomic, copy) NSString *current;     //页号
@property(nonatomic, copy) NSString *provinceId;  //省份ID

+(instancetype)shareInstance;

@end
