//
//  UpdateBlacklistInput.h
//  mxj
//  更新黑名单
//  Created by 齐乐乐 on 15/12/2.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface UpdateBlacklistInput : BaseInput

@property(nonatomic, copy) NSString *userId;      //用户Id
@property(nonatomic, copy) NSString *blacklistId; //黑名单用户Id
@property(nonatomic, copy) NSString *flag;        //标识(0:拉黑，1：移除）

+(instancetype)shareInstance;

@end
