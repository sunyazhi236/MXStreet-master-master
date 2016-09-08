//
//  DeleteStreetsnapInput.h
//  mxj
//  删除街拍
//  Created by 齐乐乐 on 15/12/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface DeleteStreetsnapInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId;  //街拍Id
@property(nonatomic, copy) NSString *userId;        //用户Id

+(instancetype)shareInstance;

@end
