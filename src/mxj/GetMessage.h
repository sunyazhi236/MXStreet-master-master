//
//  GetMessage.h
//  mxj
//  私信内容
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseModel.h"

@interface GetMessage : BaseModel

@property(nonatomic, copy) NSString *totalnum;  //总行数
@property(nonatomic, copy) NSString *totalpage; //总页数
@property(nonatomic, copy) NSArray<GetMessageInfo *> *info;

@end
