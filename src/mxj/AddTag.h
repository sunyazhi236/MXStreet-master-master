//
//  AddTag.h
//  mxj
//  添加标签
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface AddTag : BaseModel

@property (nonatomic, copy) NSString *tagId; //标签Id

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
