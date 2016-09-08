//
//  SearchInfo.h
//  mxj
//  用户及标签
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchInfo : NSObject

@property(nonatomic, copy) NSString *userId;    //用户Id
@property(nonatomic, copy) NSString *userName;  //用户名
@property(nonatomic, copy) NSString *image;     //用户头像
@property(nonatomic, copy) NSString *tagId;     //标签Id
@property(nonatomic, copy) NSString *tagName;   //标签名

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
