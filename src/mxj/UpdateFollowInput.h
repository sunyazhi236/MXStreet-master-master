//
//  UpdateFollwInput.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/4.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface UpdateFollwInput : BaseInput

@property(nonatomic, copy) NSString *userId;  //用户Id
@property(nonatomic, copy) NSString *fansId;  //粉丝Id
@property(nonatomic, copy) NSString *flag;    //标识（0：关注，1：取消）

+(instancetype)shareInstance;

@end
