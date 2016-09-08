//
//  GetUserLevelInfoEveryDayData.h
//  mxj
//  查询用户成长值规则数据二
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserLevelInfoEveryDayData : NSObject

@property(nonatomic, copy) NSString *levelId;    //规则Id
@property(nonatomic, copy) NSString *userAction; //用户行为
@property(nonatomic, copy) NSString *levelInfo;  //说明
@property(nonatomic, copy) NSString *levelValue; //增加值

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
