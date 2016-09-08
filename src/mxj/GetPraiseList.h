//
//  GetPraiseList.h
//  mxj
//  赞我列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetPraiseList : BaseModel

@property(nonatomic, copy) NSString *totalnum;
@property(nonatomic, copy) NSString *totalpage;
@property(nonatomic, copy) NSArray<GetPraiseListInfo *> *info;

@end
