//
//  SearchInput.h
//  mxj
//  用户及标签
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface SearchInput : BaseInput

@property(nonatomic, copy) NSString *pagesize;   //每页行数
@property(nonatomic, copy) NSString *current;    //页号
@property(nonatomic, copy) NSString *type;       //标识（0：用户查询，1：标签查询）
@property(nonatomic, copy) NSString *userName;   //用户名（模糊查询）
@property(nonatomic, copy) NSString *tagName;    //标签名（模糊查询）
@property(nonatomic, copy) NSString *userDoorId; //门牌号 (模糊查询)

+(instancetype)shareInstance;

@end
