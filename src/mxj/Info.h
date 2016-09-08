//
//  Info.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MXJBaseModel.h"

@interface Info : MXJBaseModel

@property(nonatomic, copy)NSString *streetsnapId; //街拍Id
@property(nonatomic, copy)NSString *streetsnapContent; //街拍内容
@property(nonatomic, copy)NSString *publishTime; //发布时间
@property(nonatomic, copy)NSString *userName;    //用户名
@property(nonatomic, copy)NSString *image;       //用户头像
@property(nonatomic, copy)NSString *city;        //用户城市
@property(nonatomic, copy)NSString *photo1;      //街拍首图
@property(nonatomic, copy)NSString *praiseNum;   //点赞数
@property(nonatomic, copy)NSString *commentNum;  //评论数

@end
