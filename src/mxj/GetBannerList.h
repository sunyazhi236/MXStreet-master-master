//
//  GetBannerList.h
//  mxj
//  广告banner列表
//  Created by 齐乐乐 on 15/12/1.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetBannerList : BaseModel

@property(nonatomic, copy) NSString *totalnum;  //总行数
@property(nonatomic, copy) NSString *totalpage; //总页数
@property(nonatomic, copy) NSArray<GetBannerListInfo *> *info;

@end
