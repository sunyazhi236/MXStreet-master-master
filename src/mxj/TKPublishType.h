//
//  TKPublishType.h
//  mxj
//  发布方式标记
//  Created by 齐乐乐 on 15/12/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKPublishType : NSObject

@property (nonatomic, assign) BOOL publishType; //发布方式 YES:个人主页发布 NO:街拍发布

+(instancetype)shareInstance;

@end
