//
//  StreetPraiseListViewController.h
//  mxj
//
//  Created by shanpengtao on 16/5/21.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface StreetPraiseListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *listArray;

- (instancetype)initWithStreetsnapId:(NSString *)streetsnapId;

@end
