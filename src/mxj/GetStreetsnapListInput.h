//
//  GetStreetsnapListInput.h
//  mxj
//  街拍列表接口输入模型
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetStreetsnapListInput : BaseInput

@property(nonatomic, copy) NSString *pagesize; //每页行数
@property(nonatomic, copy) NSString *current;  //页号
@property(nonatomic, copy) NSString *userId;   //用户Id
@property(nonatomic, copy) NSString *place;    //位置
@property(nonatomic, copy) NSString *type;     //查询类型 0:我的街拍 1:关注 2:人气 3:同城 4:无条件查询
@property(nonatomic, copy) NSString *cityFlag; //城市标识（0：定位城市; 1:切换城市， type为3时必填）

+(instancetype)shareInstance;

@end
