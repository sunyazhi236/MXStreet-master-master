//
//  TKWeiboLogin.h
//  mxj
//  微博登录模型数据
//  Created by 齐乐乐 on 15/12/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"

@interface TKWeiboLogin : NSObject

@property(nonatomic, copy) NSString *token;  //微博token
@property(nonatomic, copy) NSString *uid;    //用户唯一标识
@property(nonatomic, copy) NSString *name;   //昵称
@property(nonatomic, copy) NSString *image;  //头像
@property(nonatomic, strong) NSMutableArray *userArray; //好友数组

+(instancetype)shareInstance;

@end
