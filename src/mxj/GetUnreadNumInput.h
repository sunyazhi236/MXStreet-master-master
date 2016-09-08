//
//  GetUnreadNumInput.h
//  mxj
//  查询新消息数
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetUnreadNumInput : BaseInput

@property (nonatomic, copy) NSString *userId; //用户ID

+(instancetype)shareInstance;

@end

