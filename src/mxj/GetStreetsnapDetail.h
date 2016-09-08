//
//  GetStreetsnapDetail.h
//  mxj
//  查询街拍详情
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetStreetsnapDetail : BaseModel

@property(nonatomic, copy) NSMutableArray<CommentInfo *> *commentInfo;
@property(nonatomic, copy) NSMutableArray<PraiseInfo *> *praiseInfo;
@property(nonatomic, copy) NSMutableArray<RewardInfo *> *rewardInfo;
@property(nonatomic, copy) NSMutableArray<TagInfo *> *tagInfo;
@property(nonatomic, copy) NSDictionary *streetsnapInfo;
@property(nonatomic, copy) NSNumber *rewardCount;
@property(nonatomic, copy) NSNumber *praiseCount;
@property(nonatomic, copy) NSNumber *followFlag;

@end
