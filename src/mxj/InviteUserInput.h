//
//  InviteUserInput.h
//  mxj
//  更新邀请履历
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface InviteUserInput : BaseInput

@property(nonatomic, copy) NSString *userId;       //用户Id

+(instancetype)shareInstance;

@end
