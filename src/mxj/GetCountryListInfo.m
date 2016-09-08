//
//  GetCountryListInfo.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/22.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "GetCountryListInfo.h"

@implementation GetCountryListInfo

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
