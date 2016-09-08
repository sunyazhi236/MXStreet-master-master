//
//  LogoutInput.h
//  mxj
//  退出登录用输入模型
//  Created by 齐乐乐 on 16/1/8.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface LogoutInput : BaseInput

@property(nonatomic, copy) NSString *userId; //用户Id
+(instancetype)shareInstance;

@end
