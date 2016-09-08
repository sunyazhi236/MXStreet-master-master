//
//  BaseModel.m
//  mxj
//  模型基类
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//用字典初始化模型实例方法
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        if ((nil != [dict objectForKey:@"data"]) && (NO == [@"" isEqualToString:[dict objectForKey:@"data"]])) {
            [self setValuesForKeysWithDictionary:[dict objectForKey:@"data"]];
        }
    }
    return self;
}

//用字典初始化模型类方法
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (NSString *) className
{
    return NSStringFromClass([self class]);
}

- (void)objectFromDictionary:(NSDictionary*)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    unsigned int propCount, i;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    
    for (i = 0; i < propCount; i++)
    {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if(propName)
        {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [dict objectForKey:name];
            //NSString *objClassName = [obj className];
            if (!obj)
                continue;
            if ([[obj className] isEqualToString:@"__NSCFString"]
                || [[obj className] isEqualToString:@"__NSCFConstantString"]
                || [[obj className] isEqualToString:@"NSTaggedPointerString"]
                || [[obj className] isEqualToString:@"__NSCFNumber"]
                || [[obj className] isEqualToString:@"__NSCFBoolean"]
                || [[obj className] isEqualToString:@"__NSCFArray"]
                || [obj isKindOfClass:[NSString class]]
                || [obj isKindOfClass:[NSArray class]]
                || [obj isKindOfClass:[NSNumber class]]
                )
            {
                [self setValue:obj forKeyPath:name];
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                id subObj = [self valueForKey:name];
                if (subObj)
                    [subObj objectFromDictionary:obj];
            }
        }
    }
    free(properties);
}

#pragma mark -共通方法
//将json字符串转换为字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (nil == jsonString) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        DLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}

@end
