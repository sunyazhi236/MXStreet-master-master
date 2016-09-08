//
//  GetPopTagListInfo.h
//  mxj
//  标签热门标签列表
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPopTagListInfo : NSObject

@property(nonatomic, copy) NSString *tagId;      //标签ID
@property(nonatomic, copy) NSString *tagName;    //标签名
@property(nonatomic, copy) NSString *tagUseNum;  //标签使用数

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
