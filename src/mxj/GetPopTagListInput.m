//
//  GetPopTagListInput.m
//  mxj
//
//  Created by 齐乐乐 on 16/1/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "GetPopTagListInput.h"

@implementation GetPopTagListInput

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
