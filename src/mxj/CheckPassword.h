//
//  CheckPassword.h
//  mxj
//
//  Created by 齐乐乐 on 16/1/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface CheckPassword : BaseModel

@property(nonatomic, copy) NSString *flag; //校验结果（0：密码已更新， 1：密码未变）

@end
