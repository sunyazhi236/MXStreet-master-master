//
//  BaseInput.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/28.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@implementation BaseInput

//初始化方法，所有的内容均设置为空字符串
-(instancetype)initWithNull
{
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [self setValue:@"" forKey:propertyName];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
