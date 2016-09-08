//
//  CollectionInput.h
//  mxj
//  收藏
//  Created by 齐乐乐 on 15/12/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface CollectionInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId;     //街拍Id
@property(nonatomic, copy) NSString *streetsnapUserId; //街拍用户Id
@property(nonatomic, copy) NSString *userId;           //用户Id
@property(nonatomic, copy) NSString *flag;             //标识(0:收藏,1:取消收藏)

+(instancetype)shareInstance;

@end
