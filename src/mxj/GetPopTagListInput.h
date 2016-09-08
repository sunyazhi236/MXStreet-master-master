//
//  GetPopTagListInput.h
//  mxj
//  热门标签列表输入模型
//  Created by 齐乐乐 on 16/1/19.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetPopTagListInput : BaseInput

@property(nonatomic, copy) NSString *pagesize; //每页行数
@property(nonatomic, copy) NSString *current;  //页号
@property(nonatomic ,copy) NSString *type;
@property(nonatomic,copy) NSString *userId;
//@property(nonatomic, copy) NSString *userName;
//@property(nonatomic ,copy) NSString *tagName;
+(instancetype)shareInstance;

@end
