//
//  StreetRewardListViewController.h
//  mxj
//
//  Created by shanpengtao on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface StreetRewardListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *listArray;

- (instancetype)initWithStreetsnapId:(NSString *)streetsnapId;

@end
