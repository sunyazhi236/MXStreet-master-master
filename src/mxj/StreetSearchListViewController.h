//
//  StreetSearchListViewController.h
//  mxj
//
//  Created by shanpengtao on 16/5/22.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageWaterView.h"
#import "JSONKit.h"

@interface StreetSearchListViewController : BaseViewController


@property (nonatomic, assign) NSInteger type;

//@[@"棒针",@"钩针",@"缝纫",@"工具"]
- (instancetype)initWithType:(NSInteger)aType;

@end
