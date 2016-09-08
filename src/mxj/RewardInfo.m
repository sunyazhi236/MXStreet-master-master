//
//  RewardInfo.m
//  mxj
//
//  Created by shanpengtao on 16/6/5.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "RewardInfo.h"

@implementation RewardInfo

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        [self objectFromDictionary:dict];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
