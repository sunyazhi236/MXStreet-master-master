//
//  GetStreetsnapList.h
//  mxj
//  街拍列表
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"
#import "Info.h"

@interface GetStreetsnapList : BaseModel

@property(nonatomic, copy)NSString *totalnum;  //总行数
@property(nonatomic, copy)NSString *totalpage; //总页数
@property(nonatomic, copy)NSMutableArray<Info *>  *info;  //街拍列表

@end
