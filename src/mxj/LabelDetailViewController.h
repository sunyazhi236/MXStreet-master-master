//
//  LabelDetailViewController.h
//  mxj
//
//  Created by shanpengtao on 16/6/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

#define HEADVIEWHEIGH 55

@interface LabelDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *tagName; //标签名称

@property (nonatomic, copy) NSString *tagId;   //标签Id

@property (nonatomic, copy) NSString *totalnum;    //街拍总数

@property (nonatomic, copy) NSString *totalUser;   //标签使用用户数

@property (nonatomic, assign) int type;   //0=默认  1=个人主页进入

@property (nonatomic, copy) NSString *userId;   //个人主页进入需要带userId

@end


