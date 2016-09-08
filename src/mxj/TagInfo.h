//
//  TagInfo.h
//  mxj
//  标签信息
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagInfo : NSObject

@property(nonatomic, copy) NSString *tagId;       //标签ID
@property(nonatomic, copy) NSString *tagName;     //标签名
@property(nonatomic, copy) NSString *photoNo;     //街拍图号
@property(nonatomic, copy) NSString *horizontal;  //横坐标
@property(nonatomic, copy) NSString *vertical;    //纵坐标
@property(nonatomic, copy) NSString *link;        //链接

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
