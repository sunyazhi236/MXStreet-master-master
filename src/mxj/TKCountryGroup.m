//
//  TKCountryGroup.m
//  mxj
//  国家分组用模型
//  Created by 齐乐乐 on 15/12/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "TKCountryGroup.h"

@implementation TKCountryGroup

- (instancetype)init
{
    self = [super init];
    self.groupName = @"";
    self.countryListInfo = [[NSMutableArray alloc] init];
    
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}

@end
