//
//  GetBannerListInput.h
//  mxj
//  取得广告banner列表
//  Created by 齐乐乐 on 15/12/1.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface GetBannerListInput : BaseInput

@property(nonatomic, copy) NSString *pagesize; //每页行数
@property(nonatomic, copy) NSString *current;  //页号

+(instancetype)shareInstance;

@end
