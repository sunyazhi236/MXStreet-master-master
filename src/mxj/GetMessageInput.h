//
//  GetMessageInput.h
//  mxj
//  私信内容
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetMessageInput : BaseInput

@property(nonatomic, copy) NSString *pagesize; //每页行数
@property(nonatomic, copy) NSString *current;  //页号
@property(nonatomic, copy) NSString *userId;   //用户Id
@property(nonatomic, copy) NSString *targetId; //聊天对象用户Id

+(instancetype)shareInstance;

@end
