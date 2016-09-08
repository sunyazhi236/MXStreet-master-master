//
//  MXJBaseModel.h
//  mxj
//
//  Created by shanpengtao on 16/6/11.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXJBaseModel : NSObject

- (id)initWithDictionary:(NSDictionary *)jsonObject;

/**
 *  将数据Model转换为字典
 *
 *  @return 返回转换后的字典对象
 */
- (NSDictionary *)modelToDictionary;

- (void)objectFromDictionary:(NSDictionary*)dict;

/*
 * 返回obj所有keypath   字符串数组
 */
- (NSArray *)allKeys;


@end
