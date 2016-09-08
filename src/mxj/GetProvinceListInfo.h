//
//  GetProvinceListInfo.h
//  mxj
//  查询省份列表详情
//  Created by 齐乐乐 on 15/12/8.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetProvinceListInfo : NSObject

@property (nonatomic, copy) NSString *provinceId;    //省份ID
@property (nonatomic, copy) NSString *provinceName;  //省份名

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
