//
//  GetMessageInfo.h
//  mxj
//  私信
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMessageInfo : NSObject

@property(nonatomic, copy) NSString *messageId;  //私信Id
@property(nonatomic, copy) NSString *userId;     //发信者Id
@property(nonatomic, copy) NSString *receiveId;  //收信者Id
@property(nonatomic, copy) NSString *content;    //内容
@property(nonatomic, copy) NSString *status;     //状态（0：未读，1：已读）
@property(nonatomic, copy) NSString *createTime; //发信时间

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
