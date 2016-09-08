//
//  TKPostion.h
//  mxj
//  选择的省份及城市
//  Created by 齐乐乐 on 15/12/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKPostion : NSObject

@property(nonatomic, assign) NSString *countryName;  //国家名称
@property(nonatomic, assign) NSString *provinceName; //省份名称
@property(nonatomic, assign) NSString *cityName;     //城市名称
@property(nonatomic, assign) Boolean  *isArea;     //城市名称

+(instancetype)shareInstance;

@end
