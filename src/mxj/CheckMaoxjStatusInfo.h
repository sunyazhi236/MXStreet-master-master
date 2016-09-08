//
//  CheckMaoxjStatusInfo.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckMaoxjStatusInfo : NSObject

@property(nonatomic, copy)NSString *searchId;        //手机号或QQ号等
@property(nonatomic, copy)NSString *userId;          //用户Id
@property(nonatomic, copy)NSString *userName;        //用户名
@property(nonatomic, copy)NSString *image;           //用户头像
@property(nonatomic, copy)NSString *status;          //状态（0：非用户， 1：用户）

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
