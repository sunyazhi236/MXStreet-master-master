//
//  PulbishStreetsnap.h
//  mxj
//  发布街拍
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface PublishStreetsnap : BaseModel

@property(nonatomic, copy) NSString *streetsnapId;  //街拍Id

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
