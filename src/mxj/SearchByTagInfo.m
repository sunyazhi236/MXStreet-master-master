//
//  SearchByTagInfo.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SearchByTagInfo.h"

@implementation SearchByTagInfo

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
