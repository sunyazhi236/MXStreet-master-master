//
//  GetUnreadNum.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/30.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "GetUnreadNum.h"

@implementation GetUnreadNum

static GetUnreadNum *shareInstance = nil;

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    @synchronized(self) {
        self = [super init];
        shareInstance = self;
    }
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        if ((nil != [dict objectForKey:@"data"]) && (NO == [@"" isEqualToString:[dict objectForKey:@"data"]])) {
            [self setValuesForKeysWithDictionary:[dict objectForKey:@"data"]];
        }
    }
    return self;
}

//获取单例
+(instancetype)shareInstance
{
    return shareInstance;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
