//
//  GetCollectionListInfo.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//
@interface GetCollectionListInfo : NSObject

@property(nonatomic, copy)NSString *streetsnapId;      //街拍Id
@property(nonatomic, copy)NSString *streetsnapContent; //街拍内容
@property(nonatomic, copy)NSString *publishTime;       //发布时间
@property(nonatomic, copy)NSString *photo1;            //街拍首图

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
