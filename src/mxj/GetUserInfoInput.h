//
//  GetUserInfo.h
//  mxj
//  查询用户信息
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetUserInfoInput : BaseInput

@property(nonatomic, copy) NSString *userId;        //查询用户ID
@property(nonatomic, copy) NSString *currentUserId; //当前用户ID

+(instancetype)shareInstance;

@end
