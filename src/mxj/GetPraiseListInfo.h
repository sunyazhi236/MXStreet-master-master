//
//  GetPraiseListInfo.h
//  mxj
//  赞我列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPraiseListInfo : NSObject

@property(nonatomic, copy) NSString *streetsnapId; //街拍Id
@property(nonatomic, copy) NSString *photo1;       //街拍首图
@property(nonatomic, copy) NSString *userId;       //用户Id
@property(nonatomic, copy) NSString *userName;     //用户名
@property(nonatomic, copy) NSString *image;        //用户头像
@property(nonatomic, copy) NSString *status;       //状态（0：未读，1：已读）
@property(nonatomic, copy) NSString *createTime;   //点赞时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
