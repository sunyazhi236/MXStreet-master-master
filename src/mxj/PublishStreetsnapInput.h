//
//  PublishStreetsnapInput.h
//  mxj
//  发布街拍
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface PublishStreetsnapInput : BaseInput

@property(nonatomic, copy) NSString *photo1;                //街拍首图
@property(nonatomic, copy) NSString *photo2;                //街拍图2
@property(nonatomic, copy) NSString *photo3;                //街拍图3
@property(nonatomic, copy) NSString *photo4;                //街拍图4
@property(nonatomic, copy) NSString *streetsnapContent;     //街拍内容
@property(nonatomic, copy) NSString *userId;                //用户Id
@property(nonatomic, copy) NSString *publishPlace;          //发布位置（不含城市，仅具体地址）
@property(nonatomic, copy) NSString *city;                  //发布位置城市

+(instancetype)shareInstance;

@end
