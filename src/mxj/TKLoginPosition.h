//
//  TKLoginPosition.h
//  mxj
//  定位城市用模型
//  Created by 齐乐乐 on 16/1/5.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKLoginPosition : NSObject

@property(nonatomic, copy) NSString *cityName; //定位城市名称

+(instancetype)shareInstance;

@end
