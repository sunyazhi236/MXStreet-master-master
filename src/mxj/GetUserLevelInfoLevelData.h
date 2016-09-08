//
//  GetUserLevelInfoLevelData.h
//  mxj
//  查询用户成长值规则数据三
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserLevelInfoLevelData : NSObject

@property(nonatomic, copy) NSString *gradeId;   //等级Id
@property(nonatomic, copy) NSString *gradeName; //等级名
@property(nonatomic, copy) NSString *gradeDesc; //等级说明
@property(nonatomic, copy) NSString *gradePoint; //等级需要分数

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
