//
//  TKWeixinLogin.h
//  mxj
//  微信登录数据模型
//  Created by 齐乐乐 on 15/12/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKWeixinLogin : NSObject

@property (nonatomic, copy) NSString *code;       //微信code
@property (nonatomic, copy) NSString *openId;     //用户唯一标示符
@property (nonatomic, copy) NSString *token;      //微信token
@property (nonatomic, copy) NSString *nickName;   //昵称
@property (nonatomic, copy) NSString *headimgurl; //微信头像

+(instancetype)shareInstance;

@end
