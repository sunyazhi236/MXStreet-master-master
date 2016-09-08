//
//  GetNoticeListInfo.h
//  mxj
//  通知列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetNoticeListInfo : NSObject

@property(nonatomic, copy)NSString *noticeId;       //通知Id
@property(nonatomic, copy)NSString *noticeTitle;    //通知标题
@property(nonatomic, copy)NSString *noticeContent;  //通知内容
@property(nonatomic, copy)NSString *status;         //评论状态（0：未读，1：已读）
@property(nonatomic, copy)NSString *publishTime;    //发布时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
