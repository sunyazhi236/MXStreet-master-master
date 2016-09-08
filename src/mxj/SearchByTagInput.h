//
//  SearchByTagInput.h
//  mxj
//  标签查询列表
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface SearchByTagInput : BaseInput

@property(nonatomic, copy) NSString *pagesize;  //每页行数
@property(nonatomic, copy) NSString *current;   //页号
@property(nonatomic, copy) NSString *userId;    //用户Id
@property(nonatomic, copy) NSString *tagId;     //标签Id

+(instancetype)shareInstance;

@end
