//
//  TKLoginAccount.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/25.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "TKLoginAccount.h"

@implementation TKLoginAccount

+(instancetype)shareInstance
{
    static TKLoginAccount *shareInstance = nil;
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
