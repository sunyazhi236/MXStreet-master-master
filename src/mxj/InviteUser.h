//
//  InviteUser.h
//  mxj
//  获取邀请信息
//  Created by 齐乐乐 on 15/12/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface InviteUser : BaseModel

@property (nonatomic, copy) NSString *inviteLink;  //邀请内容
@property (nonatomic, copy) NSString *url;         //邀请url

@end
