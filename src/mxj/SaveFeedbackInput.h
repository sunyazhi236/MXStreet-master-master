//
//  SaveFeedback.h
//  mxj
//  保存反馈意见
//  Created by 齐乐乐 on 15/11/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface SaveFeedbackInput : BaseInput

@property(nonatomic, copy) NSString *userId;          //用户Id
@property(nonatomic, copy) NSString *userName;        //用户昵称
@property(nonatomic, copy) NSString *phoneNumber;     //联系方式
@property(nonatomic, copy) NSString *feedbackDetail;  //意见详情

+(instancetype)shareInstance;

@end
