//
//  GetMessageListInfo.h
//  mxj
//  私信列表
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMessageListInfo : NSObject

@property(nonatomic, copy) NSString *messageId;    //私信Id
@property(nonatomic, copy) NSString *userId;       //发信者Id
@property(nonatomic, copy) NSString *receiveId;    //收信者Id
@property(nonatomic, copy) NSString *content;      //内容
@property(nonatomic, copy) NSString *status;       //状态(0:未读,1:已读)
@property(nonatomic, copy) NSString *createTime;   //发信时间
@property(nonatomic, copy) NSString *showUserId;   //列表表示者Id
@property(nonatomic, copy) NSString *showUserName; //列表表示者名
@property(nonatomic, copy) NSString *showImage;    //列表表示者头像


//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
