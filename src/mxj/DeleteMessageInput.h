//
//  DeleteMessageInput.h
//  mxj
//  删除私信用输入模型
//  Created by 齐乐乐 on 16/2/2.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface DeleteMessageInput : BaseInput

@property(nonatomic, copy) NSString *userId;    //用户Id
@property(nonatomic, copy) NSString *objectId;  //删除聊天对象Id

+(instancetype)shareInstance;

@end
