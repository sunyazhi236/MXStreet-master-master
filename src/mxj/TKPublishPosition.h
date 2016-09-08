//
//  TKPublishPosition.h
//  mxj
//  发布街拍用位置信息模型
//  Created by 齐乐乐 on 15/12/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKPublishPosition : NSObject

@property(nonatomic, copy) NSString *cityName;     //城市名称
@property(nonatomic, copy) NSString *positionName; //位置名称

+(instancetype)shareInstance;

@end
