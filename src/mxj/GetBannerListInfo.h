//
//  GetBannerListInfo.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/1.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBannerListInfo : NSObject

@property(nonatomic, copy) NSString *bannerId;    //广告Id
@property(nonatomic, copy) NSString *bannerTitle; //广告标题
@property(nonatomic, copy) NSString *bannerImg;   //广告图片
@property(nonatomic, copy) NSString *sort;        //顺序
@property(nonatomic, copy) NSString *bannerLink;  //超链接

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
