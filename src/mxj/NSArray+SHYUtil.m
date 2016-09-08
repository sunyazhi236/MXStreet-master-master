//
//  NSArray+SHYUtil.m
//  mxj
//  
//  Created by 齐乐乐 on 16/2/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "NSArray+SHYUtil.h"

@implementation NSArray (SHYUtil)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
