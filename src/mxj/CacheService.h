//
//  CacheService.h
//  mxj
//  缓存用工具类
//  Created by 齐乐乐 on 16/1/8.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheService : NSObject

//获取单例方法
+(instancetype)shareInstance;

//读取缓存数据
//flag:用于区分子数据
+(NSObject *)readCacheData:(NSString *)viewCtrlName flag:(int)flag;

//保存数据结构及图片
//flag：用于区分子数据 imageFlag:图片保存时的名称后缀数字
+(void)saveDataToSandBox:(NSString *)viewCtrlName data:(NSObject *)data flag:(int)flag imageFlag:(int)imageFlag;

//清空缓存
+(void)removeCacheData;

@end
