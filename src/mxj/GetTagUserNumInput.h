//
//  GetTagUserNumInput.h
//  mxj
//  查询标签使用用户数
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetTagUserNumInput : BaseInput

@property(nonatomic, copy) NSString *tagId; //标签Id

+(instancetype)shareInstance;

@end
