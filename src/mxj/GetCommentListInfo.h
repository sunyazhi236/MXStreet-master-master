//
//  GetCommentListInfo.h
//  mxj
//  评论列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCommentListInfo : NSObject

@property(nonatomic, copy) NSString *commentId;         //评论Id
@property(nonatomic, copy) NSString *commentContent;    //评论内容
@property(nonatomic, copy) NSString *status;            //评论状态（0：未读， 1：已读）
@property(nonatomic, copy) NSString *commentTime;       //评论时间
@property(nonatomic, copy) NSString *streetsnapContent; //街拍内容
@property(nonatomic, copy) NSString *userId;            //评论用户Id
@property(nonatomic, copy) NSString *userName;          //评论用户名
@property(nonatomic, copy) NSString *image;             //评论用户头像
@property(nonatomic, copy) NSString *flag;              //评论标识（0：评论当前用户街拍，1：评论当前用户评论）
@property(nonatomic, copy) NSString *photo1;            //评论首图
@property(nonatomic, copy) NSString *streetsnapId;
//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
