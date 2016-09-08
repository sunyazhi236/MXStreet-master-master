//
//  LoginModel.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

static LoginModel *shareInstance = nil;

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if ([LoginModel shareInstance]) {
        [shareInstance setValuesForKeysWithDictionary:dict];
        if ((nil != [dict objectForKey:@"data"]) && (NO == [@"" isEqualToString:[dict objectForKey:@"data"]])) {
            [shareInstance setValuesForKeysWithDictionary:[dict objectForKey:@"data"]];
        }
    }
    return shareInstance;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
//获取单例
+(instancetype)shareInstance
{
    @synchronized(self) {
        if (!shareInstance) {
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
}

@end
