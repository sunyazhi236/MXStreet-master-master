//
//  NSString+Extension.h
//  mxj
//  NSString扩展方法
//  Created by 齐乐乐 on 15/12/31.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/*
 * return 该字符串所占的大小(width, height)
 * font:  该字符串所用的字体
 * maxSize: 限制该字体的最大宽和高（显示一行，则宽高都设置为MAXFLOAT， 如果显示为多行，只需将宽设置一个有限定长值，高设置为MAXFLOAT）
 */
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
