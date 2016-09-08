//
//  GetCommentList.h
//  mxj
//  评论列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetCommentList : BaseModel

@property(nonatomic, copy)NSString *totalnum;             //总行数
@property(nonatomic, copy)NSString *totalpage;            //总页数
@property(nonatomic, copy)NSArray<GetCommentListInfo *> *info; //粉丝列表

@end
