//
//  GetCountryListInfo.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/22.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCountryListInfo : NSObject

@property(nonatomic, copy) NSString *countryId;    //国家ID
@property(nonatomic, copy) NSString *nameEnglish;  //英文名
@property(nonatomic, copy) NSString *nameChinese;  //中文名
@property(nonatomic, copy) NSString *code;         //代码

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
