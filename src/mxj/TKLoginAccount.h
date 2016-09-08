//
//  TKLoginAccount.h
//  mxj
//  登录账户信息
//  Created by 齐乐乐 on 15/12/25.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKLoginAccount : NSObject

@property (nonatomic, copy) NSString *phoneNum; //登录手机号
@property (nonatomic, copy) NSString *password; //登录密码(非MD5格式)

+(instancetype)shareInstance;

@end
