//
//  TKTime.h
//  mxj
//  私信时间模型
//  Created by 齐乐乐 on 16/2/17.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKTime : NSObject

@property(nonatomic, copy) NSString *time;    //时间字符串
@property(nonatomic, assign) BOOL displayFlag; //是否显示标记

+(instancetype)shareInstance;

@end
