//
//  SendMessageInput.h
//  mxj
//  发送私信
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface SendMessageInput : BaseInput

@property(nonatomic, copy) NSString *userId;    //用户Id
@property(nonatomic, copy) NSString *receiveId; //收信者Id
@property(nonatomic, copy) NSString *content;   //私信内容

+(instancetype)shareInstance;

@end
