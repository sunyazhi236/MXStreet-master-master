//
//  StreetsnapInfo.h
//  mxj
//  街拍信息
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreetsnapInfo : NSObject

@property(nonatomic, copy) NSString *streetsnapId;      //街拍ID
@property(nonatomic, copy) NSString *streetsnapContent; //街拍内容
@property(nonatomic, copy) NSString *photo1;            //街拍图1
@property(nonatomic, copy) NSString *width1;            //原图宽度1
@property(nonatomic, copy) NSString *height1;           //原图高度1
@property(nonatomic, copy) NSString *photo2;            //街拍图2
@property(nonatomic, copy) NSString *width2;            //原图宽度2
@property(nonatomic, copy) NSString *height2;           //原图高度2
@property(nonatomic, copy) NSString *photo3;            //街拍图3
@property(nonatomic, copy) NSString *width3;            //原图宽度3
@property(nonatomic, copy) NSString *height3;           //原图高度3
@property(nonatomic, copy) NSString *photo4;            //街拍图4
@property(nonatomic, copy) NSString *width4;            //原图宽度4
@property(nonatomic, copy) NSString *height4;           //原图高度4
@property(nonatomic, copy) NSString *userId;            //用户Id
@property(nonatomic, copy) NSString *userName;          //用户名
@property(nonatomic, copy) NSString *image;             //用户头像
@property(nonatomic, copy) NSString *publishPlace;      //发布地点
@property(nonatomic, copy) NSString *city;              //发布城市
@property(nonatomic, copy) NSString *publishTime;       //发布时间
@property(nonatomic, copy) NSString *praiseFlag;        //点赞标识（0：未赞，1：已赞）
@property(nonatomic, copy) NSString *collectionFlag;    //收藏标识（0：未收藏，1：已收藏）
@property(nonatomic, copy) NSString *status;            //发布标识（0：他人发布，1：当前用户发布）

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
