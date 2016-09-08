//
//  GetCountryListInput.h
//  mxj
//  查询国家列表用输入模型
//  Created by 齐乐乐 on 15/12/22.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetCountryListInput : BaseInput

@property(nonatomic, copy) NSString *pagesize; //每页行数
@property(nonatomic, copy) NSString *current;  //页号

+(instancetype)shareInstance;

@end
