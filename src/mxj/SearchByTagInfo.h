//
//  SearchByTagInfo.h
//  mxj
//  标签查询列表
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXJBaseModel.h"

@interface SearchByTagInfo : MXJBaseModel

@property(nonatomic, copy) NSString *streetsnapId;  //街拍ID
@property(nonatomic, copy) NSString *photo1;       //街拍首图
@property(nonatomic, copy) NSString *publishTime;  //发布时间
@property(nonatomic, copy) NSString *userId;       //用户Id
@property(nonatomic, copy) NSString *userName;     //用户名
@property(nonatomic, copy) NSString *image;        //用户头像
@property(nonatomic, copy) NSString *status;       //状态（1：已赞， 0：未赞）


@property(nonatomic, copy) NSString *commentNum;    //评论个数
@property(nonatomic, copy) NSString *praiseNum;     //点赞个数
@property(nonatomic, copy) NSString *streetsnapContent;  //发布内容

//用字典初始化模型实例方法
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
