//
//  MyBeansRechargeViewController.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBeansRechargeViewController : BaseViewController

/**
 *  毛豆数
 */
@property (nonatomic, assign) NSInteger sum;

- (instancetype)initWithSum:(NSInteger)sum;

@end
