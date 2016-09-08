//
//  TKLoginType.h
//  mxj
//  正常账户登录或随便看看用标志模型
//  Created by 齐乐乐 on 15/12/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKLoginType : NSObject

@property(nonatomic, assign) BOOL loginType; //正常登录或随便看看标记 YES:账户登录 NO:随便看看

+(instancetype)shareInstance; //获取单例方法

@end
