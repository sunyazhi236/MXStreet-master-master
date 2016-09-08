//
//  GetCityListInfo.h
//  mxj
//  城市列表详情
//  Created by 齐乐乐 on 15/12/8.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCityListInfo : NSObject

@property (nonatomic, copy) NSString *cityId;     //城市ID
@property (nonatomic, copy) NSString *cityName;   //城市名

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
