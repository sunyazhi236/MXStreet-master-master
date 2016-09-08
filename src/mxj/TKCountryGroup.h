//
//  TKCountryGroup.h
//  mxj
//  国家分组用模型
//  Created by 齐乐乐 on 15/12/29.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCountryGroup : NSObject

@property(nonatomic, copy) NSString *groupName;                      //分组名称
@property(nonatomic, strong) NSMutableArray<GetCountryListInfo *> *countryListInfo;    //分组国家成员

@end
