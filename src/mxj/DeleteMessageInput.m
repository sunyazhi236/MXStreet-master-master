//
//  DeleteMessageInput.m
//  mxj
//  删除私信用输入模型
//  Created by 齐乐乐 on 16/2/2.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "DeleteMessageInput.h"

@implementation DeleteMessageInput

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
