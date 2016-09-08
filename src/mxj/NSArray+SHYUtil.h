//
//  NSArray+SHYUtil.h
//  mxj
//  NSArray的扩展方法
//  Created by 齐乐乐 on 16/2/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SHYUtil)

/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end
