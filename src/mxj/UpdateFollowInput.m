//
//  UpdateFollwInput.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/4.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "UpdateFollowInput.h"

@implementation UpdateFollwInput

+(instancetype)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] initWithNull];
    });
    
    return shareInstance;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}

@end