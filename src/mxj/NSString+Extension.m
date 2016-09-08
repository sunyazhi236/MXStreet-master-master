//
//  NSString+Extension.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/31.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//返回字符串所占用的尺寸
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
