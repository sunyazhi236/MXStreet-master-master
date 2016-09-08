//
//  ImageInfo.h
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property float width;
@property float height;
@property (nonatomic,strong) NSString *thumbURL;

//街拍或首页
@property (nonatomic, copy) NSString *streetsnapId;     //街拍Id
@property (nonatomic, copy) NSString *streetsnapContent;//街拍内容
@property (nonatomic, copy) NSString *publishTime;      //发布时间
@property (nonatomic, copy) NSString *userName;         //用户名
@property (nonatomic, copy) NSString *image;            //用户头像
@property (nonatomic, copy) NSString *publishPlace;     //发布位置
@property (nonatomic, copy) NSString *photo1;           //街拍首图
@property (nonatomic, copy) NSString *praiseNum;        //点赞数
@property (nonatomic, copy) NSString *commentNum;       //评论数


//我的收藏
@property (nonatomic, copy) NSString *streetsnapId1;      //街拍Id
@property (nonatomic, copy) NSString *streetsnapContent1; //街拍内容
@property (nonatomic, copy) NSString *publishTime1;       //发布时间
@property (nonatomic, copy) NSString *photo12;            //街拍首图


-(id)initWithDictionary:(NSDictionary*)dictionary;

- (id)initLabelImageWithDictionary:(NSDictionary*)dictionary;

@end
