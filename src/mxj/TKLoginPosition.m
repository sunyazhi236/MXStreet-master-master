//
//  TKLoginPosition.m
//  mxj
//
//  Created by 齐乐乐 on 16/1/5.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "TKLoginPosition.h"

@implementation TKLoginPosition

+(instancetype)shareInstance
{
    static TKLoginPosition *shareInstance = nil;
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
