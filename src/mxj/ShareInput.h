//
//  ShareInput.h
//  mxj
//  分享增加积分
//  Created by 齐乐乐 on 15/12/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface ShareInput : BaseInput

@property (nonatomic, copy) NSString *userId; //用户ID

+(instancetype)shareInstance;
@end
