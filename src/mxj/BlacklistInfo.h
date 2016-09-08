//
//  BlacklistInfo.h
//  mxj
//  黑名单信息
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlacklistInfo : NSObject

@property(nonatomic, copy)NSString *userId;     //用户Id
@property(nonatomic, copy)NSString *image;      //用户头像
@property(nonatomic, copy)NSString *userName;   //用户昵称
@property(nonatomic, copy)NSString *createTime; //拉黑时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
