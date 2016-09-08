//
//  StreetsnapInfo.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "StreetsnapInfo.h"

@implementation StreetsnapInfo

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}


@end
