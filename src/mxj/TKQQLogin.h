//
//  TKQQLogin.h
//  mxj
//  qq登录成功数据模型
//  Created by 齐乐乐 on 15/12/14.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKQQLogin : NSObject

@property (nonatomic, copy) NSString *openId; //唯一标示符
@property (nonatomic, copy) NSString *token;  //token
@property (nonatomic, strong) NSDate *expirationDate; //token过期时间

+ (instancetype)shareInstance;

@end
