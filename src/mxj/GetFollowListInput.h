//
//  GetFollowListInput.h
//  mxj
//  关注的人列表
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetFollowListInput : BaseInput

@property(nonatomic, copy)NSString *pagesize; //每页行数
@property(nonatomic, copy)NSString *current;  //页号
@property(nonatomic, copy)NSString *userId;   //用户id
@property(nonatomic, copy)NSString *currentUserId; //登录用户Id

+(instancetype)shareInstance;

@end
