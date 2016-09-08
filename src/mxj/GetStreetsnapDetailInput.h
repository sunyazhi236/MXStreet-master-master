//
//  GetStreetsnapDetailInput.h
//  mxj
//  查询街拍详情
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetStreetsnapDetailInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId; //街拍Id
@property(nonatomic, copy) NSString *userId;       //当前用户Id

+(instancetype)shareInstance;

@end
