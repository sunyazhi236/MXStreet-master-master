//
//  BaseModel.h
//  mxj
//  模型基类
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property(nonatomic, copy) NSString *status; //返回状态 1:成功 0:失败
@property(nonatomic, copy) NSString *msg;    //返回消息
@property(nonatomic, copy) NSString *data;   //返回数据

- (void)objectFromDictionary:(NSDictionary*)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;  //用字典初始化模型实例方法

+(instancetype)modelWithDict:(NSDictionary *)dict; //用字典初始化模型类方法

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString; //将json字符串转换为字典

@end
