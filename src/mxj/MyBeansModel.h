//
//  MyBeansModel.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBeansModel : MXJBaseModel

@property (nonatomic, strong) NSString  *day;

@property (nonatomic, strong) NSString  *time;

/**
 *  type =
    1 充值
    2 打赏
    3 发红包
    4 领取红包
    5 红包退回余额
    6 提现
    7 提现退回
    8 被打赏
    9 签到
 */
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString  *userName;

@property (nonatomic, strong) NSString  *userId;

@property (nonatomic, strong) NSString  *sortId;

@property (nonatomic, strong) NSNumber  *realMoney;

@property (nonatomic, strong) NSNumber  *sum;

@property (nonatomic, strong) NSString  *streetsnapName;

@end
