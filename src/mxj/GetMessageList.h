//
//  GetMessageList.h
//  mxj
//  私信列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetMessageList : BaseModel

@property(nonatomic, copy)NSString *totalnum;             //总行数
@property(nonatomic, copy)NSString *totalpage;            //总页数
@property(nonatomic, copy)NSArray<GetMessageListInfo *> *info; //私信列表

@end
