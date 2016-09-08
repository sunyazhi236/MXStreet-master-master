//
//  CheckMaoxjStatusInput.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface CheckMaoxjStatusInput : BaseInput

@property(nonatomic, copy) NSString *pagesize;         //每页行数
@property(nonatomic, copy) NSString *current;          //页号
@property(nonatomic, copy) NSString *type;             //标识（0：微信，1：QQ，2：手机，3：微博）
@property(nonatomic, copy) NSString *searchParams;     //查询对象（以逗号分隔开）

+(instancetype)shareInstance;

@end
