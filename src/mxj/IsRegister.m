//
//  IsRegister.m
//  mxj
//
//  Created by MQ on 16/5/16.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "IsRegister.h"

@implementation IsRegister

+(instancetype)shareInstance
{
    static IsRegister *shareInstance = nil;
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
