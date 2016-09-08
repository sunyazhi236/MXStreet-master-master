//
//  TKTime.m
//  mxj
//
//  Created by 齐乐乐 on 16/2/17.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "TKTime.h"

@implementation TKTime

+(instancetype)shareInstance
{
    static TKTime *shareInstance = nil;
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
