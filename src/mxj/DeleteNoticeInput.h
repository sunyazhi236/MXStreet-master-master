//
//  DeleteNoticeInput.h
//  mxj
//  清空通知用输入模型
//  Created by 齐乐乐 on 15/12/28.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface DeleteNoticeInput : BaseInput

@property(nonatomic, copy) NSString *userId;  //用户Id

+(instancetype)shareInstance;

@end
