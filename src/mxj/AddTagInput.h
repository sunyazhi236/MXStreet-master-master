//
//  AddTagInput.h
//  mxj
//  添加标签
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface AddTagInput : BaseInput

@property(nonatomic, copy) NSString *userId;  //用户Id
@property(nonatomic, copy) NSString *tagName; //标签名

+(instancetype)shareInstance;

@end
