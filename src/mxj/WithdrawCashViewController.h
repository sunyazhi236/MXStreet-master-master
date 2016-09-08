//
//  WithdrawCashViewController.h
//  mxj
//
//  Created by shanpengtao on 16/7/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^withdrawBlock)();

@interface WithdrawCashViewController : BaseViewController

/**
 *  毛豆数
 */
@property (nonatomic, assign) NSInteger sum;

@property (nonatomic, copy) withdrawBlock aBlock;

- (instancetype)initWithSum:(NSInteger)sum;

@end
