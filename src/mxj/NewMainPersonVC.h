//
//  NewMainPersonVC.h
//  mxj
//
//  Created by MQ-MacBook on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMainPersonVC : BaseViewController

@property (nonatomic,  copy) NSString               *userId;  //用户Id
@property (nonatomic, assign) NSInteger             type; //来源 0，我的主页 1，别人的主页

@end
