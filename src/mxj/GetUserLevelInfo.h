//
//  GetUserLevelInfo.h
//  mxj
//  查询成长值规则
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetUserLevelInfo : BaseModel

@property(nonatomic, copy) NSArray<GetUserLevelInfoOnceData *> *onceData;
@property(nonatomic, copy) NSArray<GetUserLevelInfoEveryDayData *> *everyDayData;
@property(nonatomic, copy) NSArray<GetUserLevelInfoLevelData *> *levelData;

@end
