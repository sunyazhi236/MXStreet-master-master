//
//  AddStreetsnapTagInput.h
//  mxj
//
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface AddStreetsnapTagInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId;  //街拍Id
@property(nonatomic, copy) NSString *tagId;         //标签Id
@property(nonatomic, copy) NSString *photoNo;       //图片号
@property(nonatomic, copy) NSString *horizontal;    //横坐标
@property(nonatomic, copy) NSString *vertical;      //纵坐标
@property(nonatomic, copy) NSString *link;          //链接

+(instancetype)shareInstance;

@end
