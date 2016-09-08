//
//  GetUnreadNum.h
//  mxj
//  查询新消息数
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetUnreadNum : BaseModel

@property(nonatomic, copy)NSString *userId;     //用户ID
@property(nonatomic, copy)NSString *commentNum; //未读评论数
@property(nonatomic, copy)NSString *noticeNum;  //未读通知数
@property(nonatomic, copy)NSString *messageNum; //未读私信数
@property(nonatomic, copy)NSString *praiseNum;  //未读点赞数

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;
//获取单例
+(instancetype)shareInstance;

@end
