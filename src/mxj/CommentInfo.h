//
//  CommentInfo.h
//  mxj
//  评论信息
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property(nonatomic, copy) NSString *commentId;       //评论ID
@property(nonatomic, copy) NSString *commentContent;  //评论内容
@property(nonatomic, copy) NSString *commentTime;     //评论时间
@property(nonatomic, copy) NSString *status;          //评论状态（0：未读，1：已读）
@property(nonatomic, copy) NSString *userId;          //评论者Id
@property(nonatomic, copy) NSString *userName;        //评论者用户名
@property(nonatomic, copy) NSString *image;           //评论者头像
@property(nonatomic, copy) NSString *replyName;       //评论回复对象名

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
