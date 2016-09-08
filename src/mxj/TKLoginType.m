//
//  TKLoginType.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "TKLoginType.h"

@implementation TKLoginType

//获取单例
+(instancetype)shareInstance
{
    static TKLoginType *shareInstance = nil;
    
    @synchronized(self) {
        if (!shareInstance) {
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
